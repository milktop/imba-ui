import '../theme.imba'
import '../popover/index.imba'
import './base.imba'

# One row that never wraps: crumbs fold into the "…" when they don't fit
# (see the base), then long labels are cut with an ellipsis, the current
# page's last.
tag ui-breadcrumbs < ui-breadcrumbs-base
	css
		d:block min-width:0 ff:$ui-font fs:sm
		nav min-width:0
		.list d:flex ai:center g:1.5 m:0 p:0 list-style:none min-width:0 of:hidden
		.crumb d:flex ai:center g:1.5 min-width:0 fls:var(--shrink, 1)
			&:last-child fls:0 max-width:60%
		.separator d:inline-flex ai:center c:$ui-muted fls:0 o:0.7
		.link d:inline-flex ai:center g:1.5 min-width:0 c:$ui-muted td:none rd:sm ws:nowrap
			@focus-visible outline:2px solid $ui-ring-soft outline-offset:2px
		a.link @hover c:$ui-text
		.current c:$ui-text fw:500
		.icon fs:15px fls:0
		.text of:hidden text-overflow:ellipsis
		.more d:inline-flex ai:center jc:center h:6 px:1.5 bd:none rd:sm bg:transparent c:$ui-muted ff:inherit fs:inherit cursor:pointer lh:1
			@hover bg:$ui-hover c:$ui-text
			@focus-visible outline:2px solid $ui-ring-soft
			&[aria-expanded=true] bg:$ui-hover c:$ui-text
		# The folded crumbs: a compact list in the popover.
		>>> .content w:auto min-width:40 p:1
		.folded d:flex fld:column m:0 p:0 list-style:none
		.folded-link d:flex ai:center g:2 px:2.5 py:1.5 rd:$ui-radius c:$ui-text td:none ws:nowrap
			@focus-visible outline:2px solid $ui-ring-soft outline-offset:-2px
		a.folded-link @hover bg:$ui-hover
		span.folded-link c:$ui-muted

tag ui-breadcrumb < ui-breadcrumb-base
	css
		d:flex ai:center g:1.5 min-width:0
		&:first-child .separator d:none
		.separator d:inline-flex ai:center c:$ui-muted fls:0 o:0.7
		.link d:inline-flex ai:center g:1.5 c:$ui-muted td:none rd:sm ws:nowrap
			@focus-visible outline:2px solid $ui-ring-soft outline-offset:2px
		a.link @hover c:$ui-text
		.current c:$ui-text fw:500
		.icon fs:15px fls:0
		.text of:hidden text-overflow:ellipsis min-width:3em
