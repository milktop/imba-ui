import '../theme.imba'
import './base.imba'

# ui-stats responds to its own width (not the screen's): one column, then two,
# then `columns`, so four stats go 1, 2 by 2, then a row. Imba's CSS has no
# container queries, so these are plain rules.
if typeof document != 'undefined' and !document.getElementById('ui-stats-rules')
	let style = document.createElement('style')
	style.id = 'ui-stats-rules'
	style.textContent = [
		'[data-ui-stats] { container-type: inline-size; }'
		'[data-ui-stats] > .grid { grid-template-columns: minmax(0, 1fr); }'
		'@container (min-width: 26rem) { [data-ui-stats] > .grid { grid-template-columns: repeat(min(2, var(--columns)), minmax(0, 1fr)); } }'
		'@container (min-width: 46rem) { [data-ui-stats] > .grid { grid-template-columns: repeat(var(--columns), minmax(0, 1fr)); } }'
	].join('\n')
	document.head.appendChild(style)

tag ui-stat < ui-stat-base
	css
		d:flex fld:column g:1 min-width:0 c:$ui-text ff:$ui-font fs:sm
		&.card p:5 bd:1px solid $ui-border rd:calc($ui-radius + 4px) bg:$ui-surface shadow:$ui-card-shadow
		.header d:flex ai:center jc:space-between g:3 min-height:6
		.label c:$ui-muted fw:500 min-width:0 overflow-wrap:anywhere
		# Small enough to sit in the label's row without making it taller than
		# in a stat without one.
		.icon d:grid place-items:center w:8 h:8 my:-1 fls:0 rd:$ui-radius bg:$ui-accent-soft c:$ui-accent-soft-text fs:16px
		.value d:flex ai:baseline g:1 fs:2xl fw:700 lh:1.2 ls:-0.01em
		&.sm .value fs:xl
		&.lg .value fs:3xl
		# Line height 1, so a unit doesn't make the row taller.
		.unit fs:sm fw:500 lh:1 c:$ui-muted ls:0
		.footer d:flex ai:center g:1.5 flw:wrap fs:xs mt:0.5
		.change d:inline-flex ai:center g:1 fw:600 c:$ui-muted
			&.good c:$ui-success
			&.bad c:$ui-danger
		.change-label c:$ui-muted
		.help fs:xs c:$ui-muted
			&:empty d:none

# Through `>>>`: the stats are slotted in, rendered by the page.
tag ui-stats < ui-stats-base
	css
		d:block w:100%
		# Columns come from the container queries above.
		.grid d:grid g:4
		&.cards .grid >>> ui-stat p:5 bd:1px solid $ui-border rd:calc($ui-radius + 4px) bg:$ui-surface shadow:$ui-card-shadow
		# One card split into cells by 1px gaps over the border colour.
		&.divided .grid g:1px bg:$ui-border bd:1px solid $ui-border rd:calc($ui-radius + 4px) shadow:$ui-card-shadow of:hidden
		&.divided .grid >>> ui-stat p:5 bg:$ui-surface
