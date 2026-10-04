# A settings page: sections with a title and description beside their
# fields, and a bar to save or discard changes.
tag block-settings
	saved = { name: 'Grace Hopper', email: 'grace@example.com', bio: 'Maths and physics tutor, GCSE and A level.', lessonLength: 60, reminders: yes, digest: no, marketing: no }
	form = Object.assign({}, saved)
	lengths = [{ value: 45, label: '45 min' }, { value: 60, label: '60 min' }, { value: 90, label: '90 min' }]

	get dirty do JSON.stringify(form) != JSON.stringify(saved)

	def save
		saved = Object.assign({}, form)
		emit('saved')

	css
		d:flex fld:column g:8
		# Title beside the fields when there's room, above them when not.
		.section d:flex flw:wrap g:4 cg:8 pb:8 bdb:1px solid $ui-border
		.about fl:1 1 14rem
		.section > ui-card fl:2 1 24rem min-width:0
		h3 m:0 fs:md fw:600
		.about p m:0 mt:1 c:$ui-muted fs:sm
		.switches d:flex fld:column g:4
		.bar d:flex ai:center jc:flex-end g:2 flw:wrap
		.unsaved mr:auto c:$ui-muted fs:sm

	<self>
		<div.section>
			<div.about>
				<h3> "Profile"
				<p> "How students and parents see you."
			<ui-card>
				<ui-fields>
					<ui-field span=6 label='Name' bind=form.name>
					<ui-field span=6 label='Email' type='email' bind=form.email>
					<ui-field label='Bio' type='textarea' hint='Shown on your booking page.' bind=form.bio>
		<div.section>
			<div.about>
				<h3> "Lessons"
				<p> "Defaults for new bookings."
			<ui-card>
				<ui-fields>
					<ui-field label='Default length'>
						<ui-segmented items=lengths bind=form.lessonLength>
		<div.section>
			<div.about>
				<h3> "Notifications"
				<p> "What we email you about."
			<ui-card>
				<div.switches>
					<ui-switch label='Lesson reminders, the day before' bind=form.reminders>
					<ui-switch label='A weekly summary' bind=form.digest>
					<ui-switch label='News and offers' bind=form.marketing>
		<div.bar>
			<span.unsaved> "You have unsaved changes" if dirty
			<ui-button disabled=!dirty @click=(form = Object.assign({}, saved))> "Discard"
			<ui-button variant='primary' disabled=!dirty @click=save> "Save changes"
