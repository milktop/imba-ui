import '../theme.imba'
import '../tooltip/index.imba'
import './base.imba'

# The list lays out its items (through `>>>`, so markup and `items` alike).
tag ui-data-list < ui-data-list-base
	itemTag = 'ui-data-item'

	css
		d:block w:100% c:$ui-text ff:$ui-font fs:sm
		# Each item's bottom line overlaps the next (and the last is clipped), so
		# lines only ever sit between items.
		.list d:grid m:0 p:0 of:hidden
		&.horizontal >>> .item d:grid gtc:var(--label-width, 10rem) minmax(0, 1fr) g:4 py:2 ai:baseline
		&.vertical >>> .item d:flex fld:column g:0.5 py:2
		&.divided >>> .item, &.card >>> .item py:3 bdb:1px solid $ui-border mb:-1px
		&.card .list bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius + 2px) px:4
		# A grid of items; one column on narrow screens.
		&.grid .list gtc:1fr @sm:repeat(var(--columns, 2), minmax(0, 1fr)) cg:6

tag ui-data-item < ui-data-item-base
	css
		d:block
		.label d:flex ai:center g:1 m:0 c:$ui-muted
		.value m:0 min-width:0 overflow-wrap:anywhere
		.info d:inline-flex c:$ui-muted cursor:help rd:full
			@hover c:$ui-text
			@focus-visible outline:2px solid $ui-ring-soft
