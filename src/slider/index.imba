import '../theme.imba'
import './base.imba'

tag ui-slider < ui-slider-base
	css
		d:block c:$ui-text ff:$ui-font min-width:0

		.header d:flex jc:space-between ai:baseline g:4 mb:2
		.label fs:sm fw:500
		.value ml:auto fs:sm c:$ui-muted font-variant-numeric:tabular-nums
		.control pos:relative d:flex ai:center h:5
			&[data-disabled] o:0.5
		.track pos:relative fl:1 h:1.5 bg:$ui-border rd:full
		.range pos:absolute t:0 b:0 bg:$ui-accent rd:full
		.thumb w:4.5 h:4.5 box-sizing:border-box bg:white bd:2px solid $ui-accent rd:full shadow:0 1px 3px rgba(0,0,0,0.2) cursor:grab outline:none
			@focus-visible outline:3px solid $ui-ring-soft
			&[data-dragging] cursor:grabbing
			&[data-invalid] bc:$ui-danger
		.markers pos:relative h:5 mt:1
		.marker fs:xs c:$ui-muted ws:nowrap
