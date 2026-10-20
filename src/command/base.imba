import * as dialog from '@zag-js/dialog'
import * as listbox from '@zag-js/listbox'
import { Machine, Presence, uid, defined } from '../zag.imba'
import { icons } from '../icons.imba'
import 'iconify-icon'
import { uiLocale } from '../locale.imba'

# Headless command menu (⌘K): a dialog with a search box over a list of
# commands, filtered as you type.
#
#   <ui-command items=commands @select=run(e.detail)>
#     <ui-command-trigger slot='trigger'>
#
# ⌘K (Ctrl+K elsewhere) opens and closes it; ↑/↓ move through the results,
# Enter picks one, Escape closes it. The `trigger` slot takes any button:
# ui-command-trigger is a search box showing the shortcut. It's optional;
# bind the open state with `bind=` (or `bind:open=`) instead.
#
# - `items`: objects with `label`, plus optional `value`, `group` (a heading
#   the item is listed under), `icon` (Iconify), `description`, `shortcut`
#   text, `keywords` (extra words to match) and `disabled`. An item with
#   `href` goes there when picked.
# - `load`: optional async function(query) returning more items, for server
#   search. They're listed after the matching `items`, which filter as you
#   type while the search runs.
# - `hotkey`: the key used with ⌘/Ctrl; null turns the shortcut off
# - `navigate`: function(href) for items with `href`, e.g. Inertia's
#   `router.visit`. By default a link is clicked, which Imba's router picks up.
# - `hints`: false hides the keyboard hints along the bottom
#
# Emits `select` with the item's `value` (or the item, if it has none).

# How the shortcut reads on this platform: '⌘K' or 'Ctrl K'.
export def formatHotkey key = 'k'
	let mac = /Mac|iPhone|iPad/.test(globalThis.navigator..platform or '')
	mac ? "⌘{key.toUpperCase!}" : "Ctrl {key.toUpperCase!}"

