import '../theme.imba'
import '../checkbox/index.imba'
import '../skeleton/index.imba'
import './base.imba'

tag ui-table < ui-table-base
	css
		d:block w:100% min-width:0 c:$ui-text ff:$ui-font fs:sm
		# Scrolls sideways on narrow screens; with maxHeight, down too, under a
		# sticky header.
		.scroll w:100% ofx:auto bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius + 2px) shadow:$ui-card-shadow box-sizing:border-box
			&.sticky ofy:auto
		&.flush .scroll bd:none rd:0 bg:transparent shadow:none
		# Outer cells line up with a card's padding.
		&.flush .scroll >>> :is(th, td)@first-child pl:5
		&.flush .scroll >>> :is(th, td)@last-child pr:5
		# The table's parts are styled through `>>>`, so a <table> written inside
		# (without columns) looks the same as the generated one.
		.scroll >>> table w:100% border-collapse:separate border-spacing:0
		.scroll >>> caption pos:absolute w:1px h:1px of:hidden clip:rect(0 0 0 0) ws:nowrap
		# Rows get room from padding (so two-line cells breathe too), with a
		# minimum height for one-line ones.
		.scroll >>> :is(th, td) px:3 py:3 h:12 ta:left va:middle bdb:1px solid $ui-border
		# Generated cells stay on one line (the table scrolls sideways instead).
		.table th, .table td ws:nowrap
		# A slim, quiet header: small muted labels on a faint band. (`:is` gives
		# these the same weight as the cell rule above, which they override.)
		.scroll >>> :is(th) h:9 py:0 fw:500 fs:xs c:$ui-muted bg:color-mix(in srgb, $ui-hover 60%, $ui-surface)
		&.sm .scroll >>> :is(th, td) h:9 py:1.5 px:2.5
		&.sm .scroll >>> :is(th) h:8 py:0
		&.lg .scroll >>> :is(th, td) h:14 py:4 px:4
		&.lg .scroll >>> :is(th) h:10 py:0
		.sticky >>> th pos:sticky t:0 zi:1
		.scroll >>> :is(th, td)[data-align=center] ta:center
		.scroll >>> :is(th, td)[data-align=end] ta:right
		.scroll >>> tbody tr@last-child td bdb:none
		.scroll >>> tbody tr
			@hover bg:color-mix(in srgb, $ui-hover 60%, transparent)
		.scroll >>> tbody tr.selected bg:color-mix(in srgb, $ui-accent-soft 45%, transparent)
		.scroll >>> .select-cell w:9 pr:0
		.sort d:inline-flex ai:center g:1 m:0 -1.5 px:1.5 h:6 bd:none rd:sm bg:transparent c:inherit ff:inherit fs:inherit fw:inherit cursor:pointer
			@hover c:$ui-text
			@focus-visible outline:2px solid $ui-ring-soft
			&[data-dir] c:$ui-text
		# Sort icons show on hover or focus, and on the sorted column; their
		# space is kept, so labels don't shift.
		.sort-icon d:inline-flex o:0 transition:opacity 120ms
		.sort@hover .sort-icon, .sort@focus-visible .sort-icon o:0.5
		.sort[data-dir] .sort-icon o:1
		th[data-align=end] .sort fld:row-reverse
		.scroll >>> td.empty h:auto py:10 ta:center c:$ui-muted ws:normal
		&.loading tbody o:0.5 transition:opacity 150ms
