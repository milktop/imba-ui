import '../theme.imba'
import './base.imba'

# Shared by ui-menu, its child tags and submenus (which are child components,
# so a tag's scoped CSS wouldn't reach them).
global css
	@keyframes ui-menu-in
		from opacity:0 transform:translateY(-4px) scale(0.98)
	@keyframes ui-menu-out
		to opacity:0 transform:scale(0.98)

	# The wrappers stay out of layout; the trigger sits where it was written.
	[data-ui-menu] d:contents
		.trigger-slot d:contents
	# Item tags wrap their item, which may be a link.
	[data-ui-menu-item] d:contents

	# Zag copies the content's z-index onto its positioner.
	[data-scope=menu][data-part=content] zi:50 fw:400 min-width:48 py:2 px:1 box-sizing:border-box bg:$ui-surface c:$ui-text ff:$ui-font fs:sm ta:left bd:1px solid $ui-border rd:calc($ui-radius + 2px) shadow:$ui-shadow outline:none
		transform-origin:var(--transform-origin)
		&[data-state=open] animation:ui-menu-in 120ms ease-out
		&[data-state=closed] animation:ui-menu-out 100ms ease-in forwards
		.item d:flex ai:center g:2 px:2 h:8 rd:sm fs:sm- c:inherit td:none cursor:pointer user-select:none outline:none
			&[data-highlighted] bg:$ui-hover
			&[data-state=open] bg:$ui-hover
			&[data-disabled] o:0.4 cursor:not-allowed
			&.danger c:$ui-danger
		.item > .icon d:block w:15px h:15px fs:15px c:$ui-muted fls:0
		.item.danger > .icon c:inherit
		.item > .label fl:1
		.item > .shortcut ml:4 c:$ui-muted fs:11px ff:inherit
		.item > .indicator d:grid place-items:center w:15px h:15px fls:0
		# Checked marks in the accent: a tick, and a dot in a soft halo.
		.mark.checkbox d:block w:14px h:14px fs:14px c:$ui-accent
		.mark.radio d:block w:6px h:6px rd:full bg:$ui-accent box-shadow:0 0 0 3px $ui-accent-soft
		.item > .chevron d:block w:14px h:14px fs:14px ml:auto c:$ui-muted
		.separator d:block h:1px my:1 mx:-1 bg:$ui-border
		.group-label px:2 pt:2 pb:1 fs:xs fw:500 c:$ui-muted
		# The menu's own label reads a little stronger than its group headings.
		.menu-label pt:1.5 c:$ui-text fw:600
		ui-menu-group-base, ui-menu-group, ui-menu-radio-group-base, ui-menu-radio-group d:block

tag ui-menu < ui-menu-base
tag ui-submenu < ui-submenu-base
tag ui-menu-item < ui-menu-item-base
tag ui-menu-separator < ui-menu-separator-base
tag ui-menu-group < ui-menu-group-base
tag ui-menu-checkbox < ui-menu-checkbox-base
tag ui-menu-radio-group < ui-menu-radio-group-base
tag ui-menu-radio < ui-menu-radio-base
