import source from './switch.imba?raw'

tag page-switch
	online = yes
	holidays = no
	reminders = yes

	<self>
		<demo-page source=source heading='Switch' intro='ui-switch is an on/off toggle; like a checkbox it binds `checked`.'>
			<demo-section heading='Basic'>
				<ui-fields>
					<ui-field span=6 label='Lessons'>
						<ui-switch label='Offer online lessons' bind=online>
				<div.out>
					<json-print data={ online }>
					<div.set>
						<button @click=(online = !online)> "Toggle from outside"

			<demo-section heading='With a hint'>
				<ui-fields>
					<ui-field span=6 label='Notifications' hint='A reminder the day before each lesson'>
						<ui-switch label='Lesson reminders' bind=reminders>

			<demo-section heading='Disabled'>
				<ui-fields>
					<ui-field span=6 label='Availability' hint='Ask an admin to change this'>
						<ui-switch label='Teach during holidays' disabled bind=holidays>
