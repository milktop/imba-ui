import source from './tabs.imba?raw'

tag page-tabs
	tab = null
	view = 'week'
	inbox = 'inbox'
	inboxCount = 5
	range = 'day'
	record = 'invoices'

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

			<demo-section heading='Icons only'>
				<ui-tabs iconOnly bind=record>
					<ui-tab value='invoices' label='Invoices' icon='lucide:receipt-text' count=2 countColor='danger' countLabel='overdue'> <p> "2 invoices are overdue."
					<ui-tab value='payments' label='Payments' icon='lucide:banknote'> <p> "Last payment: £120 on 2 October."
					<ui-tab value='lessons' label='Lessons' icon='lucide:calendar'> <p> "Next lesson on Thursday."
					<ui-tab value='notes' label='Notes' icon='lucide:notebook-pen'> <p> "No notes yet."
					<ui-tab value='contact' label='Contact' icon='lucide:contact'> <p> "ada@example.com"
				<div.out>
					<json-print data={ record }>
					<p.note> "`iconOnly`: each label moves to a tooltip and stays readable by screen readers. Tabs without an icon keep their label."

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
