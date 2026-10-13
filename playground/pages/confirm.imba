import source from './confirm.imba?raw'
import { confirm } from '../../src/confirm/index.imba'
import { toaster } from '../../src/toast/index.imba'

tag page-confirm
	archive = do
		if await confirm(heading: 'Archive Ada Lovelace?', description: 'She leaves your student list; her lessons stay.', confirmLabel: 'Archive')
			toaster.success(title: 'Archived')

	deleteStudent = do
		let ok = await confirm
			heading: 'Delete Ada Lovelace?'
			description: 'Her lessons and invoices go too. This can’t be undone.'
			danger: yes
			confirmLabel: 'Delete'
			typeToConfirm: 'Ada Lovelace'
			onConfirm: do new Promise(do(resolve) setTimeout(resolve, 1200))
		toaster.info(title: ok ? 'Deleted' : 'Kept')

	failing = do
		await confirm
			heading: 'Send the invoice?'
			confirmLabel: 'Send'
			onConfirm: do
				await new Promise(do(resolve) setTimeout(resolve, 800))
				throw new Error('The mail server didn’t answer. Try again in a minute.')

	acknowledge = do
		await confirm(heading: 'Lesson moved', description: 'Ada’s lesson is now on Thursday at 4pm.', confirmLabel: 'OK', cancelLabel: null)

	<self>
		<demo-page source=source heading='Confirm' intro="confirm() asks before doing something, from anywhere: a dialog you await for a yes or no, with no state to keep and nothing in the layout.">
			<demo-section heading='Ask, then act' uses='archive'>
				<ui-button @click=archive> "Archive student"

			<demo-section heading='Danger, typed, with work to do' uses='deleteStudent'>
				<ui-button variant='danger' @click=deleteStudent> "Delete student"

			<demo-section heading='When the work fails' uses='failing'>
				<ui-button @click=failing> "Send invoice"
				<div.out>
					<p.note> "onConfirm throws: the dialog stays open and shows the error."

			<demo-section heading='An acknowledgement' uses='acknowledge'>
				<ui-button @click=acknowledge> "Move lesson"
