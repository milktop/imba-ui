import '../demo.imba'

tag page-choices
	reminders = { email: yes, sms: no, push: no }
	terms = no
	online = yes
	holidays = no
	view = 'week'
	mode = 1
	views = [{ value: 'day', label: 'Day' }, { value: 'week', label: 'Week' }, { value: 'month', label: 'Month' }, { value: 'year', label: 'Year', disabled: true }]
	modes = [{ value: 1, label: 'Online' }, { value: 2, label: 'In person' }, { value: 3, label: 'Hybrid' }]

	get allReminders
		let on = Object.values(reminders).filter(Boolean).length
		on == 0 ? false : (on == 3 ? true : 'indeterminate')

	def setAllReminders checked
		reminders = { email: checked, sms: checked, push: checked }

	<self>
		<demo-page heading='Choices' intro='Checkboxes, switches and segmented controls.'>
			<demo-section heading='Checkbox'>
				<ui-fields>
					<ui-field span=6 label='Reminders' hint='Indeterminate when only some are on'>
						<ui-checkbox label='All reminders' checked=allReminders @change=setAllReminders(e.detail)>
						<div.indent>
							<ui-checkbox label='Email' bind=reminders.email>
							<ui-checkbox label='SMS' bind=reminders.sms>
							<ui-checkbox label='Push notification' bind=reminders.push>
					<ui-field span=6 label='Terms' error=(terms ? null : 'Please accept to continue')>
						<ui-checkbox label='I accept the terms' bind=terms>
				<div.out>
					<pre> JSON.stringify({ reminders, terms })

			<demo-section heading='Switch'>
				<ui-fields>
					<ui-field span=6 label='Lessons'>
						<ui-switch label='Offer online lessons' bind=online>
					<ui-field span=6 label='Availability' hint='Disabled'>
						<ui-switch label='Teach during holidays' disabled bind=holidays>
				<div.out>
					<pre> JSON.stringify({ online, holidays })
					<div.set>
						<button @click=(online = !online)> "Toggle from outside"

			<demo-section heading='Segmented'>
				<ui-fields>
					<ui-field span=6 label='Calendar view'>
						<ui-segmented items=views bind=view>
					<ui-field span=6 label='Mode' hint='Item values stay numbers'>
						<ui-segmented items=modes bind=mode>
				<div.out>
					<pre> JSON.stringify({ view, mode })
