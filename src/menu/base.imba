import * as menu from '@zag-js/menu'
import { Machine, Presence, uid, defined } from '../zag.imba'
import { itemLabel, itemKey, valueForKey, itemDisabled } from '../items.imba'

# Headless dropdown menu of actions from a trigger.
#
#   <ui-menu items=actions @select=run(e.detail)>
#     <ui-button slot='trigger' iconEnd='lucide:chevron-down'> 'Actions'
#
# Arrow keys move through the items, typing jumps to one, Enter selects, and
# Escape or a click outside closes it, returning focus to the trigger.
#
# - `items`: strings or objects with `labelKey`/`valueKey`/`disabledKey`, plus
#   optional `icon` (Iconify), `shortcut` text and `danger`; `{ separator: true }`
#   draws a line and `{ group: 'Label' }` a group heading
# - `placement`: 'bottom-start' (default), 'bottom-end', …
#
# Emits `select` with the chosen item's original value.
tag ui-menu-base
	prop items = []
	prop labelKey = 'label'
	prop valueKey = 'value'
	prop disabledKey = 'disabled'
	prop placement = 'bottom-start'

	zagId = uid('menu')
	presence = new Presence(self, 200)

	get trigger do $triggerSlot..firstElementChild

	# Items that can be chosen, as opposed to separators and group headings.
	def isAction item do !(typeof item == 'object' and item and (item.separator or item.group))

	def setup
		machine = new Machine self, menu.machine, do defined({
			id: zagId
			positioning: { placement, strategy: 'fixed', gutter: 4 }
			onSelect: do(details)
				emit('select', valueForKey(items.filter(do isAction($1)), details.value, valueKey))
		})

	def mount do machine.start!
	def unmount do machine.stop!

	# Applied in render as well, since Machine re-renders without Imba's
	# `rendered` hook; the trigger only exists after the first render.
	def rendered
		trigger.zag = machine.connect(menu).getTriggerProps! if trigger

	def render
		let api = machine.connect(menu)
		trigger.zag = api.getTriggerProps! if trigger
		presence.update(api.open)

		<self>
			<span$triggerSlot.trigger-slot> <slot name='trigger'>
			<div.positioner zag=api.getPositionerProps!>
				<div.content zag=presence.keep(api.getContentProps!) @animationend=presence.done!>
					for item in items
						if item..separator
							<div.separator zag=api.getSeparatorProps!>
						elif item..group
							<div.group-label> item.group
						else
							<div.item .danger=!!item..danger zag=api.getItemProps(value: itemKey(item, valueKey), disabled: itemDisabled(item, disabledKey))>
								if item..icon
									<iconify-icon.icon icon=item.icon aria-hidden='true'>
								<span.label> itemLabel(item, labelKey)
								if item..shortcut
									<kbd.shortcut> item.shortcut
