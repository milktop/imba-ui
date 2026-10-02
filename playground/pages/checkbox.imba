import source from './checkbox.imba?raw'

tag page-checkbox
	terms = no
	channels = ['email', 'push']
	channelItems = [{ value: 'email', label: 'Email' }, { value: 'sms', label: 'SMS' }, { value: 'push', label: 'Push notification' }, { value: 'post', label: 'Post', disabled: true }]
	days = [2, 4]
	dayItems = [{ value: 1, label: 'Mon' }, { value: 2, label: 'Tue' }, { value: 3, label: 'Wed' }, { value: 4, label: 'Thu' }, { value: 5, label: 'Fri' }]
	reminders = { email: yes, sms: no, push: no }

	get allReminders
		let on = Object.values(reminders).filter(Boolean).length
		on == 0 ? false : (on == 3 ? true : 'indeterminate')

	def setAllReminders checked
		reminders = { email: checked, sms: checked, push: checked }

	<self>
		<demo-page source=source heading='Checkbox' intro='ui-checkbox binds `checked`; ui-checkbox-group binds an array of the selected items’ values, with an optional select-all box.'>
			<demo-section heading='Single'>
				<ui-fields>
					<ui-field span=6 label='Terms' error=(terms ? null : 'Please accept to continue')>
						<ui-checkbox label='I accept the terms' bind=terms>
				<div.out>
					<json-print data={ terms }>

			<demo-section heading='Group with select all'>
				<ui-fields>
					<ui-field span=6 label='Reminders' hint='Post is disabled' error=(channels.length ? null : 'Pick at least one')>
						<ui-checkbox-group items=channelItems selectAll='All reminders' bind=channels>
				<div.out>
					<json-print data={ channels }>
					<div.set>
						<button @click=(channels = ['sms'])> "Only SMS"
						<button @click=(channels = [])> "None"

			<demo-section heading='Horizontal group'>
				<ui-fields>
					<ui-field span=6 label='Days' hint='Item values stay numbers'>
						<ui-checkbox-group items=dayItems orientation='horizontal' bind=days>
				<div.out>
					<json-print data={ days }>

			<demo-section heading='Custom model'>
				<ui-fields>
					<ui-field span=6 label='Reminders' hint='Single checkboxes wired to an object of booleans by hand'>
						<ui-checkbox label='All reminders' checked=allReminders @change=setAllReminders(e.detail)>
						<div.indent>
							<ui-checkbox label='Email' bind=reminders.email>
							<ui-checkbox label='SMS' bind=reminders.sms>
							<ui-checkbox label='Push notification' bind=reminders.push>
				<div.out>
					<json-print data={ reminders }>
