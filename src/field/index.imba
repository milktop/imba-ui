import '../theme.imba'
import './base.imba'
import '../input/index.imba'
import '../number-input/index.imba'
import '../textarea/index.imba'

tag ui-field < ui-field-base
	inputTag = 'ui-input'
	numberTag = 'ui-number-input'
	textareaTag = 'ui-textarea'

	css
		d:vflex ai:stretch g:1.5 min-width:0 c:$ui-text ff:$ui-font
		gc:span var(--span)
		# Full width when the surrounding ui-fields is narrow.
		..@!480 gc:1 / -1

		# Components fill the field, whatever their standalone min-width.
		>>> [data-part=root] min-width:0

		.label fs:sm fw:500 w:max-content
		.required c:$ui-danger
		.hint, .error m:0 fs:xs
		.hint c:$ui-muted
		.error c:$ui-danger
