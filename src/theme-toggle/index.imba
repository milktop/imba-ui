import '../theme.imba'
import '../segmented/index.imba'
import '../menu/index.imba'
import '../tooltip/index.imba'
import './base.imba'

tag ui-theme-toggle < ui-theme-toggle-base
	css
		d:inline-block
		# The menu and toggle variants: one square button, like a segmented item.
		.trigger d:hcc w:$ui-control-height h:$ui-control-height p:0 box-sizing:border-box bd:1px solid $ui-border bg:$ui-surface c:$ui-text rd:$ui-radius cursor:pointer
			@hover bg:$ui-hover
			@focus-visible outline:2px solid $ui-ring-soft
			&[data-state=open] bg:$ui-hover
		.trigger-icon d:block fs:16px
		# Icons only: a narrow column, the current scheme highlighted instead
		# of dotted, names kept for screen readers. Scoped to the menu's
		# content, since ui-segmented's parts are `.item`s too.
		&.icon-only >>> [data-scope=menu][data-part=content] min-width:0 px:1 py:1
		&.icon-only >>> [data-part=content] .item jc:center w:$ui-control-height h:$ui-control-height px:0 box-sizing:border-box
		&.icon-only >>> [data-part=content] .item[data-state=checked] bg:$ui-hover
			.icon c:$ui-text
		&.icon-only >>> [data-part=content] .item > .indicator d:none
		&.icon-only >>> [data-part=content] .item > .icon w:16px h:16px fs:16px
		&.icon-only >>> [data-part=content] .item > .label pos:absolute w:1px h:1px of:hidden clip:rect(0 0 0 0) ws:nowrap
