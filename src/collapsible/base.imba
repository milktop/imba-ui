import * as zagCollapsible from '@zag-js/collapsible'
import { Machine, uid, defined } from '../zag.imba'
import { icons } from '../icons.imba'

# Headless collapsible: a section that opens and closes, animating its height.
#
#   <ui-collapsible heading='Lesson notes'> …
#   <ui-collapsible bind=open>
#     <ui-button slot='trigger'> 'Show more'
#     …
#
# `heading` renders a built-in toggle with a chevron; or put your own element
# in the `trigger` slot (Zag's props go straight onto it). Bind the open
# state with `bind=` or `bind:open=`; `openchange` is emitted with it.
tag ui-collapsible-base
	prop open = false
	prop heading = null
	prop disabled = false

	zagId = uid('collapsible')

	# `bind=` targets `data`, which aliases `open` here.
	get data do open
	set data v do open = v

	get trigger do $triggerSlot..firstElementChild

	def setup
		let initial = !!data
		machine = new Machine self, zagCollapsible.machine, do defined({
			id: zagId
			disabled: disabled
			defaultOpen: initial
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
		trigger.zag = machine.connect(zagCollapsible).getTriggerProps! if trigger

	def render
		machine.syncValue !!data, do
			machine.connect(zagCollapsible).setOpen(!!data)

		let api = machine.connect(zagCollapsible)
		trigger.zag = api.getTriggerProps! if trigger and !heading

		<self zag=api.getRootProps!>
			if heading
				<button.toggle zag=api.getTriggerProps!>
					<span.heading> heading
					<span.indicator zag=api.getIndicatorProps!> <ui-icon path=icons.down>
			else
				<span$triggerSlot.trigger-slot> <slot name='trigger'>
			<div.content zag=api.getContentProps!>
				<div.inner> <slot>
