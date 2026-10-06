import * as zagMenu from '@zag-js/menu'
import { Machine, Presence, uid, defined } from '../zag.imba'
import { itemLabel, itemValue, itemDisabled } from '../items.imba'
import 'iconify-icon'

# The closest element above `el` with `flag` set, e.g. the menu (or
# submenu) an item belongs to.
def closestWith el, flag
	let node = el.parentElement
	node = node.parentElement until !node or node[flag]
	node

def closestMenu el do closestWith(el, 'isUiMenu')

# Headless dropdown menu of actions from a trigger.
#
#   <ui-menu items=actions @select=run(e.detail)>
#     <ui-button slot='trigger' iconEnd='lucide:chevron-down'> 'Actions'
#
#   <ui-menu @select=run(e.detail)>
#     <ui-button slot='trigger'> 'File'
#     <ui-menu-item value='new' icon='lucide:file-plus' shortcut='⌘N'> 'New'
#     <ui-submenu label='Share' icon='lucide:share-2'>
#       <ui-menu-item value='email'> 'Email'
#     <ui-menu-separator>
#     <ui-menu-group label='Danger zone'>
#       <ui-menu-item value='delete' danger> 'Delete'
#
#   <ui-menu items=[{ type: 'checkbox', value: 'grid', label: 'Grid', checked: yes }]
#     @change=save(e.detail)>
#
# Arrow keys move through the items (right and left open and close
# submenus), typing jumps to one, Enter selects, and Escape or a click outside
# closes it, returning focus to the trigger. Items come from `items`, from
# child tags (after any `items`), or both.
#
# - `items`: strings or objects with `labelKey`/`valueKey`/`disabledKey` (the
#   label stands in for a missing value), plus optional `icon` (Iconify),
#   `shortcut` text, `danger` and `href` (a link); `{ separator: true }`
#   draws a line, `{ group: 'Label' }` a group heading, and `{ label, icon,
#   items: […] }` a submenu with its own items
# - Checkbox and radio entries: `{ type: 'checkbox', value, label, checked }`,
#   and `{ type: 'radio', name, value, label, checked }` (one checked per
#   `name`). The menu updates `checked` on the entries and emits `change` with
#   `{ type, name, value, checked }`
# - `placement`: 'bottom-start' (default), 'bottom-end', …
# - `label`: a small label above the items, styled like a group heading
# - `keepOpen`: stay open after an item is chosen (e.g. to tick several
#   checkboxes); an item's own `keepOpen` (entry or prop) overrides it, and
#   submenus follow their menu's unless they set one
# - Child tags: `ui-menu-item`, `ui-menu-separator`, `ui-menu-group`,
#   `ui-submenu`, `ui-menu-checkbox` and `ui-menu-radio-group` with
#   `ui-menu-radio`s, which take the same options as props
# - Links render `<a href>`; for Inertia, subclass ui-menu and set
#   `linkTag = 'inertia-link'` (its items and submenus follow it)
#
# Emits `select` with the chosen action's original value, from any submenu
# too (checkbox and radio items emit `change` instead).
tag ui-menu-base
	prop items = []
	prop labelKey = 'label'
	prop valueKey = 'value'
	prop disabledKey = 'disabled'
	prop placement = 'bottom-start'
	prop label = null
	prop keepOpen = null

	isUiMenu = yes
	isSubmenu = no
	zagId = uid('menu')
	presence = new Presence(self, 200)
	# The element for items with an `href`; submenus use their menu's.
	linkTag = null
	# Child tags (items, groups, separators, submenus), re-rendered with the menu.
	parts = new Set

	get api do machine.connect(zagMenu)
	get parentMenu do null
	get keepsOpen do keepOpen ?? parentMenu..keepsOpen ?? no
	get linkElement do linkTag or parentMenu..linkElement or 'a'
	get trigger do $triggerSlot..firstElementChild

	# Actions, as opposed to separators, group headings, submenus and checkbox
	# or radio items.
	def isAction item do !(typeof item == 'object' and item and (item.separator or item.group or item.items or isOption(item)))
	def isSubmenuItem item do typeof item == 'object' and !!item..items
	def isOption item do typeof item == 'object' and !!item and (item.type === 'checkbox' or item.type === 'radio')

	# An entry's value, or its label when it has none, and Zag's string key.
	def entryValue item do itemValue(item, valueKey) ?? itemLabel(item, labelKey)
	def entryKey item do String(entryValue(item))

	# The original value of the action with Zag's key `key`: from `items`, or
	# from a child ui-menu-item (undefined for checkbox and radio items).
	def valueFor key
		let item = (items or []).filter(do isAction($1)).find(do entryKey($1) === key)
		return entryValue(item) unless item === undefined
		let part = Array.from(parts).find(do $1.isUiMenuItem and !$1.isUiMenuOption and $1.key === key)
		part ? part.itemValue : undefined

	# Zag's props for a checkbox or radio entry in `items`. Radio keys include
	# their `name`, so two groups can share values.
	def optionProps item
		let key = entryKey(item)
		{
			type: item.type
			value: item.type === 'radio' ? "{item.name ?? ''}/{key}" : key
			checked: !!item.checked
			disabled: itemDisabled(item, disabledKey)
			valueText: itemLabel(item, labelKey)
			closeOnSelect: closeFor(item.keepOpen)
			onCheckedChange: do(checked) check(item, checked)
		}

	# Zag's per-item closeOnSelect for a `keepOpen` (unset follows the menu).
	def closeFor keepOpen do keepOpen == null ? undefined : !keepOpen

	def check item, checked
		if item.type === 'radio'
			return if item.checked
			for other in items
				other.checked = no if isOption(other) and other.type === 'radio' and other.name == item.name
		item.checked = checked
		emit('change', { type: item.type, name: item.name ?? null, value: entryValue(item), checked })

	def setup
		machine = new Machine self, zagMenu.machine, do defined({
			id: zagId
			positioning: { placement, strategy: 'fixed', gutter: 4 }
			closeOnSelect: !keepsOpen
			# Enter on a link: Zag's own click doesn't bubble, so routers
			# listening on the document (Imba's) would miss it.
			navigate: do(details) details.node.click!
			onSelect: do(details)
				let value = valueFor(details.value)
				emit('select', value) unless value === undefined
		})

	def mount do machine.start!
	def unmount do machine.stop!

	# Applied in render as well, since Machine re-renders without Imba's
	# `rendered` hook; the trigger only exists after the first render.
	def rendered
		trigger.zag = triggerProps(machine.connect(zagMenu)) if trigger

	# The trigger's props; ui-context-menu swaps in Zag's context trigger.
	def triggerProps api do api.getTriggerProps!

	# The row that opens a submenu; only ui-submenu has one.
	def triggerItemProps api do {}

	def render
		# Zag reads the placement lazily; e.g. ui-sidebar-user changes it in the rail.
		machine.watch "{placement} {keepsOpen}"
		let api = machine.connect(zagMenu)
		trigger.zag = triggerProps(api) if trigger
		presence.update(api.open)
		part.render! for part in Array.from(parts)

		<self data-ui-menu>
			if isSubmenu
				<div.item.trigger-item zag=triggerItemProps(api)>
					if icon
						<iconify-icon.icon icon=icon aria-hidden='true'>
					<span.label> label
					<iconify-icon.chevron icon='lucide:chevron-right' aria-hidden='true'>
			else
				<span$triggerSlot.trigger-slot> <slot name='trigger'>
			<div.positioner zag=api.getPositionerProps!>
				<div.content zag=presence.keep(api.getContentProps!) @animationend.self=presence.done!>
					if label and !isSubmenu
						<div.group-label.menu-label> label
					for item in items
						if item..separator
							<div.separator zag=api.getSeparatorProps!>
						elif item..group
							<div.group-label> item.group
						elif isOption(item)
							<div.item .danger=!!item.danger zag=api.getOptionItemProps(optionProps(item))>
								<span.indicator>
									<span.mark.{item.type} zag=api.getItemIndicatorProps(optionProps(item))>
										if item.type === 'checkbox'
											<iconify-icon icon='lucide:check' aria-hidden='true'>
								if item.icon
									<iconify-icon.icon icon=item.icon aria-hidden='true'>
								<span.label> itemLabel(item, labelKey)
								if item.shortcut
									<kbd.shortcut> item.shortcut
						elif isSubmenuItem(item)
							<ui-submenu-base items=item.items label=itemLabel(item, labelKey) icon=item.icon labelKey=labelKey valueKey=valueKey disabledKey=disabledKey>
						else
							<{item..href ? linkElement : 'div'}.item .danger=!!item..danger href=(item..href or undefined) zag=api.getItemProps(value: entryKey(item), valueText: itemLabel(item, labelKey), disabled: itemDisabled(item, disabledKey), closeOnSelect: closeFor(item..keepOpen))>
								if item..icon
									<iconify-icon.icon icon=item.icon aria-hidden='true'>
								<span.label> itemLabel(item, labelKey)
								if item..shortcut
									<kbd.shortcut> item.shortcut
					<slot>

