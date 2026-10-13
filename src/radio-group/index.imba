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
		.control d:grid place-items:center fls:0 w:4 h:4 mt:0.5 box-sizing:border-box bg:$ui-field-bg bd:1px solid $ui-field-border rd:full
			&[data-state=checked] bc:$ui-accent bw:5px
			&[data-focus-visible] outline:2px solid $ui-ring-soft bc:$ui-ring
			&[data-invalid] bc:$ui-danger
		.text d:vflex g:0.5
		.description c:$ui-muted fs:xs
		.icon d:block fls:0 mt:0.25 c:$ui-muted fs:lg

		# Cards: each option a bordered card, the chosen one outlined in the accent.
		&.cards w:100%
		&.cards .group d:grid gtc:repeat(auto-fill, minmax(11rem, 1fr)) g:2
		&.cards .item g:2.5 p:3 bd:1px solid $ui-border rd:calc($ui-radius + 2px) bg:$ui-surface transition:border-color 120ms, background 120ms
			@hover bc:$ui-muted
			&[data-state=checked] bc:$ui-accent bg:color-mix(in srgb, $ui-accent-soft 45%, $ui-surface) shadow:0 0 0 1px $ui-accent
			&[data-focus-visible] outline:2px solid $ui-ring-soft
			&[data-state=checked] .icon c:$ui-accent
		&.cards .item-text fw:500
