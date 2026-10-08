import '../theme.imba'
import './base.imba'

tag ui-alert < ui-alert-base
	css
		d:flex ai:flex-start g:3 p:4 box-sizing:border-box bd:1px solid $ui-border rd:$ui-radius bg:$ui-surface c:$ui-text ff:$ui-font fs:sm

		.icon fls:0 mt:0.25
		.text fl:1 min-width:0
		.heading fw:600 mb:0.5
		.description c:$ui-muted
		.actions d:flex flw:wrap g:2 mt:3
			&:not(:has(*)) d:none
		.actions >>> div[slot=actions] d:contents
		.close d:grid place-items:center fls:0 w:6 h:6 mt:-1 mr:-1 bd:none bg:transparent rd:sm c:$ui-muted cursor:pointer outline:none
			@hover bg:rgba(0,0,0,0.06) c:$ui-text
			@focus-visible outline:2px solid $ui-ring-soft

		# Each variant tints itself from one theme colour, translucent so it reads
		# the same on a card or the canvas, in light and dark
		&.info $tone:$ui-accent
		&.success $tone:$ui-success
		&.warning $tone:$ui-warning
		&.danger $tone:$ui-danger
		&.info, &.success, &.warning, &.danger
			bg:color-mix(in srgb, $tone 10%, transparent) bc:color-mix(in srgb, $tone 30%, transparent)
			.icon c:$tone
			.heading c:color-mix(in srgb, $tone 70%, $ui-text)
			.description c:color-mix(in srgb, $tone 25%, $ui-text)
