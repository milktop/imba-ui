import '../theme.imba'
import './base.imba'

tag ui-popover < ui-popover-base
	css
		# The wrappers stay out of layout; the trigger sits where it was written.
		d:contents
		.trigger-slot d:contents

		# The positioner carries the z-index itself. Zag sets it inline as
		# var(--z-index) but doesn't always fill in the variable, so set both.
		.positioner zi:50 --z-index:50
		.content zi:50 fw:400 pos:relative w:72 max-width:calc(100vw - 32px) p:4 box-sizing:border-box bg:$ui-surface c:$ui-text ff:$ui-font fs:sm bd:1px solid $ui-border rd:calc($ui-radius + 2px) shadow:$ui-shadow outline:none
			--arrow-size:12px --arrow-background:$ui-surface
		.arrow-tip bdt:1px solid $ui-border bdl:1px solid $ui-border
		# Room for the close button; slotted content follows below.
		.header pr:6 mb:3
			&:last-child mb:0
		.heading fw:600
		.description m:0 c:$ui-muted
		.heading + .description mt:1
		.close pos:absolute t:2 r:2 d:grid place-items:center w:7 h:7 bd:none bg:transparent rd:sm c:$ui-muted cursor:pointer
			@hover bg:$ui-hover c:$ui-text
