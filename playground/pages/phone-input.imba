import source from './phone-input.imba?raw'

tag page-phone-input
	phone = '+33553639304'
	other = ''
	abroad = '+447400123456'

	<self>
		<demo-page source=source heading='Phone input' intro='ui-phone-input formats a number for its country and shows its flag, which also picks the country. A ui-field with type="phone" renders one.'>
			<demo-section heading='Home and abroad'>
				<ui-fields>
					<ui-field span=6 label='Phone' type='phone' country='FR' showType bind=phone>
					<ui-field span=6 label='Other phone' type='phone' country='FR' countries=['FR', 'BE', 'GB', 'IE'] showType bind=other>
				<div.out>
					<json-print data={ phone, other }>
					<p.note> "Type 06 12 34 56 78, or +44 7400 123456. For an Irish number typed as 087 677 8877, pick Ireland from the flag first."

			<demo-section heading='On its own'>
				<ui-phone-input label='Mobile' country='GB' showType bind=abroad>
				<div.out>
					<json-print data={ abroad }>
