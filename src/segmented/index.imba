import '../theme.imba'
import './base.imba'

tag ui-segmented < ui-segmented-base
	css
		d:inline-block c:$ui-text ff:$ui-font max-width:100%

		.label d:block fs:sm fw:500 mb:1.5
		.group pos:relative d:inline-flex max-width:100% p:1 g:1 box-sizing:border-box bg:$ui-hover rd:$ui-radius
			&[data-disabled] o:0.5
			&[data-invalid] outline:1px solid $ui-danger
		.indicator pos:absolute l:var(--left) t:var(--top) w:var(--width) h:var(--height) bg:$ui-surface rd:calc($ui-radius - 2px) shadow:0 1px 3px rgba(0,0,0,0.12)
			transition-property:var(--transition-property) transition-duration:150ms
		.item pos:relative zi:1 d:hcc fl:1 1 auto px:3 h:calc($ui-control-height - 8px) rd:calc($ui-radius - 2px) fs:sm fw:500 c:$ui-muted ws:nowrap cursor:pointer
		.item-text d:inline-flex ai:center g:1.5
		.item-icon d:block fs:15px
		.icon-only px:2
		.visually-hidden pos:absolute w:1px h:1px of:hidden clip:rect(0 0 0 0) ws:nowrap
			&[data-state=checked] c:$ui-text
			&[data-focus-visible] outline:2px solid $ui-ring-soft
			&[data-disabled] o:0.4 cursor:not-allowed
