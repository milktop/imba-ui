import '../theme.imba'
import './base.imba'

tag ui-tree-view < ui-tree-view-base
	css
		d:block min-width:0 c:$ui-text ff:$ui-font fs:sm
		.label d:block mb:1.5 fs:sm fw:500
		.tree d:flex fld:column g:1px outline:none

# The rows are rendered by ui-tree-view-node, out of reach of the tree's
# scoped styles, so they're styled globally under ui-tree-view. Zag sets
# --depth on each row; it's indented by it.
global css
	ui-tree-view
		.branch-control, .item d:flex ai:center g:1.5 min-height:8 box-sizing:border-box
			pr:2 pl:calc(0.5rem + (var(--depth, 1) - 1) * 1.25rem) rd:$ui-radius cursor:pointer us:none outline:none
			@hover bg:$ui-hover
			&[data-selected] bg:$ui-accent-soft c:$ui-accent-soft-text
			&[data-focus]@focus-visible shadow:inset 0 0 0 2px $ui-ring-soft
			&[data-disabled] o:0.5 cursor:not-allowed
		# Items line up with branch texts (past the chevron's room).
		.item pl:calc(0.5rem + (var(--depth, 1) - 1) * 1.25rem + 1.375rem)
		.branch-indicator d:grid place-items:center w:4 c:$ui-muted transition:transform 150ms
			&[data-state=open] transform:rotate(90deg)
		.icon fls:0 c:$ui-muted fs:md
		[data-selected] > .icon c:inherit
		.branch-text, .item-text min-width:0 of:hidden text-overflow:ellipsis ws:nowrap
		.branch-content pos:relative d:flex fld:column g:1px
		# A faint line down the open branch's children.
		.indent-guide pos:absolute t:0 b:0 w:1px bg:$ui-border l:calc(0.5rem + (var(--depth, 1) - 1) * 1.25rem + 0.5rem)
		.checkbox d:grid place-items:center fls:0 w:4 h:4 box-sizing:border-box bd:1px solid $ui-field-border rd:4px bg:$ui-field-bg c:$ui-accent-text
			&[data-state=checked], &[data-state=indeterminate] bg:$ui-accent bc:$ui-accent
