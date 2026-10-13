import source from './swatch-picker.imba?raw'

tag page-swatch-picker
	color = 'teal'
	brand = null
	tutor = 'violet'
	brandColors = [
		{ value: 'brand', color: '#e11d48', label: 'Brand' }
		{ value: 'ink', color: '#0f172a', label: 'Ink' }
		{ value: 'sand', color: '#d6c7a1', label: 'Sand' }
	]

	<self>
		<demo-page source=source heading='Swatch picker' intro="ui-swatch-picker picks a colour from a few swatches. Arrow keys move between them, like radio buttons (which they are). The values are the colours' names, or your own.">
			<demo-section heading='Colours'>
				<ui-fields>
					<ui-field label='Calendar colour'>
						<ui-swatch-picker bind=color>
				<div.out>
					<json-print data={ color }>

			<demo-section heading='Your own, and sizes'>
				<ui-swatch-picker label='Theme' items=brandColors size='lg' bind=brand>
				<ui-swatch-picker label='Small' items=['red', 'amber', 'green', 'blue'] size='sm'>
				<div.out>
					<json-print data={ brand }>

			<demo-section heading='In a popover'>
				<ui-fields>
					<ui-field span=6 label='Tutor colour'>
						<ui-swatch-picker variant='popover' bind=tutor>
				<div.out>
					<json-print data={ tutor }>
