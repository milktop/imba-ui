import '../theme.imba'
import './base.imba'

tag ui-stat < ui-stat-base
	css
		d:flex ai:flex-start g:3 min-width:0 c:$ui-text ff:$ui-font fs:sm
		&.card p:5 bd:1px solid $ui-border rd:calc($ui-radius + 4px) bg:$ui-surface
		.icon d:grid place-items:center w:10 h:10 fls:0 rd:$ui-radius bg:$ui-accent-soft c:$ui-accent-soft-text fs:20px
		.body d:flex fld:column g:1 min-width:0
		.label c:$ui-muted fw:500
		.value d:flex ai:baseline g:1 fs:2xl fw:700 lh:1.2 ls:-0.01em
		&.sm .value fs:xl
		&.lg .value fs:3xl
		.unit fs:sm fw:500 c:$ui-muted ls:0
		.footer d:flex ai:center g:1.5 flw:wrap fs:xs
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
		.grid d:grid gtc:1fr @sm:repeat(2, minmax(0, 1fr)) @lg:repeat(var(--columns), minmax(0, 1fr)) g:4
		&.cards .grid >>> ui-stat p:5 bd:1px solid $ui-border rd:calc($ui-radius + 4px) bg:$ui-surface
		# One card split into cells by 1px gaps over the border colour.
		&.divided .grid g:1px bg:$ui-border bd:1px solid $ui-border rd:calc($ui-radius + 4px) of:hidden
		&.divided .grid >>> ui-stat p:5 bg:$ui-surface
