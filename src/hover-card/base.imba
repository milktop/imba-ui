import * as hoverCard from '@zag-js/hover-card'
import { Machine, Presence, uid, defined } from '../zag.imba'

# Headless hover card: a richer preview that opens while the pointer rests
# on (or keyboard focus is on) a trigger, e.g. a person's details over their
# name.
#
#   <ui-hover-card>
#     <a slot='trigger' href='/students/1'> 'Ada Lovelace'
#     …card content…
#
# Like ui-tooltip, Zag's trigger props go straight onto the element in the
# `trigger` slot. It stays open while the pointer is over the card, so its
# content can be selected or clicked. Previews are for pointer and keyboard
# users; keep anything essential reachable another way (touch has no hover).
#
# - `placement`: 'bottom' (default), 'top', 'right-start', …
# - `openDelay`, `closeDelay`: in ms (400 and 200 by default)
# - `arrow`: points the card at its trigger
tag ui-hover-card-base
	prop placement = 'bottom'
	prop openDelay = 400
	prop closeDelay = 200
	prop arrow = false
	prop disabled = false

	zagId = uid('hover-card')
	presence = new Presence(self, 200)

	get trigger do $triggerSlot..firstElementChild

	def setup
		machine = new Machine self, hoverCard.machine, do defined({
			id: zagId
			openDelay, closeDelay, disabled
			positioning: { placement, strategy: 'fixed', gutter: 8 }
		})

	def mount do machine.start!
	def unmount do machine.stop!

	# Applied in render as well, since Machine re-renders without Imba's
	# `rendered` hook; the trigger only exists after the first render.
	def rendered
		trigger.zag = machine.connect(hoverCard).getTriggerProps! if trigger

	def render
		machine.watch "{disabled}|{placement}"
		let api = machine.connect(hoverCard)
		trigger.zag = api.getTriggerProps! if trigger
		presence.update(api.open)

		<self>
			<span$triggerSlot.trigger-slot> <slot name='trigger'>
			<div.positioner zag=api.getPositionerProps!>
				<div.content zag=presence.keep(api.getContentProps!) @animationend=presence.done!>
					if arrow
						<div.arrow zag=api.getArrowProps!> <div.arrow-tip zag=api.getArrowTipProps!>
					<slot>
