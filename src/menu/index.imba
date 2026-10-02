import '../theme.imba'
import './base.imba'

global css
	@keyframes ui-menu-in
		from opacity:0 transform:translateY(-4px) scale(0.98)
	@keyframes ui-menu-out
		to opacity:0 transform:scale(0.98)

tag ui-menu < ui-menu-base
	css
		# The wrappers stay out of layout; the trigger sits where it was written.
		d:contents
		.trigger-slot d:contents

		# Zag copies the content's z-index onto its positioner.
		.content zi:50 fw:400 min-width:48 py:2 px:1 box-sizing:border-box bg:$ui-surface c:$ui-text ff:$ui-font fs:sm bd:1px solid $ui-border rd:calc($ui-radius + 2px) shadow:$ui-shadow outline:none
			transform-origin:var(--transform-origin)
			&[data-state=open] animation:ui-menu-in 120ms ease-out
			&[data-state=closed] animation:ui-menu-out 100ms ease-in forwards
		.item d:flex ai:center g:2 px:2 h:8 rd:sm fs:13px cursor:pointer user-select:none
			&[data-highlighted] bg:$ui-hover
			&[data-disabled] o:0.4 cursor:not-allowed
			&.danger c:$ui-danger
		.icon d:block w:15px h:15px fs:15px c:$ui-muted fls:0
		.danger .icon c:inherit
		.label fl:1
		.shortcut ml:4 c:$ui-muted fs:11px ff:inherit
		.separator h:1px my:1 mx:-1 bg:$ui-border
		.group-label px:2 pt:2 pb:1 fs:xs fw:500 c:$ui-muted
