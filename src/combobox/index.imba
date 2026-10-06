import '../theme.imba'
import './base.imba'

tag ui-combobox < ui-combobox-base
	css
		d:inline-block pos:relative c:$ui-text ff:$ui-font min-width:60

		.label d:block fs:sm fw:500 mb:1.5
		.control d:flex ai:center g:1 bg:$ui-surface bd:1px solid $ui-border rd:$ui-radius pl:2 pr:1 py:0.5 min-height:$ui-control-height box-sizing:border-box
			@focus-within bc:$ui-ring outline:2px solid $ui-ring-soft
			&[data-disabled] o:0.5
			&[data-invalid] bc:$ui-danger
		.tags d:flex flw:wrap ai:center fl:1 min-width:0 g:1.5 py:0.5
		.input fl:1 min-width:16 bd:none bg:transparent outline:none fs:sm c:inherit p:0 h:6.5
			@placeholder c:$ui-muted
		# Tags match ui-tags-input: subtle (default), accent or outline.
		.tag d:hcl g:1 h:6.5 pl:2.5 pr:1 box-sizing:border-box rd:calc($ui-radius - 2px) fs:sm- fw:500 lh:1 bd:1px solid transparent
		.tag-text ws:nowrap of:hidden text-overflow:ellipsis max-width:48
		.tag-remove d:grid place-items:center w:4.5 h:4.5 p:0 bd:none bg:transparent rd:sm c:inherit o:0.6 cursor:pointer
			@hover o:1 bg:rgba(0,0,0,0.08)
		&.subtle .tag bg:$ui-hover c:$ui-text
		&.accent .tag bg:$ui-accent-soft c:$ui-accent-soft-text
		&.outline .tag bg:$ui-surface bc:$ui-border c:$ui-text
		.clear, .trigger
			d:grid place-items:center fls:0 w:7 h:7 bd:none bg:transparent rd:sm c:$ui-muted cursor:pointer
			@hover bg:$ui-hover c:$ui-text
			&[hidden] d:none
		.trigger[data-state=open] rotate:180deg

		# Zag copies the content's z-index onto its positioner.
		.content zi:50 fw:400 bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius + 2px) shadow:$ui-shadow p:1 outline:none max-height:min(300px, var(--available-height)) ofy:auto box-sizing:border-box
		.status px:2 py:2 fs:sm c:$ui-muted
		.item d:hcs g:2 px:2 py:1.5 rd:sm fs:sm cursor:pointer
			&[data-highlighted] bg:$ui-hover
			&[data-state=checked] fw:500
			&[data-disabled] o:0.4 cursor:not-allowed
		.item-indicator d:none c:$ui-accent
			&[data-state=checked] d:inline-flex
