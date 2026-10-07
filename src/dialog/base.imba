import * as dialog from '@zag-js/dialog'
import { Machine, Presence, uid, defined } from '../zag.imba'
import { icons } from '../icons.imba'

# Headless modal dialog, rendered at the end of <body> (Imba's <global>
# teleport) so no ancestor's stacking or overflow can trap it.
#
#   <ui-dialog heading='Delete lesson?' description='This cannot be undone.' bind=open>
#     <ui-button slot='trigger'> 'Delete'
#     …body…
#     <div slot='footer'> …buttons…
#
# Focus moves in and is trapped while it is open, the page behind doesn't
# scroll, Escape or a click on the backdrop closes it, and focus returns to
# the trigger. The `trigger` slot is optional; open it with `bind=` (or
# `bind:open=`) instead. `openchange` is emitted with the new state.
#
# - `heading`, `description`: label and describe it for assistive tech
# - `alert`: an alertdialog, for confirmations; the backdrop doesn't close it
# - `size`: 'sm', 'md' (default) or 'lg'
# - `closable`: false hides the close button
# - `modal`: false leaves the page usable behind it: no backdrop, focus isn't
#   trapped, the page still scrolls, and clicking outside doesn't close it
tag ui-dialog-base
	prop open = false
	prop heading = null
	prop description = null
	prop alert = false
	prop size = 'md'
	prop closable = true
	prop modal = true

	zagId = uid('dialog')
	presence = new Presence(self)

	# `bind=` targets `data`, which aliases `open` here.
	get data do open
	set data v do open = v

	get trigger do $triggerSlot..firstElementChild

	def setup
		let initial = !!data
		machine = new Machine self, dialog.machine, do defined({
			id: zagId
			role: alert ? 'alertdialog' : 'dialog'
			defaultOpen: initial
			modal: !!modal
			trapFocus: !!modal
			preventScroll: !!modal
			closeOnInteractOutside: !!modal
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
		trigger.zag = machine.connect(dialog).getTriggerProps! if trigger

	def render
		machine.syncValue !!data, do
			machine.connect(dialog).setOpen(!!data)

		let api = machine.connect(dialog)
		trigger.zag = api.getTriggerProps! if trigger
		presence.update(api.open)

		<self>
			<span$triggerSlot.trigger-slot> <slot name='trigger'>
			<global>
				if modal
					<div.backdrop zag=presence.keep(api.getBackdropProps!)>
				<div.positioner zag=api.getPositionerProps!>
					<div.content .{size} zag=presence.keep(api.getContentProps!) @animationend=presence.done!>
						if closable
							<button.close zag=api.getCloseTriggerProps!> <ui-icon path=icons.x size=16>
						if heading or description
							<div.header>
								if heading
									<h2.heading zag=api.getTitleProps!> heading
								if description
									<p.description zag=api.getDescriptionProps!> description
						<div.body> <slot>
						<div.footer> <slot name='footer'>
