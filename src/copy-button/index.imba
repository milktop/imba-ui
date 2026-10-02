import '../theme.imba'
import './base.imba'

tag ui-copy-button < ui-copy-button-base
	css
		d:inline-flex
		.trigger d:inline-flex ai:center g:1.5 h:7 px:2 bd:1px solid $ui-border bg:$ui-surface c:$ui-text rd:calc($ui-radius - 2px) ff:$ui-font fs:xs fw:500 ws:nowrap cursor:pointer
			@hover bg:$ui-hover
			@focus-visible outline:2px solid $ui-ring-soft bc:$ui-ring
			&.icon-only w:7 px:0 jc:center
		.icon d:inline-flex c:$ui-muted
		&.copied .icon c:#16a34a
