import '../theme.imba'
import '../segmented/index.imba'
import '../menu/index.imba'
import '../tooltip/index.imba'
import './base.imba'

tag ui-theme-toggle < ui-theme-toggle-base
	css
		d:inline-block
		# Sizes: the square buttons (the trigger and icon-only menu items) and
		# their icons; ui-segmented gets `size` itself.
		$tt-h:$ui-control-height $tt-icon:16px
		&.sm $tt-h:$ui-control-height-sm $tt-icon:15px
		&.lg $tt-h:$ui-control-height-lg $tt-icon:18px
		# The menu and toggle variants: one square button, like a segmented item.
		.trigger d:hcc w:$tt-h h:$tt-h p:0 box-sizing:border-box bd:1px solid $ui-border bg:$ui-surface c:$ui-text rd:$ui-radius cursor:pointer
			@hover bg:$ui-hover
			@focus-visible outline:2px solid $ui-ring-soft
			&[data-state=open] bg:$ui-hover
		.trigger-icon d:block fs:$tt-icon
		# Icons only: a narrow column, the current scheme highlighted instead
		# of dotted, names kept for screen readers. Scoped to the menu's
		# content, since ui-segmented's parts are `.item`s too.
		&.icon-only >>> [data-scope=menu][data-part=content] min-width:0 px:1 py:1
		&.icon-only >>> [data-part=content] .item jc:center w:$tt-h h:$tt-h px:0 box-sizing:border-box
		&.icon-only >>> [data-part=content] .item[data-state=checked] bg:$ui-hover
			.icon c:$ui-text
		&.icon-only >>> [data-part=content] .item > .indicator d:none
		&.icon-only >>> [data-part=content] .item > .icon w:$tt-icon h:$tt-icon fs:$tt-icon
		&.icon-only >>> [data-part=content] .item > .label pos:absolute w:1px h:1px of:hidden clip:rect(0 0 0 0) ws:nowrap
