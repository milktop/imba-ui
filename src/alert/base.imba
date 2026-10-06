import { icons } from '../icons.imba'

# Headless alert: a message in the page (not a popup; see toast for those).
#
# - `variant`: 'info' (default), 'success', 'warning' or 'danger'
# - `heading`: a bold first line; the default slot is the message
# - `icon`: false hides the variant's icon
# - `dismissible`: shows a close button, which emits `dismiss` (hide the
#   alert in response)
# - `actions` slot: buttons under the message
#
# Danger and warning alerts are role=alert, so assistive tech announces them
# when they appear; the others are role=status.
tag ui-alert-base
	prop variant = 'info'
	prop heading = null
	prop icon = true
	prop dismissible = false

	get iconPath
		{ info: icons.info, success: icons.success, warning: icons.warning, danger: icons.error }[variant] or icons.info

	<self .{variant} role=(variant == 'danger' or variant == 'warning' ? 'alert' : 'status')>
		if icon
			<ui-icon.icon path=iconPath size=18 aria-hidden='true'>
		<div.text>
			<div.heading> heading if heading
			<div.description> <slot>
			<div.actions> <slot name='actions'>
		if dismissible
			<button.close type='button' aria-label='Dismiss' @click=emit('dismiss')> <ui-icon path=icons.x size=14>
