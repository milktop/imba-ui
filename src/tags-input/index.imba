import '../theme.imba'
import './base.imba'

tag ui-tags-input < ui-tags-input-base
	css
		d:block c:$ui-text ff:$ui-font min-width:0

		.label d:block fs:sm fw:500 mb:1.5
		.control d:hcl flw:wrap g:1 min-height:$ui-control-height px:2 py:0.5 box-sizing:border-box bg:$ui-surface bd:1px solid $ui-border rd:$ui-radius fs:sm cursor:text
			@focus-within bc:$ui-ring outline:2px solid $ui-ring-soft
			&[data-invalid] bc:$ui-danger
			&[data-disabled] o:0.5
		.preview d:hcl g:1 h:6 pl:2 pr:0.5 bg:$ui-hover rd:sm fs:xs fw:500
			&[data-highlighted] bg:$ui-accent-soft c:$ui-accent-soft-text
		.remove d:grid place-items:center w:5 h:5 bd:none bg:transparent rd:sm c:$ui-muted cursor:pointer
			@hover c:$ui-text bg:$ui-border
		.edit h:6 px:2 w:24 bd:1px solid $ui-ring rd:sm bg:$ui-surface c:inherit ff:inherit fs:xs outline:none
		.input fl:1 min-width:20 h:7 p:0 bd:none bg:transparent outline:none c:inherit fs:inherit ff:inherit
			@placeholder c:$ui-muted
		.clear d:grid place-items:center w:7 h:7 bd:none bg:transparent rd:sm c:$ui-muted cursor:pointer
			@hover bg:$ui-hover c:$ui-text
