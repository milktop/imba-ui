import '../theme.imba'
import './base.imba'

# The area and bar charts share their parts, so they're styled together
# (each carries data-ui-chart, and data-styled when it's the styled tag).
global css
	[data-ui-chart][data-styled]
		d:block pos:relative w:100% min-width:0 c:$ui-text ff:$ui-font fs:sm
		.frame pos:relative w:100%
		.svg d:block of:visible
		.grid stroke:$ui-border stroke-dasharray:3 3
			&.hidden d:none
		.tick fill:$ui-muted fs:11px
		.line fill:none stroke-width:2 stroke-linejoin:round stroke-linecap:round
		.cursor stroke:$ui-muted stroke-width:1 stroke-dasharray:3 3
		.dot stroke:$ui-surface stroke-width:2
		.bar transition:opacity 120ms
			&.dim o:0.45
		.band fill:$ui-hover
		# The tooltip sits beside the hovered point (to its left near the right
		# edge), clear of the line and dots.
		.tooltip pos:absolute t:0 zi:5 min-width:32 py:2 px:2.5 bg:$ui-surface bd:1px solid $ui-border rd:$ui-radius shadow:$ui-shadow fs:xs pointer-events:none ws:nowrap
			transform:translateX(12px)
			&.flip transform:translateX(calc(-100% - 12px))
		.tooltip-label fw:600 mb:1
		.tooltip-row d:flex ai:center g:2 lh:1.6
		.tooltip-name c:$ui-muted flg:1
		.tooltip-value fw:500 ff:inherit
		.swatch d:inline-block w:2.5 h:2.5 rd:full fls:0
		.legend d:flex flw:wrap g:4 mt:2 fs:xs c:$ui-muted
		.legend-item d:inline-flex ai:center g:1.5
		.sr-only pos:absolute w:1px h:1px of:hidden clip:rect(0 0 0 0) ws:nowrap

tag ui-area-chart < ui-area-chart-base
	styled = yes

tag ui-donut-chart < ui-donut-chart-base
	css
		d:inline-flex ai:center g:6 max-width:100% c:$ui-text ff:$ui-font fs:sm-
		&[data-legend=bottom] fld:column g:4
		.frame pos:relative fls:0
		.svg d:block of:visible
		.slice transition:opacity 120ms cursor:default
			&.dim o:0.45
		.center pos:absolute inset:0 d:flex fld:column ai:center jc:center pointer-events:none ta:center
		.center-total d:contents
		.center strong fs:xl fw:700 lh:1.1
		.center span c:$ui-muted fs:xs
		.legend d:flex fld:column g:1.5 m:0 p:0 list-style:none min-width:0
		&[data-legend=bottom] .legend fld:row flw:wrap jc:center g:1.5 4
		.legend-item d:flex ai:center g:2 transition:opacity 120ms
			&.dim o:0.45
		.swatch w:2.5 h:2.5 rd:full fls:0
		.legend-label flg:1 c:$ui-muted
		.legend-value fw:600 font-variant-numeric:tabular-nums
			small c:$ui-muted fw:400 fs:11px
		.sr-only pos:absolute w:1px h:1px of:hidden clip:rect(0 0 0 0) ws:nowrap
tag ui-bar-chart < ui-bar-chart-base
	styled = yes

tag ui-sparkline < ui-sparkline-base
	css
		d:block w:100% min-width:4rem
		.svg d:block w:100% h:100% of:visible
		# Strokes keep their width though the drawing is stretched to fit.
		.line stroke-width:1.75 stroke-linejoin:round stroke-linecap:round vector-effect:non-scaling-stroke
