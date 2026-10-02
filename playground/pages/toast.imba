import { toaster } from '../../src/toast/index.imba'
import source from './toast.imba?raw'

tag page-toast
	def removed
		toaster.create
			title: 'Lesson removed'
			description: 'It’s gone from the calendar.'
			action: { label: 'Undo', onClick: do toaster.info(title: 'Lesson restored') }

	def upload
		let id = toaster.loading(title: 'Uploading worksheet…')
		setTimeout(&, 1500) do toaster.update(id, type: 'success', title: 'Worksheet uploaded', description: 'fractions.pdf, 240 KB')

	<self>
		<demo-page source=source heading='Toast' intro='Call toaster.success(…), .error, .warning, .info or .loading from anywhere; one <ui-toaster> in the layout shows them. Hover pauses them, Escape dismisses the focused one, Alt+T jumps to them.'>
			<demo-section heading='Types'>
				<div.row>
					<ui-button icon='lucide:check' @click=(toaster.success(title: 'Lesson booked', description: 'Maths with Ada, Thursday at 16:00'))> "Success"
					<ui-button icon='lucide:circle-x' @click=(toaster.error(title: 'Could not save', description: 'Check your connection and try again.'))> "Error"
					<ui-button icon='lucide:triangle-alert' @click=(toaster.warning(title: 'Lesson overlaps', description: 'Ada has another lesson at 16:30.'))> "Warning"
					<ui-button icon='lucide:info' @click=(toaster.info(title: 'New message', description: 'Grace replied about Thursday.'))> "Info"

			<demo-section heading='With an action'>
				<ui-button icon='lucide:undo-2' @click=removed> "Remove lesson"
				<div.out>
					<p.note> "The action button runs its handler and dismisses the toast."

			<demo-section heading='Loading, then updated'>
				<ui-button icon='lucide:upload' @click=upload> "Upload worksheet"
				<div.out>
					<p.note> "toaster.loading returns an id; toaster.update(id, …) turns it into a success."
