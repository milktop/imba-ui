import source from './phone-input.imba?raw'

tag page-phone-input
	phone = '+33553639304'
	other = ''
	abroad = '+447400123456'

	<self>
		<demo-page source=source heading='Phone input' intro='ui-phone-input formats a number for its country and shows its flag, which also picks the country: a list you search by name or dialling code, or the browser’s own select on touch screens. A ui-field with type="phone" renders one.'>
			<demo-section heading='Home and abroad'>
				<ui-fields>
					<ui-field span=6 label='Phone' type='phone' country='FR' showType bind=phone>
					<ui-field span=6 label='Other phone' type='phone' country='FR' countries=['FR', 'BE', 'GB', 'IE'] showType bind=other>
				<div.out>
					<json-print data={ phone, other }>
					<p.note> "Type 06 12 34 56 78, or +44 7400 123456. For an Irish number typed as 087 677 8877, pick Ireland from the flag (search “irl” or “353”). Leave a number half typed to see why it’s rejected."

			<demo-section heading='Native picker, on its own'>
				<ui-phone-input label='Mobile' country='GB' picker='native' showType bind=abroad>
				<div.out>
					<json-print data={ abroad }>
