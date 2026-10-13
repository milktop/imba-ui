import '../theme.imba'
import './base.imba'

tag ui-native-select < ui-native-select-base
	css
		d:block min-width:0 c:$ui-text ff:$ui-font
		.label d:block fs:sm fw:500 mb:1.5
		.control pos:relative d:flex ai:center min-width:0
		.select appearance:none w:100% min-width:0 box-sizing:border-box h:$ui-control-height pl:3 pr:8
			bg:$ui-field-bg bd:1px solid $ui-field-border rd:$ui-radius c:$ui-text ff:$ui-font fs:sm cursor:pointer
			@hover bc:$ui-field-border-hover
			@focus-visible bc:$ui-ring outline:2px solid $ui-ring-soft
			&[aria-invalid=true] bc:$ui-danger
			@disabled o:0.5 cursor:not-allowed
		# The placeholder (the empty value) looks like one.
		&.empty .select c:$ui-muted
		.select option c:$ui-text
		&.sm .select h:$ui-control-height-sm pl:2.5 fs:sm-
		&.lg .select h:$ui-control-height-lg fs:md-
		.indicator pos:absolute r:2.5 c:$ui-muted fs:md pointer-events:none
