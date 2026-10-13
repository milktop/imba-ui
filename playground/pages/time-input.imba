import source from './time-input.imba?raw'

tag page-time-input
	starts = '09:30'
	reminder = null

	<self>
		<demo-page source=source heading='Time input' intro="ui-time-input takes a time of day, typed or picked with the browser's own control (a wheel on phones), as 'HH:mm'.">
			<demo-section heading='Steps and limits'>
				<ui-fields>
					<ui-field span=6 label='Starts' hint='Quarter hours, 08:00 to 18:00'>
						<ui-time-input step=15 min='08:00' max='18:00' bind=starts>
				<div.out>
					<json-print data={ starts }>
					<div.set>
						<button @click=(starts = '14:00')> "14:00"

			<demo-section heading='Empty, without an icon'>
				<ui-fields>
					<ui-field span=6 label='Reminder'>
						<ui-time-input icon=null bind=reminder>
				<div.out>
					<json-print data={ reminder }>
					<div.set>
						<button @click=(reminder = null)> "Clear"
