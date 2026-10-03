import '../theme.imba'
import '../checkbox/index.imba'
import '../skeleton/index.imba'
import './base.imba'

tag ui-table < ui-table-base
	css
		d:block w:100% min-width:0 c:$ui-text ff:$ui-font fs:sm
		# Scrolls sideways on narrow screens; with maxHeight, down too, under a
		# sticky header.
		.scroll w:100% ofx:auto bd:1px solid $ui-border rd:calc($ui-radius + 2px) box-sizing:border-box
			&.sticky ofy:auto
		.table w:100% border-collapse:separate border-spacing:0
		.caption pos:absolute w:1px h:1px of:hidden clip:rect(0 0 0 0) ws:nowrap
		th, td px:3 h:11 ta:left va:middle bdb:1px solid $ui-border ws:nowrap
		&.sm th, &.sm td h:9 px:2.5
		th h:10 fw:500 fs:xs c:$ui-muted bg:$ui-hover
		&.sm th h:8
		.sticky th pos:sticky t:0 zi:1
		th[data-align=center], td[data-align=center] ta:center
		th[data-align=end], td[data-align=end] ta:right
		tbody tr:last-child td bdb:none
		tbody tr @hover bg:color-mix(in srgb, $ui-hover 60%, transparent)
		tbody tr.selected bg:color-mix(in srgb, $ui-accent-soft 45%, transparent)
		.select-cell w:9 pr:0
		.sort d:inline-flex ai:center g:1 m:0 -1.5 px:1.5 h:7 bd:none rd:sm bg:transparent c:inherit ff:inherit fs:inherit fw:inherit cursor:pointer
			@hover c:$ui-text bg:$ui-border
			@focus-visible outline:2px solid $ui-ring-soft
			&[data-dir] c:$ui-text
		.sort-icon o:0.6
		th[data-align=end] .sort fld:row-reverse
		.empty h:auto py:10 ta:center c:$ui-muted ws:normal
		&.loading tbody o:0.5 transition:opacity 150ms
