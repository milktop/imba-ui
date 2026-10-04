import '../theme.imba'
import './base.imba'

global css
	@keyframes ui-action-bar-in
		from opacity:0 transform:translateY(12px) scale(0.97)
	@keyframes ui-action-bar-out
		to opacity:0 transform:translateY(12px) scale(0.97)

tag ui-action-bar < ui-action-bar-base
	css
		d:contents
		# Centred along the bottom (over the main area, beside ui-app-shell's
		# sidebar); only the bar itself takes clicks.
		.positioner pos:fixed l:var(--ui-main-left, 0px) r:0 transition:left 200ms ease b:4 @md:6 zi:90 d:flex jc:center px:4 pointer-events:none
		.content d:flex ai:center g:2 max-width:100% min-height:11 py:1.5 pl:4 pr:1.5 box-sizing:border-box
			bg:$ui-surface c:$ui-text ff:$ui-font fs:sm bd:1px solid $ui-border rd:calc($ui-radius + 6px) shadow:$ui-shadow pointer-events:auto
			&[data-state=open] animation:ui-action-bar-in 180ms cubic-bezier(0.32, 0.72, 0, 1)
			&[data-state=closed] animation:ui-action-bar-out 140ms ease-in forwards
		.selection fw:500 ws:nowrap
			&:empty d:none
		.selection@empty + .separator d:none
		.separator w:1px h:5 bg:$ui-border fls:0
		.actions d:flex ai:center g:1.5 flw:wrap
		.actions >>> div[slot] d:contents
		.close d:grid place-items:center w:8 h:8 fls:0 bd:none rd:$ui-radius bg:transparent c:$ui-muted cursor:pointer
			@hover bg:$ui-hover c:$ui-text
			@focus-visible outline:2px solid $ui-ring-soft
