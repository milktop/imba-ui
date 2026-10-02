import '../theme.imba'
import './base.imba'

tag ui-tooltip < ui-tooltip-base
	css
		# The wrappers stay out of layout; the trigger sits where it was written.
		d:contents
		.trigger-slot d:contents

		# Zag copies the content's z-index onto its positioner.
		.content zi:60 max-width:64 px:2 py:1 bg:$ui-text c:$ui-surface ff:$ui-font fs:xs lh:1.4 rd:calc($ui-radius - 2px) shadow:$ui-shadow
			--arrow-size:8px --arrow-background:$ui-text
