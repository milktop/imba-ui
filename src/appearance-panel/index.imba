import '../theme.imba'
import '../popover/index.imba'
import '../button/index.imba'
import '../segmented/index.imba'
import '../swatch-picker/index.imba'
import '../native-select/index.imba'
import '../switch/index.imba'
import './base.imba'

tag ui-appearance < ui-appearance-base
	popoverTag = 'ui-popover'
	buttonTag = 'ui-button'
	segmentedTag = 'ui-segmented'
	swatchPickerTag = 'ui-swatch-picker'
	nativeSelectTag = 'ui-native-select'
	switchTag = 'ui-switch'

	css
		d:inline-block
		# A little wider than a popover's default, for four sidebar styles
		>>> .content w:80
		.panel d:flex fld:column g:4
		.label d:flex ai:baseline jc:space-between g:2 mb:2 fs:xs fw:600 c:$ui-muted
		.hint fw:400
		.custom d:flex ai:center g:2 fs:sm cursor:pointer
			input w:8 h:8 p:0 bd:1px solid $ui-border rd:$ui-radius bg:transparent cursor:pointer
			code fs:xs c:$ui-muted
		.dev d:flex fld:column g:3 pt:3 bdt:1px solid $ui-border
		.config d:block p:2 bg:$ui-hover rd:$ui-radius fs:xs c:$ui-muted ws:pre-wrap user-select:all
