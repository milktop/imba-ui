import source from './buttons.imba?raw'

tag page-buttons
	saving = no
	clicks = 0

	def save
		saving = yes
		await new Promise(do setTimeout($1, 1500))
		saving = no
		imba.commit!

	css
		.row d:hflex flw:wrap g:2 ai:center

	<self>
		<demo-page source=source heading='Buttons' intro='ui-button is a real <button>, so labels, types and forms work natively. Primary uses $ui-accent; heights come from $ui-control-height.'>
			<demo-section heading='Variants'>
				<div.row>
					<ui-button @click=(clicks++)> "Default"
					<ui-button variant='primary' @click=(clicks++)> "Primary"
					<ui-button variant='danger' @click=(clicks++)> "Delete"
					<ui-button variant='soft' @click=(clicks++)> "Soft"
					<ui-button variant='ghost' @click=(clicks++)> "Ghost"
					<ui-button variant='link' @click=(clicks++)> "Forgot password?"
					<ui-button disabled> "Disabled"
				<div.out>
					<json-print data={ clicks }>

			<demo-section heading='Sizes and icons'>
				<div.row>
					<ui-button size='sm' icon='lucide:plus'> "Small"
					<ui-button icon='lucide:plus'> "Medium"
					<ui-button size='lg' icon='lucide:plus'> "Large"
					<ui-button iconEnd='lucide:arrow-right' variant='primary'> "Next"
				<div.row>
					<ui-button size='sm' icon='lucide:pencil' aria-label='Edit'>
					<ui-button icon='lucide:pencil' aria-label='Edit'>
					<ui-button size='lg' icon='lucide:pencil' aria-label='Edit'>
					<ui-tooltip content='Settings'>
						<ui-button variant='ghost' icon='lucide:settings' aria-label='Settings'>

			<demo-section heading='Loading'>
				<div.row>
					<ui-button variant='primary' icon='lucide:save' loading=saving @click=save> saving ? "Saving…" : "Save"
					<ui-button loading=saving icon='lucide:refresh-cw' aria-label='Refresh' @click=save>
				<div.out>
					<json-print data={ saving }>

			<demo-section heading='Block'>
				<ui-button variant='primary' block> "Book a lesson"
				<ui-fields>
					<ui-field span=8 label='Email' type='email' placeholder='you@example.com'>
					<ui-field span=4 label=' '>
						<ui-button variant='primary' block type='submit'> "Subscribe"
