import '../demo.imba'

tag page-inputs
	query = ''
	password = ''
	showPassword = no
	price = null
	weight = null
	quantity = 1
	notes = ''
	bio = ''

	css
		.peek d:grid place-items:center w:7 h:7 mr:-2 bd:none bg:transparent rd:sm c:$ui-muted cursor:pointer
			@hover bg:$ui-hover c:$ui-text

	<self>
		<demo-page heading='Inputs' intro='Text, number and multi-line inputs, on their own or inside a ui-field.'>
			<demo-section heading='Text input'>
				<ui-fields>
					<ui-field span=6 label='Search' icon='lucide:search' placeholder='Search lessons' bind=query>
					<ui-field span=6 label='Password' hint='At least 8 characters'>
						<ui-input type=(showPassword ? 'text' : 'password') icon='lucide:key' autocomplete='new-password' bind=password>
							<button.peek slot='suffix' type='button' aria-label=(showPassword ? 'Hide password' : 'Show password') @click=(showPassword = !showPassword)>
								<iconify-icon icon=(showPassword ? 'lucide:eye-off' : 'lucide:eye')>
				<div.out>
					<pre> JSON.stringify({ query, password })

			<demo-section heading='Number input'>
				<ui-fields>
					<ui-field span=4 label='Price' type='number' prefix='£' min=0 formatOptions={ minimumFractionDigits: 2, maximumFractionDigits: 2 } bind=price>
					<ui-field span=4 label='Weight' type='number' suffix='kg' min=0 max=200 step=0.5 steppers=false hint='↑/↓ to step, ⇧ for 10' bind=weight>
					<ui-field span=4 label='Quantity' type='number' min=1 max=10 hint='1 to 10' bind=quantity>
				<div.out>
					<pre> JSON.stringify({ price, weight, quantity })
					<div.set>
						<button @click=(price = 12.5)> "Price £12.50"
						<button @click=(weight = null)> "Clear weight"

			<demo-section heading='Textarea'>
				<ui-fields>
					<ui-field span=6 label='Notes' type='textarea' rows=2 maxRows=6 hint='Grows up to 6 lines' bind=notes>
					<ui-field span=6 label='Bio' hint='Fixed height, resizable'>
						<ui-textarea rows=3 autogrow=false bind=bio>
				<div.out>
					<pre> JSON.stringify({ notes, bio })
