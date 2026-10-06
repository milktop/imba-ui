import '../theme.imba'
import './base.imba'

# The line runs down each item's marker column (so it works for markup and
# `items` alike) and stops at the last one.
tag ui-timeline < ui-timeline-base
	itemTag = 'ui-timeline-item'

	css
		d:block w:100% c:$ui-text ff:$ui-font fs:sm
		.list d:flex fld:column m:0 p:0 list-style:none
		# Cards: each item's text in a bordered box beside its marker.
		&.cards >>> .body p:3 mb:3 bd:1px solid $ui-border rd:calc($ui-radius + 2px) bg:$ui-surface
		&.sm >>> .body pb:4
		&.sm >>> .icon w:6 h:6 fs:sm-

tag ui-timeline-item < ui-timeline-item-base
	css
		d:flex g:3 pos:relative
		# The connector runs down the marker column to the next item, behind the
		# markers (which sit on top), and stops at the last item.
		.marker@after content:'' pos:absolute t:0 b:0 l:calc(50% - 0.5px) w:1px bg:$ui-border
		&@last-child .marker@after d:none
		.marker pos:relative d:flex jc:center w:8 fls:0
		.icon pos:relative zi:1 d:grid place-items:center w:8 h:8 rd:full bg:$ui-hover c:$ui-muted fs:15px bd:1px solid $ui-border box-sizing:border-box
		# A dot, ringed in the page colour so the line doesn't touch it.
		.dot pos:relative zi:1 w:2.5 h:2.5 mt:2.5 rd:full bg:$ui-muted bd:3px solid $ui-surface box-sizing:content-box
		&.accent .icon bg:$ui-accent-soft c:$ui-accent-soft-text bc:transparent
		&.accent .dot bg:$ui-accent
		&.success .icon bg:color-mix(in srgb, $ui-success 15%, $ui-surface) c:$ui-success bc:transparent
		&.success .dot bg:$ui-success
		&.warning .icon bg:#fef3c7 c:#b45309 bc:transparent
		&.warning .dot bg:#f59e0b
		&.danger .icon bg:color-mix(in srgb, $ui-danger 12%, $ui-surface) c:$ui-danger bc:transparent
		&.danger .dot bg:$ui-danger
		.body flg:1 min-width:0 pb:6 pt:1.5
		.header d:flex ai:baseline jc:space-between g:3 flw:wrap
		.heading fw:500
		.time fs:xs c:$ui-muted ws:nowrap
		.description mt:0.5 c:$ui-muted
			&:empty d:none
		.content mt:2
			&:not(:has(*)) d:none
