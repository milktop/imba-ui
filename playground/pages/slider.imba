import source from './slider.imba?raw'

tag page-slider
	volume = 40
	price = [20, 60]
	length = 45
	changes = 0

	<self>
		<demo-page source=source heading='Slider' intro='ui-slider picks a number, or a range with an array value. The value updates while dragging; change fires when you let go.'>
			<demo-section heading='Single'>
				<ui-fields>
					<ui-field span=6 label='Volume'>
						<ui-slider showValue bind=volume @change=(changes++)>
				<div.out>
					<json-print data={ volume, changes }>
					<div.set>
						<button @click=(volume = 75)> "75"

			<demo-section heading='Range, formatted'>
				<ui-fields>
					<ui-field span=6 label='Price per hour' hint='Two thumbs; they can’t cross'>
						<ui-slider min=0 max=100 step=5 showValue formatOptions={ style: 'currency', currency: 'GBP', maximumFractionDigits: 0 } bind=price>
				<div.out>
					<json-print data={ price }>

			<demo-section heading='Steps with marks'>
				<ui-fields>
					<ui-field span=6 label='Lesson length'>
						<ui-slider min=30 max=90 step=15 marks=[30, 45, 60, 75, 90] showValue formatOptions={ style: 'unit', unit: 'minute' } bind=length>
				<div.out>
					<json-print data={ length }>
