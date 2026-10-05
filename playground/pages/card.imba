import source from './card.imba?raw'

tag page-card
	css
		.grid d:grid gtc:1fr @md:1fr 1fr g:4 w:100%

	<self>
		<demo-page source=source heading='Card' intro='ui-card groups related content, with an optional header, actions and footer.'>
			<demo-section heading='Header, body and footer' bare>
				<div.grid>
					<ui-card heading='Next lesson' description='Thursday 8 October, 16:00'>
						<ui-button slot='actions' size='sm' variant='ghost' icon='lucide:ellipsis' aria-label='More'>
						<div.row>
							<ui-avatar size='sm' name='Ada Lovelace'>
							<span> "Maths with Ada, Room 4"
						<div slot='footer'>
							<ui-button size='sm'> "Reschedule"
							<ui-button size='sm' variant='primary'> "Join"
					<ui-card heading='This month' description='Lessons taught'>
						<div [fs:3xl fw:700]> "52"
						<ui-progress showValue value=78 label='Monthly goal'>

			<demo-section heading='Body only' bare>
				<ui-card>
					"A plain card is just a bordered surface; give it any content."
