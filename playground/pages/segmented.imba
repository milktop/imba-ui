import source from './segmented.imba?raw'

tag page-segmented
	view = 'week'
	mode = 1
	views = [{ value: 'day', label: 'Day' }, { value: 'week', label: 'Week' }, { value: 'month', label: 'Month' }, { value: 'year', label: 'Year', disabled: true }]
	modes = [{ value: 1, label: 'Online' }, { value: 2, label: 'In person' }, { value: 3, label: 'Hybrid' }]

	<self>
		<demo-page source=source heading='Segmented' intro='ui-segmented is a compact row of options with an indicator that slides to the selected one.'>
			<demo-section heading='Basic'>
				<ui-fields>
					<ui-field span=6 label='Calendar view' hint='Year is disabled'>
						<ui-segmented items=views bind=view>
				<div.out>
					<json-print data={ view }>

			<demo-section heading='Number values'>
				<ui-fields>
					<ui-field span=6 label='Mode' hint='Item values stay numbers'>
						<ui-segmented items=modes bind=mode>
				<div.out>
					<json-print data={ mode }>
					<div.set>
						<button @click=(mode = 3)> "Hybrid"
