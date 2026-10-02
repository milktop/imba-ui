import source from './alert.imba?raw'

tag page-alert
	showWarning = yes

	<self>
		<demo-page source=source heading='Alert' intro='ui-alert shows a message in the page. For short-lived notifications use Toast.'>
			<demo-section heading='Variants'>
				<div [d:vflex g:3 w:100%]>
					<ui-alert heading='Lessons resume on Monday'> "Half term runs from 26 to 30 October."
					<ui-alert variant='success' heading='Payment received'> "Thanks, invoice #1042 is paid."
					<ui-alert variant='warning' heading='Two lessons overlap'> "Ada has another lesson at 16:30 on Thursday."
					<ui-alert variant='danger' heading='Card declined'> "Update your payment details to keep booking."

			<demo-section heading='With actions, dismissible'>
				<div [d:vflex g:3 w:100%]>
					if showWarning
						<ui-alert variant='warning' heading='Your profile is incomplete' dismissible @dismiss=(showWarning = no)>
							"Students can’t book you until you add your availability."
							<ui-button slot='actions' size='sm'> "Add availability"
					else
						<div.set>
							<button @click=(showWarning = yes)> "Show it again"

			<demo-section heading='Message only'>
				<div [w:100%]>
					<ui-alert icon=false> "No icon, no heading: just a note."
