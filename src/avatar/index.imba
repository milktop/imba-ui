import '../theme.imba'
import './base.imba'

tag ui-avatar < ui-avatar-base
	css
		pos:relative d:inline-grid place-items:center fls:0 w:10 h:10 of:hidden rd:full
		bg:$ui-accent-soft c:$ui-accent-soft-text ff:$ui-font fs:sm fw:600 us:none va:middle
		&.square rd:$ui-radius
		&.sm w:7 h:7 fs:xs
		&.lg w:14 h:14 fs:lg
		&.xl w:20 h:20 fs:2xl

		.image pos:absolute inset:0 w:100% h:100% obj:cover
		.fallback d:grid place-items:center w:100% h:100% lh:1
		.person w:55% h:55%