tag ui-command-base
	prop open = false
	prop items = []
	prop label = null
	prop placeholder = null
	prop emptyText = null
	prop loadingText = null
	prop hotkey = 'k'
	prop load = null
	prop debounce = 200
	prop navigate = null
	prop hints = true

	zagId = uid('command')
	presence = new Presence(self)
	query = ''
	loading = no
	#groups = []
	#results = []
	#local = []
	#loaded = []
	#sourceItems = null
	#ticket = 0

	# `bind=` targets `data`, which aliases `open` here.
	get data do open
	set data v do open = v

	# How a ui-command-trigger finds its menu.
	get isUiCommand do yes
	get trigger do $triggerSlot..firstElementChild
	# The shortcut as it reads here ('⌘K'), for a trigger's hint.
	get hotkeyText do hotkey ? formatHotkey(hotkey) : null

	# Zag's key for an item.
	def keyOf item do String(item.value ?? item.href ?? item.label)

	# Lowercase without accents, so "tache" finds "Tâches".
	def fold text
		String(text).normalize('NFD').replace(/\p{M}/gu, '').toLowerCase!

	# Every word typed must appear in the label, description, group or keywords.
	def matches item, words
		let text = fold([item.label, item.description, item.group, ...(item.keywords or [])].join(' '))
		words.every(do text.includes($1))

	# Results in group order (by first appearance), so the list reads and the
	# arrow keys move the same way.
	def setResults list
		let names = []
		for item in list
			names.push(item.group or '') unless names.includes(item.group or '')
		#groups = names.map do(name) { name: name, items: list.filter(do ($1.group or '') == name) }
		#results = #groups.flatMap(do $1.items)
		#collection = listbox.collection
			items: #results
			itemToString: do(item) item.label
			itemToValue: do(item) keyOf(item)
			isItemDisabled: do(item) !!item.disabled

	def filterLocal text
		let words = fold(text).split(/\s+/).filter(Boolean)
		#local = words.length ? (items or []).filter(do matches($1, words)) : (items or [])
		setResults([...#local, ...#loaded])

	# The items filter at once; loaded results from the last search stay
	# below them until the new ones arrive.
	def search text
		query = text
		filterLocal(text)
		listMachine.refresh!
		return unless load
		let ticket = ++#ticket
		loading = yes
		render!
		clearTimeout(#timer)
		#timer = setTimeout(&, debounce) do
			let list = await load(text)
			return unless ticket == #ticket
			loading = no
			#loaded = list or []
			setResults([...#local, ...#loaded])
			listMachine.refresh!

	def setup
		#sourceItems = items
		filterLocal('')
		let initial = !!data
		machine = new Machine self, dialog.machine, do defined({
			id: zagId
			defaultOpen: initial
			initialFocusEl: do $input
			onOpenChange: do(details)
				data = details.open
				reset! if details.open
				emit('openchange', data) if machine.track(data)
		})
		machine.track(initial)
		# The value stays empty, so picking the same command again still counts.
		listMachine = new Machine self, listbox.machine, do
			id: "{zagId}-list"
			collection: #collection
			loopFocus: yes
			value: []
			scrollToIndexFn: do(details) scrollToItem(details.getElement!)
			onSelect: do(details) choose(details.value)

	def mount
		machine.start!
		listMachine.start!
		#onKey = do(e)
			return unless hotkey and (e.metaKey or e.ctrlKey) and e.key.toLowerCase! == hotkey
			e.preventDefault!
			let api = machine.connect(dialog)
			api.setOpen(!api.open)
		globalThis.addEventListener('keydown', #onKey)

	def unmount
		globalThis.removeEventListener('keydown', #onKey)
		machine.stop!
		listMachine.stop!

	# Each time it opens: an empty search over all the commands.
	def reset
		query = ''
		#loaded = []
		$input.value = '' if $input
		$list.scrollTop = 0 if $list
		search('')
		# The first result, so Enter picks it (not whatever was highlighted
		# last time), once the new results are in the machine.
		globalThis.setTimeout(&, 0) do
			listMachine.connect(listbox).highlightFirst!

	# Keeps the highlighted item in view, scrolling only the list (not the page)
	# and showing a group's heading along with its first item.
	def scrollToItem el
		return unless el and $list
		let box = $list.getBoundingClientRect!
		let offset = do(node) node.getBoundingClientRect!.top - box.top + $list.scrollTop
		let group = el.closest('[data-part=item-group]')
		let first = group and group.querySelector('[data-part=item]') == el
		let top = offset(first ? group : el) - 4
		let bottom = offset(el) + el.offsetHeight + 4
		if top < $list.scrollTop
			$list.scrollTop = top
		elif bottom > $list.scrollTop + $list.clientHeight
			$list.scrollTop = bottom - $list.clientHeight

	def choose key
		let item = #results.find(do keyOf($1) == key)
		return unless item
		machine.connect(dialog).setOpen(false)
		emit('select', item.value === undefined ? item : item.value)
		go(item.href) if item.href

	def go href
		return navigate(href) if navigate
		let link = globalThis.document.createElement('a')
		link.href = href
		globalThis.document.body.appendChild(link)
		link.click!
		link.remove!

	# Applied in render as well, since Machine re-renders without Imba's
	# `rendered` hook; the trigger only exists after the first render.
	def rendered
		trigger.zag = machine.connect(dialog).getTriggerProps! if trigger

	def render
		# New items from the parent replace the list (keeping the search).
		if items !== #sourceItems
			#sourceItems = items
			filterLocal(query)
			listMachine.refresh!

		machine.syncValue !!data, do
			machine.connect(dialog).setOpen(!!data)

		let api = machine.connect(dialog)
		let list = listMachine.connect(listbox)
		trigger.zag = api.getTriggerProps! if trigger
		presence.update(api.open)

		<self>
			<span$triggerSlot.trigger-slot> <slot name='trigger'>
			<global>
				<div.backdrop zag=presence.keep(api.getBackdropProps!)>
				<div.positioner zag=api.getPositionerProps!>
					<div.content zag=presence.keep(api.getContentProps!) @animationend=presence.done!>
						<h2.sr-only zag=api.getTitleProps!> label ?? uiLocale.messages.command.label
						<div.root zag=list.getRootProps!>
							<span.sr-only zag=list.getLabelProps!> label ?? uiLocale.messages.command.label
							<div.search>
								<ui-icon.search-icon path=icons.search size=16>
								<input$input.input type='text' zag=list.getInputProps(autoHighlight: yes) placeholder=(placeholder ?? uiLocale.messages.command.placeholder) @input=search(e.target.value) @change.stop>
								<kbd.key.esc> uiLocale.messages.command.esc
							<div$list.list zag=list.getContentProps!>
								# Earlier results stay while a search runs.
								if loading and #results.length == 0
									<div.status> loadingText ?? uiLocale.messages.command.loading
								elif #results.length == 0
									<div.status> emptyText ?? uiLocale.messages.command.empty
								else
									for group, i in #groups
										<div.group zag=list.getItemGroupProps(id: "g{i}")>
											if group.name
												<div.group-label zag=list.getItemGroupLabelProps(htmlFor: "g{i}")> group.name
											for item in group.items
												<div.item zag=list.getItemProps(item: item, highlightOnHover: yes)>
													# Drawn at once: iconify-icon otherwise waits to be seen, and a
													# row reused as the results change could stay blank.
													# (html: since it reads the attribute, not a property)
													<iconify-icon.icon icon=item.icon html:noobserver=yes aria-hidden='true'> if item.icon
													<span.text>
														<span.label> item.label
														<span.description> item.description if item.description
													<kbd.shortcut> item.shortcut if item.shortcut
							if hints
								<div.hints aria-hidden='true'>
									<span>
										<kbd.key> "↑"
										<kbd.key> "↓"
										" to navigate"
									<span>
										<kbd.key> "↵"
										" to select"
