import source from './button.imba?raw'

tag page-button
	css
		.purple --ui-button-count-bg:#9333ea --ui-button-count-text:white

	saving = no
	clicks = 0
	unread = 3

	def save
		saving = yes
		await new Promise(do setTimeout($1, 1500))
		saving = no
		imba.commit!

	<self>
		<demo-page source=source heading='Button' intro='ui-button is a real <button>, so labels, types and forms work natively. Primary uses $ui-accent; heights come from $ui-control-height.'>
			<demo-section heading='Variants'>
				<div.row>
					<ui-button @click=(clicks++)> "Default"
					<ui-button variant='primary' @click=(clicks++)> "Primary"
					<ui-button variant='soft' @click=(clicks++)> "Soft"
					<ui-button variant='danger' @click=(clicks++)> "Delete"
					<ui-button variant='ghost' @click=(clicks++)> "Ghost"
					<ui-button variant='link' @click=(clicks++)> "Forgot password?"
				<div.out>
					<json-print data={ clicks }>

			<demo-section heading='Sizes'>
				<div.row>
					<ui-button size='sm'> "Small"
					<ui-button> "Medium"
					<ui-button size='lg'> "Large"

			<demo-section heading='Icons'>
				<div.row>
					<ui-button icon='lucide:plus'> "Add lesson"
					<ui-button variant='primary' iconEnd='lucide:arrow-right'> "Next"
					<ui-button variant='ghost' icon='lucide:download'> "Export"

			<demo-section heading='Icon only'>
				<div.row>
					<ui-button size='sm' icon='lucide:pencil' aria-label='Edit'>
					<ui-button icon='lucide:pencil' aria-label='Edit'>
					<ui-button size='lg' icon='lucide:pencil' aria-label='Edit'>
					<ui-tooltip content='Settings'>
						<ui-button variant='ghost' icon='lucide:settings' aria-label='Settings'>
				<div.row>
					<ui-button round size='sm' icon='lucide:pencil' aria-label='Edit'>
					<ui-button round icon='lucide:pencil' aria-label='Edit'>
					<ui-button round size='lg' variant='primary' icon='lucide:plus' aria-label='Add'>
					<ui-button round variant='ghost' icon='lucide:settings' aria-label='Settings'>
					<ui-button round icon='lucide:plus'> "Pill with text"
				<div.out>
					<p.note> "With no text a button is square, matching the inputs and the radius setting; `round` makes it a circle (or a pill, with text). Give icon buttons an aria-label, and perhaps a tooltip."

			<demo-section heading='Counts and dots'>
				<div.row [g:4 rg:5]>
					<ui-button variant='ghost' icon='lucide:bell' aria-label='Notifications' count=unread>
					<ui-button icon='lucide:inbox' count=unread> "Inbox"
					<ui-button variant='primary' icon='lucide:shopping-cart' count=128> "Basket"
					<ui-button round icon='lucide:message-square' aria-label='Messages' count=unread countColor='accent'>
					<ui-button variant='ghost' icon='lucide:bell' aria-label='Notifications' dot>
					<ui-button size='sm' icon='lucide:filter' count=2 countColor='neutral'> "Filters"
				<div.row [g:4 rg:5]>
					<ui-button icon='lucide:circle-check' count=4 countColor='success' countLabel='done'> "Tasks"
					<ui-button icon='lucide:triangle-alert' count=1 countColor='warning' countLabel='to review'> "Reports"
					<ui-button.purple icon='lucide:sparkles' count=5> "Custom colour"
				<div.out>
					<div.set>
						<button @click=(unread++)> "Add one"
						<button @click=(unread = 0)> "Mark all read"
					<p.note> "`count` hides at 0 and caps at `max` (99+). `countColor` picks a preset; for any other colour set `--ui-button-count-bg` (and `-text`) in CSS, as the purple one does. The count joins the button's accessible name (\"Notifications, 3 new\"; `countLabel` sets the word)."

			<demo-section heading='Loading and disabled'>
				<div.row>
					<ui-button variant='primary' icon='lucide:save' loading=saving @click=save> saving ? "Saving…" : "Save"
					<ui-button loading=saving icon='lucide:refresh-cw' aria-label='Refresh' @click=save>
					<ui-button disabled> "Disabled"
				<div.out>
					<json-print data={ saving }>

			<demo-section heading='Block'>
				<ui-button variant='primary' block> "Book a lesson"
				<ui-fields>
					<ui-field span=8 label='Email' type='email' placeholder='you@example.com'>
					<ui-field span=4 label=' '>
						<ui-button variant='primary' block type='submit'> "Subscribe"
				<div.out>
					<p.note> "A button lines up with an input in the same row."
