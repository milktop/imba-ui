import source from './password-input.imba?raw'

tag page-password-input
	current = ''
	created = ''

	get strength
		return null unless created
		let score = [/.{8,}/, /[A-Z]/, /[0-9]/, /[^A-Za-z0-9]/].filter(do $1.test(created)).length
		['Weak', 'Weak', 'Fair', 'Good', 'Strong'][score]

	<self>
		<demo-page source=source heading='Password input' intro='ui-password-input has a show/hide button. A ui-field with type="password" renders one.'>
			<demo-section heading='Sign in'>
				<ui-fields>
					<ui-field span=6 label='Password' type='password' icon='lucide:key' bind=current>
				<div.out>
					<json-print data={ current }>

			<demo-section heading='New password'>
				<ui-fields>
					<ui-field span=6 label='New password' type='password' autocomplete='new-password' hint=(strength ? "Strength: {strength}" : 'At least 8 characters') error=(created and created.length < 8 ? 'Too short' : null) bind=created>
				<div.out>
					<json-print data={ created, strength }>
					<p.note> "autocomplete='new-password' tells password managers to suggest one."
