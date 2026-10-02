import { subjects } from '../demo.imba'
import source from './overlays.imba?raw'

tag page-overlays
	editing = no
	subject = 3
	draft = 3
	opens = 0

	def startEdit
		draft = subject

	def save
		subject = draft
		editing = no

	get subjectName do subjects.find(do $1.value == subject)..label

	css
		.row d:hflex flw:wrap g:2 ai:center
		.actions d:hflex jc:flex-end g:2 mt:4

	<self>
		<demo-page source=source heading='Overlays' intro='Tooltips and popovers float above the page, positioned by Zag.'>
			<demo-section heading='Tooltip'>
				<div.row>
					<ui-tooltip content='Edit lesson'>
						<button.btn.icon aria-label='Edit lesson'> <iconify-icon icon='lucide:pencil'>
					<ui-tooltip content='Duplicate' placement='right'>
						<button.btn.icon aria-label='Duplicate'> <iconify-icon icon='lucide:copy'>
					<ui-tooltip content='Archive' placement='bottom'>
						<button.btn.icon aria-label='Archive'> <iconify-icon icon='lucide:archive'>
					<ui-tooltip content='Delete' placement='left'>
						<button.btn.icon aria-label='Delete'> <iconify-icon icon='lucide:trash-2'>
					<ui-tooltip placement='top-start' openDelay=100>
						<button.btn> "Rich content"
						<div slot='content'>
							<strong> "Keyboard"
							<div> "Tab here to open it without hovering"
				<div.out>
					<p.note> "Hover or Tab to the buttons; Escape closes."

			<demo-section heading='Popover'>
				<div.row>
					<ui-popover heading='Maths with Ada' description='Thursday 8 October, 16:00 to 17:00' arrow @openchange=(opens++ if e.detail)>
						<button.btn slot='trigger'> "Lesson info"
						<div> "Room 4, bring the past paper from last week."
					<ui-popover heading='Change subject' closable bind=editing @openchange=(startEdit! if e.detail)>
						<button.btn slot='trigger'> "Edit subject"
						<ui-field label='Subject'>
							<ui-select items=subjects bind=draft>
						<div.actions>
							<button.btn @click=(editing = no)> "Cancel"
							<button.btn.primary @click=save> "Save"
				<div.out>
					<json-print data={ editing, subject: subjectName, infoOpened: opens }>
					<div.set>
						<button @click=(editing = !editing)> "Toggle edit from outside"
