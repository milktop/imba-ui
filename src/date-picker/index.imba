import '../theme.imba'
import './base.imba'

# The styled date picker. Imba scopes a subclass's CSS to everything its
# instances render, including the markup inherited from the base, so this is
# just the theme. For a custom look, subclass ui-date-picker-base yourself.
tag ui-date-picker < ui-date-picker-base
	css
		d:inline-block pos:relative c:$ui-text ff:$ui-font

		.label d:block fs:sm fw:500 mb:1.5
		.control d:hcl g:1 bg:$ui-surface bd:1px solid $ui-border rd:$ui-radius px:2 h:$ui-control-height
			@focus-within bc:$ui-ring outline:2px solid $ui-ring-soft
			&[data-disabled] o:0.5
			&[data-invalid] bc:$ui-danger
		# Inputs fit their text (`size` is the fallback where field-sizing isn't
		# supported) and the last one grows, keeping range dates together and
		# the buttons at the end.
		.input min-width:0 bd:none bg:transparent outline:none fs:sm w:auto field-sizing:content c:inherit p:0
			&:last-of-type flg:1
			@placeholder c:$ui-muted
		.separator c:$ui-muted fs:sm px:1
		.clear, .trigger, .prev, .next
			d:grid place-items:center w:7 h:7 bd:none bg:transparent rd:sm c:$ui-muted cursor:pointer
			@hover bg:$ui-hover c:$ui-text
			&[hidden] d:none

		# The positioner carries the z-index itself. Zag sets it inline as
		# var(--z-index) but doesn't always fill in the variable, so set both.
		.positioner zi:50 --z-index:50
		.content zi:50 fw:400 bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius + 2px) shadow:$ui-shadow p:3 outline:none
		.view-control d:hcs mb:2
		.view-trigger fw:600 fs:sm bd:none bg:transparent rd:sm px:2 py:1 c:inherit cursor:pointer
			@hover bg:$ui-hover

		.table bdc:collapse
		.weekday fs:xs fw:500 c:$ui-muted w:9 h:8
		td p:0
		.cell d:grid place-items:center w:9 h:9 rd:$ui-radius fs:sm cursor:pointer us:none
			@hover bg:$ui-hover
			&[data-outside-range] c:$ui-muted o:0.5
			&[data-today] fw:700 c:$ui-accent
			&[data-in-range] bg:$ui-accent-soft rd:0
			&[data-range-start] rdl:$ui-radius
			&[data-range-end] rdr:$ui-radius
			&[data-selected] bg:$ui-accent c:$ui-accent-text
			&[data-focus] outline:2px solid $ui-ring outline-offset:-2px
			&[data-disabled], &[data-unavailable] o:0.3 cursor:not-allowed
			&[data-unavailable] td:line-through
		.cell.wide w:16 h:10
