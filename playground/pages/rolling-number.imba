import source from './rolling-number.imba?raw'

tag page-rolling-number
	count = 128
	revenue = 18420

	def bump
		count += Math.round(Math.random! * 40 - 12)
		revenue += Math.round(Math.random! * 4000 - 1000)

	css
		.big fs:3xl fw:700

	<self>
		<demo-page source=source heading='Rolling number' intro="ui-rolling-number rolls its digits to a new value, e.g. a live count on a dashboard. It stays still when the system asks for less motion; assistive tech reads the whole number.">
			<demo-section heading='Live values'>
				<div.row>
					<ui-rolling-number.big value=count>
					<ui-rolling-number.big value=revenue format={ style: 'currency', currency: 'GBP', maximumFractionDigits: 0 }>
				<div.out>
					<div.set>
						<button @click=bump> "Change"

			<demo-section heading='In a stat'>
				<ui-stats columns=2>
					<ui-stat label='Appointments today' value=count animate>
					<ui-stat label='Revenue' value=revenue animate format={ style: 'currency', currency: 'GBP', maximumFractionDigits: 0 }>
