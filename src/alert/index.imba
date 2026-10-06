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

		&.info bg:$ui-accent-soft bc:transparent
			.icon, .heading c:$ui-accent-soft-text
		&.success bg:#f0fdf4 bc:#bbf7d0
			.icon, .heading c:#166534
		&.warning bg:#fffbeb bc:#fde68a
			.icon, .heading c:#92400e
		&.danger bg:#fef2f2 bc:#fecaca
			.icon, .heading c:#991b1b
		html.dark &.success bg:#052e16 bc:#14532d
			.icon, .heading c:#86efac
		html.dark &.warning bg:#1c1004 bc:#451a03
			.icon, .heading c:#fcd34d
		html.dark &.danger bg:#1f0505 bc:#450a0a
			.icon, .heading c:#fca5a5
