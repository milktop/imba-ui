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

	# Fake server search with latency.
	def findTutors query
		const all = ['Ada Lovelace', 'Alan Turing', 'Grace Hopper', 'Katherine Johnson', 'Marie Curie', 'Rosalind Franklin'].map(do(name, i) { id: i + 1, name })
		await new Promise(do setTimeout($1, 400))
		all.filter(do $1.name.toLowerCase!.includes(query.toLowerCase!))

	def toggleTheme
		dark = !dark
		document.documentElement.classList.toggle('dark', dark)

	css
		d:block max-width:720px mx:auto p:8
		header d:hcs
		h1 fs:xl fw:700 m:0
		p m:0 c:$ui-muted fs:sm
		.row d:hcl g:8 flw:wrap ai:flex-start
		pre fs:xs c:$ui-muted m:0 mt:2
		button.theme, .set button bd:1px solid $ui-border bg:transparent c:inherit rd:md px:3 py:1.5 cursor:pointer
		.set d:hcl g:2 mt:2
		.set button fs:xs px:2 py:1

	<self>
		<header>
			<h1> "Imba UI"
			<button.theme @click=toggleTheme> dark ? "Light" : "Dark"

		<demo-section title="Date picker">
			<div.row>
				<div>
					<ui-date-picker label='Lesson date' bind=lesson>
					<pre> JSON.stringify(lesson)
					<div.set>
						<button @click=(lesson = '2026-12-25')> "Christmas"
						<button @click=(lesson = null)> "Clear"
				<div>
					<ui-date-picker label='Tutor away' range min='2026-10-01' value=away @change=(away = e.detail)>
					<pre> JSON.stringify(away)
					<div.set>
						<button @click=(away = ['2026-10-12', '2026-10-16'])> "Half term"
				<div>
					<ui-date-picker label='No weekends' unavailable=(do(d) d.toDate('UTC').getUTCDay! % 6 == 0)>

		<demo-section title="Select">
			<div.row>
				<div>
					<ui-select label='Subject' items=subjects bind=subject>
					<pre> JSON.stringify(subject)
					<div.set>
						<button @click=(subject = 2)> "English"
						<button @click=(subject = null)> "Clear"
				<div>
					<ui-select label='Exam boards' items=boards multiple clearable bind:value=examBoards>
					<pre> JSON.stringify(examBoards)
					<div.set>
						<button @click=(examBoards = ['AQA', 'OCR'])> "AQA + OCR"

		<demo-section title="Combobox">
			<div.row>
				<div>
					<ui-combobox label='Subject' items=subjects placeholder='Search subjects' bind=searched>
					<pre> JSON.stringify(searched)
					<div.set>
						<button @click=(searched = 3)> "Physics"
						<button @click=(searched = null)> "Clear"
				<div>
					<ui-combobox label='Students' items=subjects multiple placeholder='Add…' bind=many>
					<pre> JSON.stringify(many)
					<div.set>
						<button @click=(many = [1, 5])> "Maths + Biology"
				<div>
					<ui-combobox label='Tutor (async)' load=findTutors labelKey='name' valueKey='id' placeholder='Type a name' @change=(tutor = e.detail)>
					<pre> JSON.stringify(tutor)

imba.mount <playground>
