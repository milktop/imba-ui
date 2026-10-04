import source from './action-bar.imba?raw'
import { toaster } from '../../src/toast/index.imba'

tag page-action-bar
	picked = []
	lessons = [
		{ value: 1, label: 'Thu 8 Oct, Maths with Ada' }
		{ value: 2, label: 'Fri 9 Oct, English with Alan' }
		{ value: 3, label: 'Mon 12 Oct, Physics with Grace' }
		{ value: 4, label: 'Tue 13 Oct, Maths with Katherine' }
	]

	def act verb
		toaster.success(title: "{verb} {picked.length} lessons")
		picked = []

	<self>
		<demo-page source=source heading='Action bar' intro='ui-action-bar floats at the bottom of the screen while something is selected, with the count and a few actions. It isn’t modal, so you can keep selecting; Escape inside it or its close button closes it. The Table page uses one for ticked rows.'>
			<demo-section heading='With a selection'>
				<ui-checkbox-group label='Upcoming lessons' items=lessons selectAll='All lessons' bind=picked>
				<ui-action-bar open=(picked.length > 0) @close=(picked = [])>
					<span slot='selection'> "{picked.length} selected"
					<ui-button size='sm' icon='lucide:calendar-clock' @click=act('Rescheduled')> "Reschedule"
					<ui-button size='sm' variant='danger' icon='lucide:calendar-x' @click=act('Cancelled')> "Cancel"
				<div.out>
					<json-print data={ picked }>
