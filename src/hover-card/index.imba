import '../theme.imba'
import './base.imba'

global css
	@keyframes ui-hover-card-in
		from opacity:0 transform:translateY(var(--dy, 0)) translateX(var(--dx, 0)) scale(0.97)
	@keyframes ui-hover-card-out
		to opacity:0 transform:scale(0.97)

tag ui-hover-card < ui-hover-card-base
	css
		# The wrappers stay out of layout; the trigger sits where it was written.
		d:contents
		.trigger-slot d:contents

		# The positioner carries the z-index itself. Zag sets it inline as
		# var(--z-index) but doesn't always fill in the variable, so set both.
		.positioner zi:50 --z-index:50
		.content zi:50 fw:400 w:72 max-width:calc(100vw - 32px) p:4 box-sizing:border-box bg:$ui-surface c:$ui-text ff:$ui-font fs:sm bd:1px solid $ui-border rd:calc($ui-radius + 2px) shadow:$ui-shadow outline:none
			--arrow-size:12px --arrow-background:$ui-surface
			transform-origin:var(--transform-origin)
			# Comes in from the trigger's side.
			&[data-placement^=bottom] --dy:-4px
			&[data-placement^=top] --dy:4px
			&[data-placement^=right] --dx:-4px
			&[data-placement^=left] --dx:4px
			&[data-state=open] animation:ui-hover-card-in 150ms ease-out
			&[data-state=closed] animation:ui-hover-card-out 120ms ease-in forwards
		.arrow-tip bdt:1px solid $ui-border bdl:1px solid $ui-border
