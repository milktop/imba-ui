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
		.group d:vflex ai:flex-start g:2
		.caption fs:xs c:$ui-muted
		.toolbar d:inline-flex g:0.5 p:1 bd:1px solid $ui-border rd:$ui-radius as:flex-start
		# Spaced out so each placement's tooltip has room.
		.placements d:hflex flw:wrap g:2 12
		.actions d:hflex jc:flex-end g:2 mt:4

	<self>
		<demo-page source=source heading='Overlays' intro='Tooltips and popovers float above the page, positioned by Zag.'>
			<demo-section heading='Tooltip'>
				<div.group>
					<span.caption> "Toolbar: same placement, slide along it"
					<div.toolbar>
						<ui-tooltip content='Bold'>
							<ui-button variant='ghost' icon='lucide:bold' aria-label='Bold'>
						<ui-tooltip content='Italic'>
							<ui-button variant='ghost' icon='lucide:italic' aria-label='Italic'>
						<ui-tooltip content='Underline'>
							<ui-button variant='ghost' icon='lucide:underline' aria-label='Underline'>
						<ui-tooltip content='Insert link'>
							<ui-button variant='ghost' icon='lucide:link' aria-label='Insert link'>
						<ui-tooltip content='Clear formatting'>
							<ui-button variant='ghost' icon='lucide:remove-formatting' aria-label='Clear formatting'>
				<div.group>
					<span.caption> "Placements"
					<div.placements>
						<ui-tooltip content='Top'>
							<ui-button> "Top"
						<ui-tooltip content='Right' placement='right'>
							<ui-button> "Right"
						<ui-tooltip content='Bottom' placement='bottom'>
							<ui-button> "Bottom"
						<ui-tooltip content='Left' placement='left'>
							<ui-button> "Left"
				<div.group>
					<span.caption> "Interactive: stays open over it, so its text can be selected"
					<ui-tooltip interactive placement='right'>
						<ui-button icon='lucide:key-round'> "Booking code"
						<div slot='content'>
							"Code "
							<strong> "TUT-4821-XQ"
							" (select to copy)"
				<div.group>
					<span.caption> "Rich content and a delay"
					<ui-tooltip placement='top-start' openDelay=300>
						<ui-button> "Rich content"
						<div slot='content'>
							<strong> "Keyboard"
							<div> "Tab here to open it without hovering"
				<div.out>
					<p.note> "Hover or Tab to the buttons; Escape closes."

			<demo-section heading='Popover'>
				<div.row>
					<ui-popover heading='Maths with Ada' description='Thursday 8 October, 16:00 to 17:00' arrow @openchange=(opens++ if e.detail)>
						<ui-button slot='trigger'> "Lesson info"
						<div> "Room 4, bring the past paper from last week."
					<ui-popover heading='Change subject' closable bind=editing @openchange=(startEdit! if e.detail)>
						<ui-button slot='trigger'> "Edit subject"
						<ui-field label='Subject'>
							<ui-select items=subjects bind=draft>
						<div.actions>
							<ui-button @click=(editing = no)> "Cancel"
							<ui-button variant='primary' @click=save> "Save"
				<div.out>
					<json-print data={ editing, subject: subjectName, infoOpened: opens }>
					<div.set>
						<button @click=(editing = !editing)> "Toggle edit from outside"
