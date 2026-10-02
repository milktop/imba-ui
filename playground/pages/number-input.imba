import source from './number-input.imba?raw'

tag page-number-input
	price = null
	weight = null
	quantity = 1
	fee = 40

	<self>
		<demo-page source=source heading='Number input' intro='ui-number-input steps with buttons and arrow keys (Shift for 10), clamps to min/max on blur and emits a number. A ui-field with type="number" renders one.'>
			<demo-section heading='Basic'>
				<ui-fields>
					<ui-field span=4 label='Quantity' type='number' min=1 max=10 hint='1 to 10' bind=quantity>
				<div.out>
					<json-print data={ quantity }>

			<demo-section heading='Prefix, suffix and step'>
				<ui-fields>
					<ui-field span=4 label='Price' type='number' prefix='£' min=0 formatOptions={ minimumFractionDigits: 2, maximumFractionDigits: 2 } bind=price>
					<ui-field span=4 label='Weight' type='number' suffix='kg' min=0 max=200 step=0.5 bind=weight>
				<div.out>
					<json-print data={ price, weight }>
					<div.set>
						<button @click=(price = 12.5)> "Price £12.50"
						<button @click=(weight = null)> "Clear weight"

			<demo-section heading='Currency formatting'>
				<ui-fields>
					<ui-field span=4 label='Hourly fee' type='number' min=0 step=5 formatOptions={ style: 'currency', currency: 'GBP' } bind=fee>
				<div.out>
					<json-print data={ fee }>
					<p.note> "Typed values update live; change fires on blur, with a plain number."

			<demo-section heading='Without steppers'>
				<ui-fields>
					<ui-field span=4 label='Weight' type='number' suffix='kg' step=0.5 steppers=false hint='↑/↓ to step' bind=weight>
