import '../theme.imba'
import './base.imba'

global css
	@keyframes ui-tooltip-in
		from opacity:0 transform:translate(var(--dx), var(--dy)) scale(0.96)
	@keyframes ui-tooltip-out
		to opacity:0 transform:translate(var(--dx), var(--dy)) scale(0.96)

tag ui-tooltip < ui-tooltip-base
	css
		# The wrappers stay out of layout; the trigger sits where it was written.
		d:contents
		.trigger-slot d:contents

		# Zag copies the content's z-index onto its positioner.
		.content zi:60 max-width:64 px:2 py:1 bg:$ui-text c:$ui-surface ff:$ui-font fs:xs lh:1.4 rd:calc($ui-radius - 2px) shadow:$ui-shadow
			--arrow-size:8px --arrow-background:$ui-text
			# Slides in from the trigger's side: opening on the right, it comes
			# from the left. Moving between tooltips (data-instant) skips it.
			--dx:0px --dy:0px
			&[data-side=top] --dy:4px
			&[data-side=bottom] --dy:-4px
			&[data-side=left] --dx:4px
			&[data-side=right] --dx:-4px
			&[data-state=open] animation:ui-tooltip-in 140ms ease-out
			&[data-state=closed] animation:ui-tooltip-out 100ms ease-in forwards
			&[data-instant] animation:none
