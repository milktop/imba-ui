import '../theme.imba'
import './base.imba'

tag ui-combobox < ui-combobox-base
	css
		d:inline-block pos:relative c:$ui-text ff:$ui-font min-width:60

		.label d:block fs:sm fw:500 mb:1.5
		.control d:hcl flw:wrap g:1 bg:$ui-surface bd:1px solid $ui-border rd:$ui-radius px:2 py:1 min-height:10 box-sizing:border-box
			@focus-within bc:$ui-ring outline:2px solid $ui-ring-soft
			&[data-disabled] o:0.5
			&[data-invalid] bc:$ui-danger
		.input fl:1 min-width:20 bd:none bg:transparent outline:none fs:sm c:inherit p:0 h:7
			@placeholder c:$ui-muted
		.tag d:hcl g:1 bg:$ui-hover rd:sm pl:2 pr:0.5 h:6 fs:xs fw:500
		.tag-remove d:grid place-items:center w:5 h:5 bd:none bg:transparent rd:sm c:$ui-muted cursor:pointer
			@hover c:$ui-text bg:$ui-border
		.clear, .trigger
			d:grid place-items:center w:7 h:7 bd:none bg:transparent rd:sm c:$ui-muted cursor:pointer
			@hover bg:$ui-hover c:$ui-text
			&[hidden] d:none
		.trigger[data-state=open] rotate:180deg

		# Zag copies the content's z-index onto its positioner.
		.content zi:50 bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius + 2px) shadow:$ui-shadow p:1 outline:none max-height:min(300px, var(--available-height)) ofy:auto box-sizing:border-box
		.status px:2 py:2 fs:sm c:$ui-muted
		.item d:hcs g:2 px:2 py:1.5 rd:sm fs:sm cursor:pointer
			&[data-highlighted] bg:$ui-hover
			&[data-state=checked] fw:500
			&[data-disabled] o:0.4 cursor:not-allowed
		.item-indicator d:none c:$ui-accent
			&[data-state=checked] d:inline-flex
