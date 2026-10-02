import '../theme.imba'
import './base.imba'

global css
	@keyframes ui-progress-slide
		from transform:translateX(-100%)
		to transform:translateX(250%)
	@keyframes ui-progress-spin
		to transform:rotate(360deg)

tag ui-progress < ui-progress-base
	css
		d:block w:100% c:$ui-text ff:$ui-font min-width:0
		&.circle d:inline-block w:auto

		.header d:flex jc:space-between ai:baseline g:4 mb:1.5 fs:sm
		.label fw:500
		.value ml:auto c:$ui-muted font-variant-numeric:tabular-nums

		.track pos:relative h:2 of:hidden bg:$ui-hover rd:full
		.range h:100% w:var(--percent, 0) bg:$ui-accent rd:full transition:width 300ms ease
		&[data-state=indeterminate] .range w:40% animation:ui-progress-slide 1.2s ease-in-out infinite

		.circle-wrap pos:relative d:inline-grid place-items:center
		# Zag rotates the range to start at the top and sets its dash offset inline.
		.circle d:block
		.circle-track stroke:$ui-hover fill:none
		.circle-range stroke:$ui-accent fill:none stroke-linecap:round stroke-dasharray:var(--circumference) stroke-dashoffset:var(--offset) transition:stroke-dashoffset 300ms ease
		&[data-state=indeterminate] .circle
			animation:ui-progress-spin 1s linear infinite
		# Indeterminate: Zag's inline offset hides the whole stroke, so a 30% dash
		# with a full gap leaves an arc to spin.
		&[data-state=indeterminate] .circle-range stroke-dasharray:calc(var(--circumference) * 0.3) var(--circumference)
		.circle-value pos:absolute fs:xs fw:500 font-variant-numeric:tabular-nums
