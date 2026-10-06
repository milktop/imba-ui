import { icons } from '../icons.imba'
import 'iconify-icon'

# Headless banner: a slim, prominent strip for an announcement or a
# page-wide message, e.g. across the top of the content.
#
#   <ui-banner icon='lucide:sparkles' dismissible>
#     "Notes can now be shared with parents. "
#     <a href='/help/notes'> 'See how'
#
# For a message within the page's content, use ui-alert.
#
# - `variant`: 'accent' (default, solid), 'soft', 'neutral', 'success',
#   'warning' or 'danger'
# - `icon`: an Iconify icon before the message
# - `actions` slot: buttons or links at the end
# - `dismissible`: a close button; closing sets `open` (bindable with `bind=`)
#   to false and emits `dismiss`
# - `full`: no rounding, to run edge to edge
tag ui-banner-base
	prop open = true
	prop variant = 'accent'
	prop icon = null
	prop dismissible = false
	prop full = false

	# `bind=` targets `data`, which aliases `open` here.
	get data do open
	set data v do open = v

	def dismiss
		data = no
		emit('dismiss')

	<self .{variant} .full=full>
		if data
			<div.bar role='status'>
				<iconify-icon.icon icon=icon aria-hidden='true'> if icon
				<div.description> <slot>
				<div.actions> <slot name='actions'>
				if dismissible
					<button.close type='button' aria-label='Dismiss' @click=dismiss> <ui-icon path=icons.x size=14>
