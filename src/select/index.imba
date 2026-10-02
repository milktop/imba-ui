import '../theme.imba'
import './base.imba'

tag ui-select < ui-select-base
	css
		d:inline-block pos:relative c:$ui-text ff:$ui-font min-width:48

		.label d:block fs:sm fw:500 mb:1.5
		.control d:hcl pos:relative
		.trigger d:hcs g:2 w:100% h:$ui-control-height px:3 bg:$ui-surface bd:1px solid $ui-border rd:$ui-radius fs:sm c:inherit ta:left cursor:pointer
			@focus-visible bc:$ui-ring outline:2px solid $ui-ring-soft
			&[data-disabled] o:0.5 cursor:not-allowed
			&[data-invalid] bc:$ui-danger
		.value-text ws:nowrap of:hidden text-overflow:ellipsis
			&.placeholder c:$ui-muted
		.indicator d:inline-flex c:$ui-muted
			&[data-state=open] rotate:180deg
		.clear pos:absolute r:8 d:grid place-items:center w:6 h:6 bd:none bg:transparent rd:sm c:$ui-muted cursor:pointer
			@hover bg:$ui-hover c:$ui-text
			&[hidden] d:none

		# Zag copies the content's z-index onto its positioner.
		.content zi:50 fw:400 list-style:none m:0 bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius + 2px) shadow:$ui-shadow p:1 outline:none max-height:min(300px, var(--available-height)) ofy:auto box-sizing:border-box
		.item d:hcs g:2 px:2 py:1.5 rd:sm fs:sm cursor:pointer
			&[data-highlighted] bg:$ui-hover
			&[data-state=checked] fw:500
			&[data-disabled] o:0.4 cursor:not-allowed
		.item-indicator d:none c:$ui-accent
			&[data-state=checked] d:inline-flex
