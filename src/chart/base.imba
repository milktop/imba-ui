import { scaleLinear, scalePoint, scaleBand } from 'd3-scale'
import { line, area, curveMonotoneX, curveLinear, pie, arc } from 'd3-shape'
import { uid } from '../zag.imba'
import { formatNumber } from '../format/base.imba'
import { uiLocale } from '../locale.imba'

# Headless charts: SVG drawn by Imba, with d3 for the maths (scales and
# shapes). Colours come from the theme: series take $ui-chart-1…5 in turn,
# or a `color` of their own ('accent', 'success', 'danger', or any CSS
# colour).
#
#   <ui-sparkline data=[3, 5, 4, 8, 6, 9]>
#   <ui-area-chart data=months x='month' y='revenue' format=(do(v) "£{v}")>
#   <ui-bar-chart data=weeks x='week' series=[{ key: 'maths', label: 'Maths' }, { key: 'english', label: 'English' }]>
#   <ui-donut-chart data=[{ label: 'Consults', value: 42 }, { label: 'Surgery', value: 9 }]>
#
# Area and bar charts take rows of objects: `x` names the label property and
# `y` the value (or `series` for several, each { key, label, color }). They
# fill their width, `height` px tall, with a tooltip on hover, a legend for
# several series, and a hidden table of the data for assistive tech.

# A series colour as CSS.
export def seriesColor color, index
	return "var(--ui-chart-{(index % 5) + 1})" unless color
	return "var(--ui-{color})" if ['accent', 'success', 'danger'].includes(color)
	color

# Charts drawn to their measured width (so text isn't stretched).
tag ui-chart-base
	# The styled tag sets this; its styles only apply when it's on.
	styled = no

	prop data = []
	prop x = 'label'
	prop y = null
	prop series = null
	prop height = 240
	prop format = null
	prop label = null
	prop grid = true

	hover = null
	width = 0
	chartId = uid('chart')

	get list do (series or (y ? [{ key: y, label: y }] : [])).map do(s, i) Object.assign({ label: s.key }, s, { color: seriesColor(s.color, i) })
	get rows do data or []

	def fmt value
		return format(value) if format
		typeof value == 'number' ? formatNumber(value) : String(value ?? '')

	def mount
		#observer = new ResizeObserver do(entries)
			width = Math.floor(entries[0].contentRect.width)
			render!
		#observer.observe(self)

	def unmount
		#observer..disconnect!

	# The plot area inside the axes.
	padTop = 8
	padBottom = 24
	padLeft = 40
	get innerH do Math.max(0, height - padTop - padBottom)

	def yScale max
		scaleLinear!.domain([0, max or 1]).nice!.range([innerH, 0])

	# Room for the longest tick label.
	def leftFor ticks do Math.max(...ticks.map(do fmt($1).length), 1) * 7 + 12
	get innerW do Math.max(0, width - padLeft - 8)

	# Every nth x label, so they don't collide.
	def labelStep count do Math.max(1, Math.ceil(count / Math.max(1, Math.floor(innerW / 64))))

	def pointer e
		let box = $frame.getBoundingClientRect!
		e.clientX - box.left - padLeft

