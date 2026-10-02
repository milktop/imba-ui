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
		button.theme bd:1px solid $ui-border bg:transparent c:inherit rd:md px:3 py:1.5 cursor:pointer

	<self>
		<header>
			<h1> "Imba UI"
			<button.theme @click=toggleTheme> dark ? "Light" : "Dark"

		<demo-section title="Date picker">
			<div.row>
				<div>
					<ui-date-picker label='Lesson date' value=lesson @change=(lesson = e.detail)>
					<pre> JSON.stringify(lesson)
				<div>
					<ui-date-picker label='Tutor away' range min='2026-10-01' @change=(away = e.detail)>
					<pre> JSON.stringify(away)
				<div>
					<ui-date-picker label='No weekends' unavailable=(do(d) d.toDate('UTC').getUTCDay! % 6 == 0)>

		<demo-section title="Select">
			<div.row>
				<div>
					<ui-select label='Subject' items=subjects value=subject @change=(subject = e.detail)>
					<pre> JSON.stringify(subject)
				<div>
					<ui-select label='Exam boards' items=boards multiple clearable @change=(examBoards = e.detail)>
					<pre> JSON.stringify(examBoards)

		<demo-section title="Combobox">
			<div.row>
				<div>
					<ui-combobox label='Subject' items=subjects placeholder='Search subjects' @change=(searched = e.detail)>
					<pre> JSON.stringify(searched)
				<div>
					<ui-combobox label='Students' items=subjects multiple placeholder='Add…' @change=(many = e.detail)>
					<pre> JSON.stringify(many)
				<div>
					<ui-combobox label='Tutor (async)' load=findTutors labelKey='name' valueKey='id' placeholder='Type a name' @change=(tutor = e.detail)>
					<pre> JSON.stringify(tutor)

imba.mount <playground>
