import source from './tabs.imba?raw'

tag page-tabs
	tab = null
	view = 'week'

	<self>
		<demo-page source=source heading='Tabs' intro='ui-tabs takes <ui-tab> panels and builds the tab list from their labels. Arrow keys move between tabs.'>
			<demo-section heading='Line'>
				<ui-tabs bind=tab>
					<ui-tab value='lessons' label='Lessons' icon='lucide:calendar'>
						<p> "Upcoming lessons: Maths with Ada on Thursday, Physics with Alan on Friday."
					<ui-tab value='students' label='Students' icon='lucide:users'>
						<p> "12 active students, 3 waiting for a first lesson."
					<ui-tab value='invoices' label='Invoices' icon='lucide:receipt'>
						<p> "2 invoices are due this week."
					<ui-tab value='reports' label='Reports' disabled>
						<p> "Coming soon."
				<div.out>
					<json-print data={ tab }>
					<div.set>
						<button @click=(tab = 'invoices')> "Invoices"
					<p.note> "With no value the first enabled tab is selected."

			<demo-section heading='Pills'>
				<ui-tabs variant='pills' bind=view>
					<ui-tab value='day' label='Day'> <p> "Today: 3 lessons."
					<ui-tab value='week' label='Week'> <p> "This week: 14 lessons."
					<ui-tab value='month' label='Month'> <p> "October: 52 lessons."
				<div.out>
					<json-print data={ view }>