# A filled line chart.
#
# - `curve`: 'smooth' (default) or 'linear'
# - `stacked`: series sit on top of one another
tag ui-area-chart-base < ui-chart-base
	prop curve = 'smooth'
	prop stacked = false

	# Each series' [low, high] per row: from 0, or stacked on the ones before.
	get bands
		let base = rows.map(do 0)
		list.map do(s)
			let out = rows.map do(row, i)
				let value = +row[s.key] or 0
				let low = stacked ? base[i] : 0
				base[i] = low + value if stacked
				[low, low + value]
			out

	def move e
		return unless rows.length
		let step = rows.length > 1 ? innerW / (rows.length - 1) : 0
		let index = step ? Math.round(pointer(e) / step) : 0
		hover = Math.max(0, Math.min(rows.length - 1, index))

	def render
		let bands = bands
		let max = Math.max(0, ...bands.flatMap(do(b) b.map(do $1[1])))
		let ys = yScale(max)
		let ticks = ys.ticks(4)
		padLeft = leftFor(ticks)
		let xs = scalePoint!.domain(rows.map(do(_, i) i)).range([0, innerW])
		let shape = curve == 'linear' ? curveLinear : curveMonotoneX
		let fill = area!.x(do(_, i) xs(i)).y0(do ys($1[0])).y1(do ys($1[1])).curve(shape)
		let stroke = line!.x(do(_, i) xs(i)).y(do ys($1[1])).curve(shape)
		let step = labelStep(rows.length)

		<self data-ui-chart data-styled=(styled or undefined)>
			<div$frame.frame style="height: {height}px" @pointermove=move @pointerleave=(hover = null)>
				if width
					<svg.svg width=width height=height aria-hidden='true'>
						<defs>
							for s, i in list
								<linearGradient id="{chartId}-{i}" x1='0' x2='0' y1='0' y2='1'>
									<stop offset='0%' stop-color=s.color stop-opacity='0.28'>
									<stop offset='100%' stop-color=s.color stop-opacity='0.02'>
						<g transform="translate({padLeft},{padTop})">
							for tick in ticks
								<line.grid .hidden=!grid x1=0 x2=innerW y1=ys(tick) y2=ys(tick)>
								<text.tick x=-8 y=ys(tick) dy='0.32em' text-anchor='end'> fmt(tick)
							for row, i in rows
								if i % step == 0
									<text.tick x=xs(i) y=(innerH + 18) text-anchor=(i == 0 ? 'start' : (i == rows.length - 1 ? 'end' : 'middle'))> String(row[x] ?? '')
							for s, i in list
								<path.area d=fill(bands[i]) fill="url(#{chartId}-{i})">
								<path.line d=stroke(bands[i]) stroke=s.color>
							if hover != null
								<line.cursor x1=xs(hover) x2=xs(hover) y1=0 y2=innerH>
								for s, i in list
									<circle.dot cx=xs(hover) cy=ys(bands[i][hover][1]) r=4 fill=s.color>
				if hover != null and rows[hover]
					<div.tooltip .flip=(xs(hover) > innerW * 0.6) style="left: {padLeft + xs(hover)}px">
						<div.tooltip-label> String(rows[hover][x] ?? '')
						for s in list
							<div.tooltip-row>
								<span.swatch style="background: {s.color}">
								<span.tooltip-name> s.label
								<span.tooltip-value> fmt(rows[hover][s.key])
			if list.length > 1
				<div.legend> for s in list
					<span.legend-item>
						<span.swatch style="background: {s.color}">
						s.label
			<table.sr-only>
				<caption> label ?? uiLocale.messages.chart.label
				<tr>
					<th> x
					for s in list
						<th> s.label
				for row in rows
					<tr>
						<td> String(row[x] ?? '')
						for s in list
							<td> fmt(row[s.key])

