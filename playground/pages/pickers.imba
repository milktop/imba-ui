import { subjects } from '../demo.imba'
import source from './pickers.imba?raw'

tag page-pickers
	lesson = '2026-10-02'
	away = []
	subject = 1
	examBoards = []
	searched = null
	many = []
	tutor = null
	boards = ['AQA', 'Edexcel', 'OCR', 'WJEC']

	# Fake server search with latency.
	def findTutors query
		const all = ['Ada Lovelace', 'Alan Turing', 'Grace Hopper', 'Katherine Johnson', 'Marie Curie', 'Rosalind Franklin'].map(do(name, i) { id: i + 1, name })
		await new Promise(do setTimeout($1, 400))
		all.filter(do $1.name.toLowerCase!.includes(query.toLowerCase!))

	<self>
		<demo-page source=source heading='Pickers' intro='Choosing dates and items from a list, with popups positioned by Zag.'>
			<demo-section heading='Date picker'>
				<ui-fields>
					<ui-field span=6 label='Lesson date'>
						<ui-date-picker bind=lesson>
						<div.out>
							<json-print data=lesson>
							<div.set>
								<button @click=(lesson = '2026-12-25')> "Christmas"
								<button @click=(lesson = null)> "Clear"
					<ui-field span=6 label='Tutor away'>
						<ui-date-picker range min='2026-10-01' value=away @change=(away = e.detail)>
						<div.out>
							<json-print data=away>
							<div.set>
								<button @click=(away = ['2026-10-12', '2026-10-16'])> "Half term"
					<ui-field span=6 label='No weekends' hint='Weekends are unavailable; ↑/↓ step a day, ⇧ a week'>
						<ui-date-picker unavailable=(do(d) d.toDate('UTC').getUTCDay! % 6 == 0)>

			<demo-section heading='Select'>
				<ui-fields>
					<ui-field span=6 label='Subject'>
						<ui-select items=subjects bind=subject>
						<div.out>
							<json-print data=subject>
							<div.set>
								<button @click=(subject = 2)> "English"
								<button @click=(subject = null)> "Clear"
					<ui-field span=6 label='Exam boards'>
						<ui-select items=boards multiple clearable bind:value=examBoards>
						<div.out>
							<json-print data=examBoards>
							<div.set>
								<button @click=(examBoards = ['AQA', 'OCR'])> "AQA + OCR"

			<demo-section heading='Combobox'>
				<ui-fields>
					<ui-field span=4 label='Subject'>
						<ui-combobox items=subjects placeholder='Search subjects' bind=searched>
						<div.out>
							<json-print data=searched>
							<div.set>
								<button @click=(searched = 3)> "Physics"
								<button @click=(searched = null)> "Clear"
					<ui-field span=4 label='Students'>
						<ui-combobox items=subjects multiple placeholder='Add…' bind=many>
						<div.out>
							<json-print data=many>
							<div.set>
								<button @click=(many = [1, 5])> "Maths + Biology"
					<ui-field span=4 label='Tutor (async)'>
						<ui-combobox load=findTutors labelKey='name' valueKey='id' placeholder='Type a name' @change=(tutor = e.detail)>
						<div.out>
							<json-print data=tutor>
