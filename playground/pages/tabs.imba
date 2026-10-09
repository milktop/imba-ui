import source from './tabs.imba?raw'

tag page-tabs
	tab = null
	view = 'week'
	inbox = 'inbox'
	inboxCount = 5
	range = 'day'

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

			<demo-section heading='Counts and dots' uses='inboxCount'>
				<ui-tabs bind=inbox>
					<ui-tab value='inbox' label='Inbox' count=inboxCount countColor='accent' countLabel='unread'> <p> "{inboxCount} unread messages."
					<ui-tab value='failed' label='Failed' count=3 countColor='danger' pulse countLabel='failed sends'> <p> "3 messages couldn't be sent."
					<ui-tab value='archive' label='Archive' count=240> <p> "Past 99 the count reads 99+."
					<ui-tab value='drafts' label='Drafts' dot countLabel='new drafts'> <p> "A dot when there's something to look at, but no number."
				<div.out>
					<json-print data={ inbox }>
					<div.set>
						<button @click=(inboxCount += 1)> "New message"
						<button @click=(inboxCount = 0)> "Mark all read"
					<p.note> "A count of 0 or null hides it."

			<demo-section heading='Counts in the corner'>
				<ui-tabs counts='corner' bind=range>
					<ui-tab value='day' label='Day' count=3> <p> "Today: 3 lessons."
					<ui-tab value='week' label='Week' count=14 countColor='accent'> <p> "This week: 14 lessons."
					<ui-tab value='month' label='Month' dot countColor='warning'> <p> "October: 52 lessons."
