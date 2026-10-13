import '../theme.imba'
import './base.imba'

tag ui-kbd < ui-kbd-base
	css
		d:inline-flex ai:center g:0.75 va:middle
		.key d:inline-flex ai:center jc:center min-width:5.5 h:5.5 px:1.5 box-sizing:border-box va:middle
			bd:1px solid $ui-border bdb:2px solid $ui-border rd:5px bg:$ui-surface
			c:$ui-muted ff:$ui-font fs:xs fw:500 lh:1 ws:nowrap
		&.sm .key min-width:4.5 h:4.5 px:1 fs:11px bdb:1px solid $ui-border
