import * as dialog from '@zag-js/dialog'
import { icons } from '../icons.imba'
import '../dialog/base.imba'

# Headless sheet: a panel that slides in from an edge of the screen, for
# viewing or editing something without leaving the page.
#
#   <ui-sheet heading='Edit student' bind=editing>
#     …body…
#     <div slot='footer'> …buttons…
#
# It is a modal dialog underneath (ui-dialog-base): focus is trapped, the page
# behind doesn't scroll, Escape or the backdrop closes it, and focus returns
# to the trigger. The `trigger` slot is optional; bind the open state with
# `bind=` (or `bind:open=`). `openchange` is emitted with the new state.
#
# - `side`: 'right' (default), 'left', 'top' or 'bottom'
# - `size`: 'sm', 'md' (default) or 'lg': the width (or height for top and
#   bottom)
# - `heading`, `description`, `closable`, `alert`: as for ui-dialog
# - `modal`: false keeps the page usable beside it (no backdrop, no focus
#   trap), for looking something up while working on the page
tag ui-sheet-base < ui-dialog-base
	prop side = 'right'

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
				<div.positioner data-side=side zag=api.getPositionerProps!>
					<div.content .{size} data-side=side zag=presence.keep(api.getContentProps!) @animationend=presence.done!>
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
