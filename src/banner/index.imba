import '../theme.imba'
import './base.imba'

tag ui-banner < ui-banner-base
	css
		d:block w:100% c:$ui-text ff:$ui-font fs:sm
		.bar d:flex ai:center g:3 min-height:10 px:4 py:2 box-sizing:border-box rd:calc($ui-radius + 2px)
		&.full .bar rd:0
		.icon fls:0 fs:16px
		.description flg:1 min-width:0
		# Links in the message take the banner's colour, underlined.
		.description >>> a c:inherit fw:600 td:underline text-underline-offset:2px
		.actions d:flex ai:center g:2 fls:0
			&:not(:has(*)) d:none
		.actions >>> div[slot=actions] d:contents
		.close d:grid place-items:center w:7 h:7 fls:0 mr:-1.5 bd:none rd:$ui-radius bg:transparent c:inherit cursor:pointer o:0.8
			@hover o:1 bg:color-mix(in srgb, currentColor 12%, transparent)
			@focus-visible outline:2px solid currentColor outline-offset:-2px

		&.accent .bar bg:$ui-accent c:$ui-accent-text
		&.soft .bar bg:$ui-accent-soft c:$ui-accent-soft-text
		&.neutral .bar bg:$ui-surface bd:1px solid $ui-border
		&.success .bar bg:color-mix(in srgb, $ui-success 14%, $ui-surface) c:color-mix(in srgb, $ui-success 70%, $ui-text)
		&.warning .bar bg:#fef3c7 c:#92400e
		&.danger .bar bg:color-mix(in srgb, $ui-danger 12%, $ui-surface) c:$ui-danger
		html.dark &.warning .bar bg:#451a03 c:#fde68a
