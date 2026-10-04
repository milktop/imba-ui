import { subjectItems } from '../data.imba'

# A form in a card, with its actions in the footer.
tag form-card
	student = { name: '', email: '', year: 10, subject: null }
	css max-width:36rem
	<self>
		<ui-card heading='Add a student' description='They’ll get an email to set up their account.'>
			<ui-fields>
				<ui-field label='Name' bind=student.name>
				<ui-field span=8 label='Email' type='email' bind=student.email>
				<ui-field span=4 label='Year' type='number' min=7 max=13 bind=student.year>
				<ui-field label='Subject'>
					<ui-select items=subjectItems placeholder='Choose a subject' bind=student.subject>
			<div slot='footer'>
				<ui-button> "Cancel"
				<ui-button variant='primary'> "Add student"

# A settings section: what it's for on one side, the fields on the other.
tag form-section
	css
		d:flex flw:wrap g:4 cg:8
		.about fl:1 1 14rem
		h3 m:0 fs:md fw:600
		p m:0 mt:1 c:$ui-muted fs:sm
		ui-card fl:2 1 24rem min-width:0
		.switches d:flex fld:column g:4
	<self>
		<div.about>
			<h3> "Reminders"
			<p> "Sent to students (and parents) before each lesson."
		<ui-card>
			<div.switches>
				<ui-switch label='Email, the day before' checked>
				<ui-switch label='Text message, an hour before'>
			<div slot='footer'>
				<ui-button variant='primary' size='sm'> "Save"

# A destructive action, set apart, with a confirmation.
tag form-danger
	confirming = no
	css
		max-width:36rem
		.row d:flex ai:center jc:space-between g:4 flw:wrap
		h3 m:0 fs:md fw:600 c:$ui-danger
		p m:0 mt:1 c:$ui-muted fs:sm
	<self>
		<ui-card>
			<div.row>
				<div>
					<h3> "Delete account"
					<p> "Removes your students, lessons and invoices for good."
				<ui-dialog alert size='sm' closable=false heading='Delete your account?' description='This can’t be undone. Download your invoices first if you need them.' bind=confirming>
					<ui-button slot='trigger' variant='danger'> "Delete account"
					<div slot='footer'>
						<ui-button @click=(confirming = no)> "Keep it"
						<ui-button variant='danger' @click=(confirming = no)> "Delete for good"

export const examples = [
	{ heading: 'Card form', tag: 'form-card' }
	{ heading: 'Settings section', tag: 'form-section' }
	{ heading: 'Danger zone', tag: 'form-danger' }
]
