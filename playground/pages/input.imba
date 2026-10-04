import source from './input.imba?raw'

tag page-input
	query = ''
	email = ''
	password = ''
	showPassword = no
	url = ''
	code = ''

	css
		.peek d:grid place-items:center w:7 h:7 mr:-2 bd:none bg:transparent rd:sm c:$ui-muted cursor:pointer
			@hover bg:$ui-hover c:$ui-text

	<self>
		<demo-page source=source heading='Input' intro='ui-input is a text input in a box, with optional icon, prefix and suffix. Inside a ui-field it gets a label, hint and error.'>
			<demo-section heading='In a field'>
				<ui-fields>
					<ui-field span=6 label='Search' icon='lucide:search' placeholder='Search lessons' bind=query>
					<ui-field span=6 label='Email' type='email' icon='lucide:mail' required hint="We'll never share it" error=(email and !email.includes('@') ? 'Enter a valid email' : null) bind=email>
				<div.out>
					<json-print data={ query, email }>
					<p.note> "A field with no children renders a ui-input and passes on type, placeholder, icon and so on."

			<demo-section heading='Prefix and suffix'>
				<ui-fields>
					<ui-field span=6 label='Website' prefix='https://' placeholder='example.com' bind=url>
					<ui-field span=6 label='Discount' suffix='%' attrs={ maxlength: 3, inputmode: 'numeric' } bind=code>
				<div.out>
					<json-print data={ url, code }>

			<demo-section heading='Slots'>
				<ui-fields>
					<ui-field span=6 label='Password' hint='At least 8 characters'>
						<ui-input type=(showPassword ? 'text' : 'password') icon='lucide:key' autocomplete='new-password' bind=password>
							<ui-tooltip slot='suffix' content=(showPassword ? 'Hide password' : 'Show password')>
								<button.peek type='button' aria-label=(showPassword ? 'Hide password' : 'Show password') @click=(showPassword = !showPassword)>
									<iconify-icon icon=(showPassword ? 'lucide:eye-off' : 'lucide:eye')>
				<div.out>
					<json-print data={ password }>
					<p.note> "The prefix and suffix slots take anything, like this show/hide button."

			<demo-section heading='Disabled'>
				<ui-fields>
					<ui-field span=6 label='Account ID' disabled value='TUT-0042'>

			<demo-section heading='Round'>
				<ui-input round icon='lucide:search' placeholder='Search students…' [w:100% max-width:24rem]>
				<div.out>
					<p.note> "`round` makes a pill, e.g. for a search box."
