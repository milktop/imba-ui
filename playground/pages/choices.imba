import '../demo.imba'
import source from './choices.imba?raw'

tag page-choices
	reminders = { email: yes, sms: no, push: no }
	channels = ['email', 'push']
	channelItems = [{ value: 'email', label: 'Email' }, { value: 'sms', label: 'SMS' }, { value: 'push', label: 'Push notification' }, { value: 'post', label: 'Post', disabled: true }]
	days = [2, 4]
	dayItems = [{ value: 1, label: 'Mon' }, { value: 2, label: 'Tue' }, { value: 3, label: 'Wed' }, { value: 4, label: 'Thu' }, { value: 5, label: 'Fri' }]
	length = 45
	lengths = [
		{ value: 30, label: '30 minutes', description: 'A quick check-in or homework help' }
		{ value: 45, label: '45 minutes', description: 'Our most popular length' }
		{ value: 60, label: '60 minutes', description: 'Room for a full topic and practice' }
		{ value: 90, label: '90 minutes', description: 'Only for exam preparation', disabled: true }
	]
	level = null
	levels = ['GCSE', 'A level', 'University']
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
		<demo-page source=source heading='Choices' intro='Checkbox and radio groups, single checkboxes, switches and segmented controls.'>
			<demo-section heading='Checkbox group'>
				<ui-fields>
					<ui-field span=6 label='Reminders' hint='Bound to an array; Post is disabled' error=(channels.length ? null : 'Pick at least one')>
						<ui-checkbox-group items=channelItems selectAll='All reminders' bind=channels>
					<ui-field span=6 label='Days' hint='Item values stay numbers'>
						<ui-checkbox-group items=dayItems orientation='horizontal' bind=days>
				<div.out>
					<json-print data={ channels, days }>
					<div.set>
						<button @click=(channels = ['sms'])> "Only SMS"
						<button @click=(channels = [])> "None"

			<demo-section heading='Radio group'>
				<ui-fields>
					<ui-field span=6 label='Lesson length'>
						<ui-radio-group items=lengths bind=length>
					<ui-field span=6 label='Level' hint='Horizontal, starts empty'>
						<ui-radio-group items=levels orientation='horizontal' bind=level>
				<div.out>
					<json-print data={ length, level }>
					<div.set>
						<button @click=(length = 60)> "60 minutes"
						<button @click=(level = null)> "Clear level"

			<demo-section heading='Checkbox'>
				<ui-fields>
					<ui-field span=6 label='Custom model' hint='Single checkboxes wired to an object of booleans by hand'>
						<ui-checkbox label='All reminders' checked=allReminders @change=setAllReminders(e.detail)>
						<div.indent>
							<ui-checkbox label='Email' bind=reminders.email>
							<ui-checkbox label='SMS' bind=reminders.sms>
							<ui-checkbox label='Push notification' bind=reminders.push>
					<ui-field span=6 label='Terms' error=(terms ? null : 'Please accept to continue')>
						<ui-checkbox label='I accept the terms' bind=terms>
				<div.out>
					<json-print data={ reminders, terms }>

			<demo-section heading='Switch'>
				<ui-fields>
					<ui-field span=6 label='Lessons'>
						<ui-switch label='Offer online lessons' bind=online>
					<ui-field span=6 label='Availability' hint='Disabled'>
						<ui-switch label='Teach during holidays' disabled bind=holidays>
				<div.out>
					<json-print data={ online, holidays }>
					<div.set>
						<button @click=(online = !online)> "Toggle from outside"

			<demo-section heading='Segmented'>
				<ui-fields>
					<ui-field span=6 label='Calendar view'>
						<ui-segmented items=views bind=view>
					<ui-field span=6 label='Mode' hint='Item values stay numbers'>
						<ui-segmented items=modes bind=mode>
				<div.out>
					<json-print data={ view, mode }>
