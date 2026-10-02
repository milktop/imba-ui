import '../theme.imba'
import './base.imba'

tag ui-pin-input < ui-pin-input-base
	css
		d:block c:$ui-text ff:$ui-font

		.label d:block fs:sm fw:500 mb:1.5
		.control d:flex g:2
		.box w:$ui-control-height h:$ui-control-height p:0 box-sizing:border-box ta:center bg:$ui-surface bd:1px solid $ui-border rd:$ui-radius c:inherit ff:inherit fs:md fw:500 outline:none
			@placeholder c:$ui-muted
			@focus bc:$ui-ring outline:2px solid $ui-ring-soft
			&[data-invalid] bc:$ui-danger
			&[data-complete] bc:$ui-accent
			@disabled o:0.5
