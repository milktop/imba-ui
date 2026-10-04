import source from './charts.imba?raw'

const months = [
	{ month: 'Apr', revenue: 1240, maths: 22, english: 14, physics: 6 }
	{ month: 'May', revenue: 1480, maths: 26, english: 15, physics: 8 }
	{ month: 'Jun', revenue: 1310, maths: 24, english: 12, physics: 9 }
	{ month: 'Jul', revenue: 860, maths: 14, english: 8, physics: 4 }
	{ month: 'Aug', revenue: 720, maths: 11, english: 7, physics: 4 }
	{ month: 'Sep', revenue: 1650, maths: 30, english: 16, physics: 10 }
	{ month: 'Oct', revenue: 1820, maths: 33, english: 18, physics: 12 }
]

const subjects = [
	{ key: 'maths', label: 'Maths' }
	{ key: 'english', label: 'English' }
	{ key: 'physics', label: 'Physics' }
]

const pounds = do(v) "£{v.toLocaleString!}"

tag page-charts
	data = months

	def shuffle
		data = months.map do(m) Object.assign({}, m, { revenue: Math.round(m.revenue * (0.6 + Math.random! * 0.8)), maths: Math.round(m.maths * (0.5 + Math.random!)) })

	css
		.cards d:grid gtc:repeat(auto-fit, minmax(14rem, 1fr)) g:4 w:100%
		.mini d:flex fld:column g:2 p:4 bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius + 4px)
		.mini-label c:$ui-muted fs:sm
		.mini-value fs:xl fw:700
		.wide w:100%

	<self>
		<demo-page source=source heading='Charts' intro='ui-area-chart, ui-bar-chart and ui-sparkline draw SVG in Imba, with d3 for the maths. Colours come from the theme ($ui-chart-1…5, the first being the accent), so they follow dark mode and the accent picker. Hover for a tooltip.'>
			<demo-section heading='Sparklines'>
				<div.cards>
					<div.mini>
						<span.mini-label> "Revenue"
						<span.mini-value> "£1,820"
						<ui-sparkline data=months y='revenue' label='Revenue, April to October'>
					<div.mini>
						<span.mini-label> "Maths lessons"
						<span.mini-value> "33"
						<ui-sparkline data=months y='maths' variant='area' color='success'>
					<div.mini>
						<span.mini-label> "Physics lessons"
						<span.mini-value> "12"
						<ui-sparkline data=months y='physics' variant='bar' height=40>

			<demo-section heading='Area'>
				<ui-area-chart.wide data=data x='month' y='revenue' format=pounds label='Revenue by month'>
				<div.out>
					<div.set>
						<button @click=shuffle> "New data"
						<button @click=(data = months)> "Reset"

			<demo-section heading='Area, several series'>
				<ui-area-chart.wide data=months x='month' series=subjects label='Lessons by subject'>

			<demo-section heading='Stacked area'>
				<ui-area-chart.wide data=months x='month' series=subjects stacked height=200 label='Lessons by subject, stacked'>

			<demo-section heading='Bar'>
				<ui-bar-chart.wide data=data x='month' y='revenue' format=pounds label='Revenue by month'>

			<demo-section heading='Grouped and stacked bars'>
				<ui-bar-chart.wide data=months x='month' series=subjects height=220 label='Lessons by subject'>
				<ui-bar-chart.wide data=months x='month' series=subjects stacked height=220 label='Lessons by subject, stacked'>
