import '../theme.imba'
import './base.imba'

tag ui-badge < ui-badge-base
	css
		d:inline-flex ai:center g:1 h:5.5 px:2 box-sizing:border-box va:middle
		bd:1px solid transparent rd:full ff:$ui-font fs:xs fw:500 lh:1 ws:nowrap
		&.sm h:4.5 px:1.5 fs:11px
		.icon d:block w:1em h:1em
		.dot w:1.5 h:1.5 rd:full bg:currentColor

		&.neutral bg:$ui-hover c:$ui-text
		&.accent bg:$ui-accent-soft c:$ui-accent-soft-text
		&.success bg:#dcfce7 c:#166534
		&.warning bg:#fef3c7 c:#92400e
		&.danger bg:#fee2e2 c:#991b1b
		&.outline bg:transparent bc:$ui-border c:$ui-text
		html.dark &.success bg:#14532d c:#bbf7d0
		html.dark &.warning bg:#451a03 c:#fde68a
		html.dark &.danger bg:#450a0a c:#fecaca
