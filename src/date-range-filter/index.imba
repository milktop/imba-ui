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
		.preset jc:flex-start fw:400 fs:13px
			&.ghost c:$ui-text
		.clear mt:auto fw:400 fs:13px c:$ui-muted