# A submenu inside a ui-menu (or another submenu): a row that opens a nested
# menu of its own items, from `items` or child tags like ui-menu's.
#
#   <ui-submenu label='Share' icon='lucide:share-2'>
#     <ui-menu-item value='email'> 'Email'
#
# - `label`: the row's text; `icon` an optional Iconify icon before it
#
# Its items' `select` reaches the outer menu's listeners.
tag ui-submenu-base < ui-menu-base
	prop icon = null

	isSubmenu = yes

	get parentMenu do #outer

	def mount
		#outer = closestMenu(self)
		#outer..parts.add(self)
		machine.start!
		link!

	def unmount
		#outer..parts.delete(self)
		machine.stop!

	# Zag ties nested menus together through both services, once both run.
	def link
		return if #linked or !#outer
		unless #outer.machine.running
			globalThis.queueMicrotask do link!
			return
		#linked = yes
		#outer.api.setChild(machine.service.service)
		api.setParent(#outer.machine.service.service)
		render!

	def triggerItemProps api
		#linked ? #outer.api.getTriggerItemProps(api) : {}

# One action in a ui-menu or ui-submenu; its content is the label.
#
#   <ui-menu-item value='edit' icon='lucide:pencil' shortcut='⌘E'> 'Edit'
#
# - `value`: what the menu's `select` emits (the label's text if unset)
# - `href`: makes it a link (the menu's `linkTag`, `<a>` by default)
# - `icon`, `shortcut`, `danger`, `disabled` and `keepOpen`: as on `items` entries
#
# An item's own `@click` runs when it's chosen, by pointer or keyboard.
tag ui-menu-item-base
	prop value = null
	prop href = null
	prop icon = null
	prop shortcut = null
	prop danger = false
	prop disabled = false
	prop keepOpen = null

	isUiMenuItem = yes

	get menu do #menu or closestMenu(self)
	get text do (querySelector('.label')..textContent or '').trim!
	get itemValue do value ?? text
	# Zag's string key for the item.
	get key do String(self.itemValue)
	get closeOnSelect do keepOpen == null ? undefined : !keepOpen

	def mount
		#menu = closestMenu(self)
		#menu..parts.add(self)
		render!

	def unmount do #menu..parts.delete(self)

	# Checkbox and radio items set these.
	optionType = null
	def optionProps do null

	def itemProps api
		optionType ? api.getOptionItemProps(optionProps!) : api.getItemProps(value: key, valueText: text, disabled: !!disabled, closeOnSelect: closeOnSelect)

	# The item is an element inside the tag, so it can be a link.
	def render
		let api = menu..machine ? menu.api : null
		<self data-ui-menu-item>
			<{href ? (menu..linkElement or 'a') : 'div'}.item .danger=!!danger href=(href or undefined) zag=(api ? itemProps(api) : undefined)>
				if optionType
					<span.indicator>
						<span.mark.{optionType} zag=(api ? api.getItemIndicatorProps(optionProps!) : undefined)>
							if optionType === 'checkbox'
								<iconify-icon icon='lucide:check' aria-hidden='true'>
				if icon
					<iconify-icon.icon icon=icon aria-hidden='true'>
				<span.label> <slot>
				if shortcut
					<kbd.shortcut> shortcut

# A line between items in a ui-menu or ui-submenu.
tag ui-menu-separator-base
	get menu do #menu or closestMenu(self)

	def mount
		#menu = closestMenu(self)
		#menu..parts.add(self)
		render!

	def unmount do #menu..parts.delete(self)

	def render
		<self.separator zag=(menu..machine ? menu.api.getSeparatorProps! : undefined)>

# A group of items in a ui-menu or ui-submenu, under a heading.
#
#   <ui-menu-group label='Student'>
#     <ui-menu-item value='message'> 'Send message'
#
# - `label`: the heading (optional)
tag ui-menu-group-base
	prop label = null

	groupId = uid('group')

	get menu do #menu or closestMenu(self)

	def mount
		#menu = closestMenu(self)
		#menu..parts.add(self)
		render!

	def unmount do #menu..parts.delete(self)

	def render
		let api = menu..machine ? menu.api : null
		<self zag=(api ? api.getItemGroupProps(id: groupId) : undefined)>
			if label
				<div.group-label zag=(api ? api.getItemGroupLabelProps(htmlFor: groupId) : undefined)> label
			<slot>

# A checkbox item in a ui-menu or ui-submenu; its content is the label.
#
#   <ui-menu-checkbox bind=showGrid> 'Show grid'
#
# - `checked`: whether it's ticked (`bind=` works too)
# - `value`, `icon`, `shortcut`, `disabled` and `keepOpen`: as on ui-menu-item
#
# Emits `change` with the new checked state (it doesn't bubble to the menu).
tag ui-menu-checkbox-base < ui-menu-item-base
	prop checked = false

	isUiMenuOption = yes
	optionType = 'checkbox'

	get data do checked
	set data v do checked = v

	def optionProps
		{ type: 'checkbox', value: key, checked: !!data, disabled: !!disabled, valueText: text, closeOnSelect: closeOnSelect, onCheckedChange: do(c) toggle(c) }

	def toggle c
		data = c
		emit('change', data, bubbles: no)

# Radio items in a ui-menu or ui-submenu, one of which is checked: the
# group's value is the checked ui-menu-radio's value.
#
#   <ui-menu-radio-group bind=sort label='Sort by'>
#     <ui-menu-radio value='name'> 'Name'
#     <ui-menu-radio value='date'> 'Date'
#
# - `value`: the checked radio's value (`bind=` works too)
# - `label`: an optional heading, as on ui-menu-group
#
# Emits `change` with the new value (it doesn't bubble to the menu).
tag ui-menu-radio-group-base < ui-menu-group-base
	prop value = null

	isUiMenuRadioGroup = yes

	get data do value
	set data v do value = v

	def choose v
		return if data === v
		data = v
		emit('change', data, bubbles: no)

# One radio item in a ui-menu-radio-group; its content is the label.
#
# - `value`: what the group's value becomes (the label's text if unset)
# - `icon`, `shortcut`, `disabled` and `keepOpen`: as on ui-menu-item
tag ui-menu-radio-base < ui-menu-item-base
	isUiMenuOption = yes
	optionType = 'radio'

	get group do closestWith(self, 'isUiMenuRadioGroup')
	# Keyed by group, so two groups can share values.
	get key do "{group..groupId}/{self.itemValue}"
	get checked do !!group and group.data != null and String(group.data) === String(self.itemValue)

	def optionProps
		{ type: 'radio', value: key, checked: checked, disabled: !!disabled, valueText: text, closeOnSelect: closeOnSelect, onCheckedChange: do group..choose(self.itemValue) }
