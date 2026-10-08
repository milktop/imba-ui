import '../theme.imba'
import './base.imba'

tag ui-password-input < ui-password-input-base
	css
		d:block c:$ui-text ff:$ui-font min-width:0

		.label d:block fs:sm fw:500 mb:1.5
		.control d:hcl g:2 h:$ui-control-height pl:3 pr:1 box-sizing:border-box bg:$ui-field-bg bd:1px solid $ui-field-border rd:$ui-radius fs:sm
			@hover bc:$ui-field-border-hover
			@focus-within bc:$ui-ring outline:2px solid $ui-ring-soft
			&[data-invalid] bc:$ui-danger
			&[data-disabled] o:0.5
		.input fl:1 min-width:0 p:0 bd:none bg:transparent outline:none c:inherit fs:inherit ff:inherit
			@placeholder c:$ui-muted
		.affix d:hcc fls:0 c:$ui-muted mr:1
		iconify-icon d:block w:1em h:1em fs:md
		.toggle d:grid place-items:center fls:0 w:7 h:7 bd:none bg:transparent rd:sm c:$ui-muted cursor:pointer
			@hover bg:$ui-hover c:$ui-text
			@focus-visible outline:2px solid $ui-ring-soft
