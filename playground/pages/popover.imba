import { subjects } from '../demo.imba'
import source from './popover.imba?raw'

tag page-popover
	editing = no
	subject = 3
	draft = 3
	opens = 0

	def startEdit do draft = subject
	def save
		subject = draft
		editing = no

	get subjectName do subjects.find(do $1.value == subject)..label

	css
		.actions d:hflex jc:flex-end g:2 mt:4

	<self>
		<demo-page source=source heading='Popover' intro='ui-popover opens a floating panel from a trigger. Focus moves in and back; Escape and clicks outside close it.'>
			<demo-section heading='Information'>
				<ui-popover heading='Maths with Ada' description='Thursday 8 October, 16:00 to 17:00' arrow @openchange=(opens++ if e.detail)>
					<ui-button slot='trigger' icon='lucide:info'> "Lesson info"
					<div> "Room 4, bring the past paper from last week."
				<div.out>
					<json-print data={ opened: opens }>

			<demo-section heading='With a form'>
				<ui-popover heading='Change subject' closable bind=editing @openchange=(startEdit! if e.detail)>
					<ui-button slot='trigger' icon='lucide:pencil'> "Edit subject"
					<ui-field label='Subject'>
						<ui-select items=subjects bind=draft>
					<div.actions>
						<ui-button @click=(editing = no)> "Cancel"
						<ui-button variant='primary' @click=save> "Save"
				<div.out>
					<json-print data={ editing, subject: subjectName }>
					<div.set>
						<button @click=(editing = !editing)> "Toggle from outside"
					<p.note> "Binding `open` lets Save close it."
