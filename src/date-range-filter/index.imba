import '../theme.imba'
import '../popover/index.imba'
import '../button/index.imba'
import '../divider/index.imba'
import '../date-picker/index.imba'
import './base.imba'

tag ui-date-range-filter < ui-date-range-filter-base
	popoverTag = 'ui-popover'
	buttonTag = 'ui-button'
	dividerTag = 'ui-divider'
	datePickerTag = 'ui-date-picker'

	css
		d:inline-flex
		.panel d:flex outline:none
		# As tall as the calendar, with Clear at the bottom.
		.presets d:vflex g:0.5 w:44 p:2
		.preset jc:flex-start fw:400 fs:13px c:$ui-text
			# The picked one: a quiet tint rather than the soft button's fill. Set
			# $ui-date-range-filter-active-bg and -text for another (e.g. $ui-hover).
			&[aria-pressed=true]
				bg:var(--ui-date-range-filter-active-bg, color-mix(in srgb, $ui-accent 10%, transparent))
				c:var(--ui-date-range-filter-active-text, $ui-text) fw:500
		.clear mt:auto fw:400 fs:13px c:$ui-muted
		# Choices in a list, so they don't dip when pressed like ui-button does.
		.preset, .clear
			@active y:0