# Vertical bars, one per row (or a group per row for several series).
#
# - `stacked`: series sit on top of one another instead of side by side
tag ui-bar-chart-base < ui-chart-base
	prop stacked = false

	def move e
		return unless rows.length
		let step = innerW / rows.length
		hover = Math.max(0, Math.min(rows.length - 1, Math.floor(pointer(e) / step)))

	def render
		let max = Math.max(0, ...rows.map do(row)
			stacked ? list.reduce((do(sum, s) sum + (+row[s.key] or 0)), 0) : Math.max(0, ...list.map(do +row[$1.key] or 0)))
		let ys = yScale(max)
		let ticks = ys.ticks(4)
		padLeft = leftFor(ticks)
		let xs = scaleBand!.domain(rows.map(do(_, i) i)).range([0, innerW]).padding(0.3)
		let inner = scaleBand!.domain(list.map(do $1.key)).range([0, xs.bandwidth!]).padding(0.12)
		let step = labelStep(rows.length)

		# Each bar's box: side by side, or stacked.
		let bars = rows.map do(row, i)
			let base = 0
			list.map do(s, j)
				let value = +row[s.key] or 0
				let low = stacked ? base : 0
				base += value if stacked
				let bx = stacked ? xs(i) : xs(i) + inner(s.key)
				{ x: bx, y: ys(low + value), w: (stacked ? xs.bandwidth! : inner.bandwidth!), h: Math.max(0, ys(low) - ys(low + value)), color: s.color }

		<self data-ui-chart data-styled=(styled or undefined)>
			<div$frame.frame style="height: {height}px" @pointermove=move @pointerleave=(hover = null)>
				if width
					<svg.svg width=width height=height aria-hidden='true'>
						<g transform="translate({padLeft},{padTop})">
							for tick in ticks
								<line.grid .hidden=!grid x1=0 x2=innerW y1=ys(tick) y2=ys(tick)>
								<text.tick x=-8 y=ys(tick) dy='0.32em' text-anchor='end'> fmt(tick)
							if hover != null
								<rect.band x=(xs(hover) - xs.step! * xs.paddingInner! / 2) y=0 width=xs.step! height=innerH>
							for row, i in rows
								if i % step == 0
									<text.tick x=(xs(i) + xs.bandwidth! / 2) y=(innerH + 18) text-anchor='middle'> String(row[x] ?? '')
								for bar in bars[i]
									<rect.bar x=bar.x y=bar.y width=bar.w height=bar.h rx=(stacked ? 0 : 3) fill=bar.color .dim=(hover != null and hover != i)>
				if hover != null and rows[hover]
					<div.tooltip .flip=(xs(hover) > innerW * 0.6) style="left: {padLeft + xs(hover) + (xs(hover) > innerW * 0.6 ? 0 : xs.bandwidth!)}px">
						<div.tooltip-label> String(rows[hover][x] ?? '')
						for s in list
							<div.tooltip-row>
								<span.swatch style="background: {s.color}">
								<span.tooltip-name> s.label
								<span.tooltip-value> fmt(rows[hover][s.key])
			if list.length > 1
				<div.legend> for s in list
					<span.legend-item>
						<span.swatch style="background: {s.color}">
						s.label
			<table.sr-only>
				<caption> label ?? uiLocale.messages.chart.label
				<tr>
					<th> x
					for s in list
						<th> s.label
				for row in rows
					<tr>
						<td> String(row[x] ?? '')
						for s in list
							<td> fmt(row[s.key])

# A tiny chart without axes, for a trend beside a number or in a table cell.
#
# - `data`: numbers (or objects, with `y` naming the value)
# - `variant`: 'line' (default), 'area' or 'bar'
# - `color`, `height` (px, 32 by default; it fills its width)
# - `label`: what it shows, for assistive tech
tag ui-sparkline-base
	prop data = []
	prop y = null
	prop variant = 'line'
	prop color = null
	prop height = 32
	prop label = null

	chartId = uid('spark')

	get values do (data or []).map(do(d) +(y ? d[y] : d) or 0)

	# Drawn in a 100-wide box stretched to fit; strokes keep their width.
	def render
		let values = values
		let max = Math.max(...values, 0)
		let min = variant == 'bar' ? 0 : Math.min(...values, max)
		let ys = scaleLinear!.domain([min, max == min ? min + 1 : max]).range([height - 2, 2])
		let xs = scaleLinear!.domain([0, Math.max(1, values.length - 1)]).range([1, 99])
		let colour = seriesColor(color, 0)
		let path = line!.x(do(_, i) xs(i)).y(do ys($1)).curve(curveMonotoneX)
		let fill = area!.x(do(_, i) xs(i)).y0(height).y1(do ys($1)).curve(curveMonotoneX)
		let band = scaleBand!.domain(values.map(do(_, i) i)).range([0, 100]).padding(0.25)

		<self role='img' aria-label=(label or uiLocale.messages.chart.trend(values.map(do formatNumber($1)).join(', '))) style="height: {height}px">
			<svg.svg viewBox="0 0 100 {height}" preserveAspectRatio='none' aria-hidden='true'>
				if variant == 'bar'
					for value, i in values
						<rect x=band(i) y=ys(value) width=band.bandwidth! height=Math.max(0, height - ys(value)) fill=colour rx=0.5>
				else
					if variant == 'area'
						<defs>
							<linearGradient id=chartId x1='0' x2='0' y1='0' y2='1'>
								<stop offset='0%' stop-color=colour stop-opacity='0.3'>
								<stop offset='100%' stop-color=colour stop-opacity='0'>
						<path d=fill(values) fill="url(#{chartId})">
					<path.line d=path(values) fill='none' stroke=colour>

