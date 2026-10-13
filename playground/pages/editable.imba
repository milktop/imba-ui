import source from './editable.imba?raw'

tag page-editable
	pet = 'Biscuit'
	price = '£45.00'
	notes = ''

	<self>
		<demo-page source=source heading='Editable' intro='ui-editable is text you click to edit in place: Enter (or clicking away) saves, Escape cancels.'>
			<demo-section heading='In place'>
				<ui-fields>
					<ui-field span=6 label='Name'>
						<ui-editable bind=pet>
					<ui-field span=6 label='Consult price'>
						<ui-editable bind=price activationMode='dblclick'>
				<div.out>
					<json-print data={ pet, price }>
					<div.set>
						<button @click=(pet = 'Rex')> "Rex"

			<demo-section heading='Placeholder, no buttons'>
				<ui-editable label='Notes' placeholder='Add a note…' controls=no bind=notes>
				<div.out>
					<json-print data={ notes }>
