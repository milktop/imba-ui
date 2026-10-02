import { subjects } from '../demo.imba'
import source from './forms.imba?raw'

tag page-forms
	student = { first: '', last: '', email: '', year: null, subjects: [], start: null, online: yes }
	errors = {}
	locked = no
	years = [7, 8, 9, 10, 11, 12, 13].map(do { value: $1, label: "Year {$1}" })

	def validate
		errors = {}
		errors.first = 'Required' unless student.first
		errors.email = 'Enter a valid email' unless student.email.includes('@')
		errors.subjects = 'Pick at least one subject' unless student.subjects.length

	<self>
		<demo-page source=source heading='Forms' intro='ui-fields lays fields out on a 12-column grid; with a legend it becomes a fieldset.'>
			<demo-section heading='Student form'>
				<ui-fields legend='Student' description='Who the lessons are for' disabled=locked>
					<ui-field span=6 label='First name' required error=errors.first bind=student.first>
					<ui-field span=6 label='Last name' bind=student.last>
					<ui-field span=8 label='Email' type='email' icon='lucide:mail' required hint="We'll send lesson reminders here" error=errors.email bind=student.email>
					<ui-field span=4 label='Year group'>
						<ui-select items=years bind=student.year>
				<ui-fields legend='Lessons' disabled=locked>
					<ui-field span=6 label='Subjects' error=errors.subjects>
						<ui-combobox items=subjects multiple placeholder='Add…' bind=student.subjects>
					<ui-field span=6 label='Start date' hint='Lessons start from this date'>
						<ui-date-picker bind=student.start>
					<ui-field span=12>
						<ui-switch label='Online lessons' bind=student.online>
				<div.out>
					<div.set>
						<button @click=validate> "Validate"
						<button @click=(errors = {})> "Clear errors"
						<button @click=(locked = !locked)> locked ? "Unlock" : "Lock"
					<json-print fixed label='Form state' data={ student, errors, locked }>