# Parts of a whole as a ring (or a pie), with the total (or your text) in
# the middle, a legend, and the value on hover.
#
# - `data`: `{ label, value, color }` (colours from $ui-chart-1…5 by default)
# - `size`: its width and height in px (160)
# - `thickness`: the ring's width, a share of the radius (0.32; 1 for a pie)
# - `center`: the middle's caption under the total ('Total'); `false` for an
#   empty middle; the `center` slot replaces it all
# - `legend`: beside it ('right', default), 'bottom' or false
# - `format`: a function turning a value into text, for the total, legend
#   and tooltip
# - `label`: what it shows, for assistive tech (a hidden table of the data)
tag ui-donut-chart-base
	prop data = []
	prop size = 160
	prop thickness = 0.32
	prop center = null
	prop legend = 'right'
	prop format = null
	prop label = null

	hover = null

	def fmt value
		return format(value) if format
		typeof value == 'number' ? formatNumber(value) : String(value ?? '')

	def render
		let rows = data or []
		let px = Number(size)
		let total = rows.reduce((do(sum, d) sum + Math.max(0, +d.value or 0)), 0)
		let radius = px / 2
		let inner = thickness >= 1 ? 0 : radius * (1 - thickness)
		let slices = pie!.value(do Math.max(0, +$1.value or 0)).sort(null).padAngle(rows.length > 1 and inner > 0 ? 0.012 : 0)(rows)
		let shape = arc!.innerRadius(inner).outerRadius(radius).cornerRadius(inner > 0 ? 2 : 0)
		let grown = arc!.innerRadius(inner).outerRadius(radius + 4).cornerRadius(inner > 0 ? 2 : 0)
		let shown = hover != null ? rows[hover] : null

		<self data-legend=(legend or undefined)>
			<div.frame style="width: {px}px; height: {px}px">
				<svg.svg width=px height=px viewBox="{-radius - 4} {-radius - 4} {px + 8} {px + 8}" aria-hidden='true'>
					for s, i in slices
						<path.slice d=(hover == i ? grown : shape)(s) fill=seriesColor(rows[i].color, i) .dim=(hover != null and hover != i) @pointerenter=(hover = i) @pointerleave=(hover = null)>
				# The middle: the hovered slice, or the total (or your own).
				if inner > 0 and center !== false
					<div.center>
						if shown
							<strong> fmt(shown.value)
							<span> shown.label
						else
							<slot name='center'>
								<div.center-total>
									<strong> fmt(total)
									<span> center ?? uiLocale.messages.chart.total
			if legend
				<ul.legend> for d, i in rows
					<li.legend-item .dim=(hover != null and hover != i) @pointerenter=(hover = i) @pointerleave=(hover = null)>
						<span.swatch style="background: {seriesColor(d.color, i)}">
						<span.legend-label> d.label
						<span.legend-value>
							fmt(d.value)
							<small> " {Math.round((d.value / total) * 100)}%" if total > 0
			<table.sr-only>
				<caption> label ?? uiLocale.messages.chart.label
				for d in rows
					<tr>
						<td> d.label
						<td> fmt(d.value)
