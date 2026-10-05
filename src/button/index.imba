import '../theme.imba'
import './base.imba'

global css @keyframes ui-spin
	to transform:rotate(360deg)

tag ui-button < ui-button-base
	css
		d:inline-flex ai:center jc:center g:2 h:$ui-control-height px:3.5 box-sizing:border-box
		bd:1px solid $ui-border bg:$ui-surface c:$ui-text rd:$ui-radius
		ff:$ui-font fs:sm fw:500 lh:1 ws:nowrap td:none cursor:pointer
		transition:background-color 120ms, border-color 120ms
		@hover bg:$ui-hover
		@active y:1px
		# A ring for keyboard focus only, not after a click.
		outline:none
		@focus-visible outline:2px solid $ui-ring-soft bc:$ui-ring
		@disabled o:0.5 cursor:not-allowed
			@active y:0

		&.primary bg:$ui-accent bc:$ui-accent c:$ui-accent-text
			@hover bg:$ui-accent bc:$ui-accent filter:brightness(1.1)
		&.danger bg:$ui-danger bc:$ui-danger c:white
			@hover filter:brightness(1.1)
		&.soft bg:$ui-accent-soft bc:transparent c:$ui-accent-soft-text
			@hover filter:brightness(0.97)
		&.ghost bg:transparent bc:transparent
			@hover bg:$ui-hover
		# Looks like a link, behaves as a button.
		&.link h:auto px:0 bg:transparent bc:transparent c:$ui-accent
			@hover bg:transparent td:underline
			@active y:0

		&.sm h:$ui-control-height-sm px:2.5 fs:xs g:1.5
		&.lg h:$ui-control-height-lg px:5 fs:md
		&.icon-only px:0 w:$ui-control-height
			&.sm w:$ui-control-height-sm
			&.lg w:$ui-control-height-lg
		&.round rd:full
		&.block d:flex w:100%
		&.loading cursor:progress

		.icon d:block w:1em h:1em fs:md fls:0
		&.sm .icon fs:sm
		# The count badge, ringed in the page colour so it stands off the button.
		# --ui-button-count-bg/-text (set on the button or any parent) override
		# the countColor presets.
		pos:relative
		.badge pos:absolute t:0 r:0 transform:translate(45%, -45%) d:grid place-items:center min-width:18px h:18px px:1.25 box-sizing:border-box rd:full
			bg:var(--ui-button-count-bg, var(--count-bg)) c:var(--ui-button-count-text, var(--count-text)) shadow:0 0 0 2px $ui-surface
			fs:11px fw:600 lh:1 ff:$ui-font font-variant-numeric:tabular-nums pointer-events:none
			--count-bg:$ui-danger --count-text:white
			&.accent --count-bg:$ui-accent --count-text:$ui-accent-text
			&.success --count-bg:$ui-success --count-text:white
			&.warning --count-bg:#f59e0b --count-text:#451a03
			&.neutral --count-bg:$ui-text --count-text:$ui-surface
			&.dot min-width:0 w:10px h:10px p:0
		&.sm .badge min-width:16px h:16px fs:10px px:1
			&.dot w:8px h:8px
		# A dot sits a little inside an icon button's corner.
		&.icon-only .badge.dot transform:translate(15%, -15%)
		&.round.icon-only .badge transform:translate(25%, -25%)
			&.dot transform:none t:4% r:4%

		.spinner d:block w:1em h:1em fls:0 box-sizing:border-box bd:2px solid currentColor bc:currentColor transparent currentColor currentColor rd:full animation:ui-spin 0.7s linear infinite
