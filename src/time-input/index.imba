import '../theme.imba'
import './base.imba'
import '../input/index.imba'

tag ui-time-input < ui-time-input-base
	inputTag = 'ui-input'

	css
		d:block min-width:0
		&.has-icon >>> .affix cursor:pointer
		&.has-icon >>> input::-webkit-calendar-picker-indicator d:none
