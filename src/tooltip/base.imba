import * as tooltip from '@zag-js/tooltip'
import { Machine, uid, defined } from '../zag.imba'

# Headless tooltip around one trigger element:
#
#   <ui-tooltip content='Show password'>
#     <button aria-label='Show password'> …
#
# Zag's trigger props go straight onto that first child, so it keeps its own
# focus, clicks and label and gains aria-describedby (Zag also sets its id).
# It opens on hover (straight away unless `openDelay` is set) and on keyboard
# focus, and closes on Escape, click or scroll. Disabled elements fire no events, so wrap those in
# a span.
#
# - `content`: the text; a `content` slot takes richer markup instead
# - `placement`: 'top', 'bottom-start', … (positioned with fixed strategy, so
#   overflow: hidden ancestors don't clip it)
# - `interactive`: keeps it open while the pointer is over it
tag ui-tooltip-base
	prop content = null
	prop placement = 'top'
	prop openDelay = 0
	prop closeDelay = null
	prop interactive = false
	prop disabled = false

	zagId = uid('tooltip')

	get trigger do $triggerSlot..firstElementChild

	def setup
		machine = new Machine self, tooltip.machine, do defined({
			id: zagId
			openDelay, closeDelay, interactive, disabled
			positioning: { placement, strategy: 'fixed', gutter: 8 }
		})

	def mount do machine.start!
	def unmount do machine.stop!

	# Applied in render as well, since Machine re-renders without Imba's
	# `rendered` hook; the trigger only exists after the first render.
	def rendered
		trigger.zag = machine.connect(tooltip).getTriggerProps! if trigger

	# Zag hides the content as soon as it closes; keep it shown while its exit
	# animation runs, with a timeout in case there is none. Moving straight to
	# another tooltip (Zag's `instant`) hides it at once, so two don't overlap.
	def leaving open, instant
		if open or instant
			#leaving = no
		elif #wasOpen
			#leaving = yes
			clearTimeout(#leaveTimer)
			#leaveTimer = setTimeout(&, 250) do finishLeaving!
		#wasOpen = open
		#leaving

	def finishLeaving
		return unless #leaving
		#leaving = no
		render!

	def render
		let api = machine.connect(tooltip)
		trigger.zag = api.getTriggerProps! if trigger
		let contentProps = api.getContentProps!
		let instant = contentProps['data-instant'] !== undefined
		contentProps = Object.assign({}, contentProps, hidden: false) if leaving(api.open, instant)

		<self>
			<span$triggerSlot.trigger-slot> <slot>
			<div.positioner zag=api.getPositionerProps!>
				<div.content zag=contentProps @animationend=finishLeaving>
					<div.arrow zag=api.getArrowProps!> <div.arrow-tip zag=api.getArrowTipProps!>
					<slot name='content'> content
