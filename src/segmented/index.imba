import '../theme.imba'
import '../tooltip/index.imba'
import './base.imba'

tag ui-segmented < ui-segmented-base
	css
		d:inline-block c:$ui-text ff:$ui-font max-width:100%
		# Sizes: the control's height, the items' side padding (less with
		# iconOnly) and the icons.
		$seg-h:$ui-control-height $seg-px:0.75rem $seg-px-icon:0.5rem $seg-icon:15px
		&.sm $seg-h:$ui-control-height-sm $seg-px:0.625rem $seg-px-icon:0.375rem $seg-icon:14px
		&.lg $seg-h:$ui-control-height-lg $seg-px:1rem $seg-px-icon:0.625rem $seg-icon:17px

		.label d:block fs:sm fw:500 mb:1.5
		.group pos:relative d:inline-flex max-width:100% p:1 g:1 box-sizing:border-box bg:$ui-hover rd:$ui-radius
			&[data-disabled] o:0.5
			&[data-invalid] outline:1px solid $ui-danger
		.indicator pos:absolute l:var(--left) t:var(--top) w:var(--width) h:var(--height) bg:$ui-surface rd:calc($ui-radius - 2px) shadow:0 1px 3px rgba(0,0,0,0.12)
			transition-property:var(--transition-property) transition-duration:150ms
		.item pos:relative zi:1 d:hcc fl:1 1 auto px:$seg-px h:calc($seg-h - 8px) rd:calc($ui-radius - 2px) fs:sm fw:500 c:$ui-muted ws:nowrap cursor:pointer
			&[data-state=checked] c:$ui-text
			&[data-focus-visible] outline:2px solid $ui-ring-soft
			&[data-disabled] o:0.4 cursor:not-allowed
		&.sm .item fs:xs
		&.lg .item fs:md
		.item-text d:inline-flex ai:center g:1.5
		.item-icon d:block fs:$seg-icon
		.icon-only px:$seg-px-icon
		# With tooltips the wrapper fills the item, so hovering anywhere on it
		# opens one.
		.tipped px:0
		.item-tip d:hcc h:100% px:$seg-px
		.icon-only .item-tip px:$seg-px-icon
		.visually-hidden pos:absolute w:1px h:1px of:hidden clip:rect(0 0 0 0) ws:nowrap
