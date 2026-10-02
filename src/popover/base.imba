import * as popover from '@zag-js/popover'
import { Machine, uid, defined } from '../zag.imba'
import { icons } from '../icons.imba'

# Headless popover: a trigger that opens a floating panel.
#
#   <ui-popover heading='Lesson' description='Move or cancel it'>
#     <button slot='trigger'> 'Edit'
#     …panel content…
#
# Like ui-tooltip, Zag's trigger props go straight onto the element in the
# `trigger` slot. Focus moves into the panel when it opens and back to the
# trigger when it closes; Escape and clicks outside close it.
#
# - `heading`, `description`: labelled and described for assistive tech
# - `closable`: shows a close button
# - `arrow`: points the panel at its trigger
# - `modal`: traps focus and blocks the page behind it
#
# Bind the open state with `bind=` or `bind:open=`; `openchange` is emitted
# with the new state.
tag ui-popover-base
	prop open = false
	prop heading = null
	prop description = null
	prop placement = 'bottom'
	prop closable = false
	prop arrow = false
	prop modal = false

	zagId = uid('popover')

	# `bind=` targets `data`, which aliases `open` here.
	get data do open
	set data v do open = v

	get trigger do $triggerSlot..firstElementChild

	def setup
		let initial = !!data
		machine = new Machine self, popover.machine, do defined({
			id: zagId
			modal: modal
			# Rendered in place, not portalled, which affects focus order.
			portalled: false
			defaultOpen: initial
			positioning: { placement, strategy: 'fixed', gutter: 8 }
			onOpenChange: do(details)
				data = details.open
				emit('openchange', data) if machine.track(data)
		})
		machine.track(initial)

	def mount do machine.start!
	def unmount do machine.stop!

	# Applied in render as well, since Machine re-renders without Imba's
	# `rendered` hook; the trigger only exists after the first render.
	def rendered
		trigger.zag = machine.connect(popover).getTriggerProps! if trigger

	def render
		machine.syncValue !!data, do
			machine.connect(popover).setOpen(!!data)

		let api = machine.connect(popover)
		trigger.zag = api.getTriggerProps! if trigger

		<self>
			<span$triggerSlot.trigger-slot> <slot name='trigger'>
			<div.positioner zag=api.getPositionerProps!>
				<div.content zag=api.getContentProps!>
					if arrow
						<div.arrow zag=api.getArrowProps!> <div.arrow-tip zag=api.getArrowTipProps!>
					if closable
						<button.close zag=api.getCloseTriggerProps!> <ui-icon path=icons.x size=14>
					if heading or description
						<div.header>
							if heading
								<div.heading zag=api.getTitleProps!> heading
							if description
								<p.description zag=api.getDescriptionProps!> description
					<slot>
