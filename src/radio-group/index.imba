import '../theme.imba'
import './base.imba'

tag ui-radio-group < ui-radio-group-base
	css
		d:block c:$ui-text ff:$ui-font

		.label d:block fs:sm fw:500 mb:1.5
		.group d:vflex g:2
			&[data-orientation=horizontal] d:hflex flw:wrap g:2 4
		.item d:flex ai:flex-start g:2 fs:sm cursor:pointer
			&[data-disabled] o:0.5 cursor:not-allowed
		# Lines the circle up with the first line of text.
		.control d:grid place-items:center fls:0 w:4 h:4 mt:0.5 box-sizing:border-box bg:$ui-surface bd:1px solid $ui-border rd:full
			&[data-state=checked] bc:$ui-accent bw:5px
			&[data-focus-visible] outline:2px solid $ui-ring-soft bc:$ui-ring
			&[data-invalid] bc:$ui-danger
		.text d:vflex g:0.5
		.description c:$ui-muted fs:xs
