import 'imba/preflight.css'
import '../src/index.imba'

global css
	body m:0 bg:$ui-surface c:$ui-text ff:system-ui
	html.dark body bg:#09090b

tag demo-section
	prop title
	css
		d:vtl g:4 py:8 bdb:1px solid $ui-border
		h2 fs:md fw:600 m:0
	<self>
		<h2> title
		<slot>

tag playground
	lesson = '2026-10-02'
	away = []
	dark = document.documentElement.classList.contains('dark')

	subjects = [
		{ value: 1, label: 'Maths' }
		{ value: 2, label: 'English' }
		{ value: 3, label: 'Physics' }
		{ value: 4, label: 'Chemistry' }
		{ value: 5, label: 'Biology' }
		{ value: 6, label: 'History' }
		{ value: 7, label: 'Latin', disabled: true }
		{ value: 8, label: 'Computer Science' }
	]
	boards = ['AQA', 'Edexcel', 'OCR', 'WJEC']
	subject = 1
	examBoards = []
	searched = null
	many = []
	tutor = null
	student = { first: '', last: '', email: '', year: null, subjects: [], start: null }
	errors = {}
	years = [7, 8, 9, 10, 11, 12, 13].map(do { value: $1, label: "Year {$1}" })

	def validate
		errors = {}
		errors.first = 'Required' unless student.first
		errors.email = 'Enter a valid email' unless student.email.includes('@')
		errors.subjects = 'Pick at least one subject' unless student.subjects.length

	# Fake server search with latency.
	def findTutors query
		const all = ['Ada Lovelace', 'Alan Turing', 'Grace Hopper', 'Katherine Johnson', 'Marie Curie', 'Rosalind Franklin'].map(do(name, i) { id: i + 1, name })
		await new Promise(do setTimeout($1, 400))
		all.filter(do $1.name.toLowerCase!.includes(query.toLowerCase!))

	def toggleTheme
		dark = !dark
		document.documentElement.classList.toggle('dark', dark)

	css
		d:block max-width:880px mx:auto p:4 @md:8
		header d:hcs
		h1 fs:xl fw:700 m:0
		p m:0 c:$ui-muted fs:sm
		pre fs:xs c:$ui-muted m:0 ws:pre-wrap
		.out d:vflex g:2 mt:1
		button.theme, .set button bd:1px solid $ui-border bg:transparent c:inherit rd:md px:3 py:1.5 cursor:pointer
		.set d:hcl g:2 flw:wrap
		.set button fs:xs px:2 py:1
		input.text h:10 px:3 box-sizing:border-box min-width:0 bg:$ui-surface bd:1px solid $ui-border rd:$ui-radius fs:sm c:inherit ff:inherit
			@focus bc:$ui-ring outline:2px solid $ui-ring-soft
			&[aria-invalid] bc:$ui-danger

	<self>
		<header>
			<h1> "Imba UI"
			<button.theme @click=toggleTheme> dark ? "Light" : "Dark"

		<demo-section title="Date picker">
			<ui-fields>
				<ui-field span=6 label='Lesson date'>
					<ui-date-picker bind=lesson>
					<div.out>
						<pre> JSON.stringify(lesson)
						<div.set>
							<button @click=(lesson = '2026-12-25')> "Christmas"
							<button @click=(lesson = null)> "Clear"
				<ui-field span=6 label='Tutor away'>
					<ui-date-picker range min='2026-10-01' value=away @change=(away = e.detail)>
					<div.out>
						<pre> JSON.stringify(away)
						<div.set>
							<button @click=(away = ['2026-10-12', '2026-10-16'])> "Half term"
				<ui-field span=6 label='No weekends' hint='Saturdays and Sundays are unavailable'>
					<ui-date-picker unavailable=(do(d) d.toDate('UTC').getUTCDay! % 6 == 0)>

		<demo-section title="Select">
			<ui-fields>
				<ui-field span=6 label='Subject'>
					<ui-select items=subjects bind=subject>
					<div.out>
						<pre> JSON.stringify(subject)
						<div.set>
							<button @click=(subject = 2)> "English"
							<button @click=(subject = null)> "Clear"
				<ui-field span=6 label='Exam boards'>
					<ui-select items=boards multiple clearable bind:value=examBoards>
					<div.out>
						<pre> JSON.stringify(examBoards)
						<div.set>
							<button @click=(examBoards = ['AQA', 'OCR'])> "AQA + OCR"

		<demo-section title="Combobox">
			<ui-fields>
				<ui-field span=4 label='Subject'>
					<ui-combobox items=subjects placeholder='Search subjects' bind=searched>
					<div.out>
						<pre> JSON.stringify(searched)
						<div.set>
							<button @click=(searched = 3)> "Physics"
							<button @click=(searched = null)> "Clear"
				<ui-field span=4 label='Students'>
					<ui-combobox items=subjects multiple placeholder='Add…' bind=many>
					<div.out>
						<pre> JSON.stringify(many)
						<div.set>
							<button @click=(many = [1, 5])> "Maths + Biology"
				<ui-field span=4 label='Tutor (async)'>
					<ui-combobox load=findTutors labelKey='name' valueKey='id' placeholder='Type a name' @change=(tutor = e.detail)>
					<div.out>
						<pre> JSON.stringify(tutor)

		<demo-section title="Fields">
			<ui-fields>
				<ui-field span=6 label='First name' error=errors.first>
					<input.text bind=student.first>
				<ui-field span=6 label='Last name'>
					<input.text bind=student.last>
				<ui-field span=8 label='Email' hint="We'll send lesson reminders here" error=errors.email>
					<input.text type='email' bind=student.email>
				<ui-field span=4 label='Year group'>
					<ui-select items=years bind=student.year>
				<ui-field span=6 label='Subjects' error=errors.subjects>
					<ui-combobox items=subjects multiple placeholder='Add…' bind=student.subjects>
				<ui-field span=6 label='Start date' hint='Lessons start from this date'>
					<ui-date-picker bind=student.start>
			<div.out>
				<div.set>
					<button @click=validate> "Validate"
					<button @click=(errors = {})> "Clear errors"
				<pre> JSON.stringify(student)

imba.mount <playground>
