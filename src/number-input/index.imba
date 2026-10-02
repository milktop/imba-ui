import '../theme.imba'
import './base.imba'

tag ui-number-input < ui-number-input-base
	css
		d:inline-block c:$ui-text ff:$ui-font min-width:40

		.label d:block fs:sm fw:500 mb:1.5
		.control d:hcl g:2 h:$ui-control-height pl:3 pr:1 box-sizing:border-box bg:$ui-surface bd:1px solid $ui-border rd:$ui-radius fs:sm
			@focus-within bc:$ui-ring outline:2px solid $ui-ring-soft
			&[data-disabled] o:0.5
			&[data-invalid] bc:$ui-danger
		.input fl:1 min-width:0 p:0 bd:none bg:transparent outline:none c:inherit fs:inherit ff:inherit
			@placeholder c:$ui-muted
		.affix d:hcc fls:0 c:$ui-muted ws:nowrap
			&.start mr:1
		.end d:hcl fls:0 g:0.5
			&:not(:has(.step)) mr:0.5
			.affix mr:1
		iconify-icon d:block w:1em h:1em fs:md
		.step d:grid place-items:center fls:0 w:6 h:7 bd:none bg:transparent rd:sm c:$ui-muted cursor:pointer
			@hover bg:$ui-hover c:$ui-text
			&[data-disabled] o:0.4 cursor:not-allowed
			@hover&[data-disabled] bg:transparent c:$ui-muted
