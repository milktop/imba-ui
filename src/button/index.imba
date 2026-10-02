import '../theme.imba'
import './base.imba'

global css @keyframes ui-spin
	to transform:rotate(360deg)

tag ui-button < ui-button-base
	css
		d:inline-flex ai:center jc:center g:2 h:10 px:4 box-sizing:border-box
		bd:1px solid $ui-border bg:$ui-surface c:$ui-text rd:$ui-radius
		ff:$ui-font fs:sm fw:500 lh:1 ws:nowrap td:none cursor:pointer
		transition:background-color 120ms, border-color 120ms
		@hover bg:$ui-hover
		@active y:1px
		@focus-visible outline:2px solid $ui-ring-soft bc:$ui-ring
		@disabled o:0.5 cursor:not-allowed
			@active y:0

		&.primary bg:$ui-accent bc:$ui-accent c:$ui-accent-text
			@hover bg:$ui-accent bc:$ui-accent filter:brightness(1.1)
		&.danger bg:$ui-danger bc:$ui-danger c:white
			@hover filter:brightness(1.1)
		&.ghost bg:transparent bc:transparent
			@hover bg:$ui-hover

		&.sm h:8 px:3 fs:xs g:1.5
		&.lg h:12 px:5 fs:md
		&.icon-only px:0 w:10
			&.sm w:8
			&.lg w:12
		&.block d:flex w:100%
		&.loading cursor:progress

		.icon d:block w:1em h:1em fs:md fls:0
		&.sm .icon fs:sm
		.spinner d:block w:1em h:1em fls:0 box-sizing:border-box bd:2px solid currentColor bc:currentColor transparent currentColor currentColor rd:full animation:ui-spin 0.7s linear infinite
