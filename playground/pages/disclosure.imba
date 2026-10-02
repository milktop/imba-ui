import source from './disclosure.imba?raw'

tag page-disclosure
	tab = null
	view = 'week'
	faq = 'pricing'
	open = ['notes']

	<self>
		<demo-page source=source heading='Disclosure' intro='Tabs and accordions show one part of a page at a time.'>
			<demo-section heading='Tabs'>
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

			<demo-section heading='Pill tabs'>
				<ui-tabs variant='pills' bind=view>
					<ui-tab value='day' label='Day'> <p> "Today: 3 lessons."
					<ui-tab value='week' label='Week'> <p> "This week: 14 lessons."
					<ui-tab value='month' label='Month'> <p> "October: 52 lessons."
				<div.out>
					<json-print data={ view }>

			<demo-section heading='Accordion'>
				<ui-accordion bind=faq>
					<ui-accordion-item value='pricing' heading='How much are lessons?'>
						"Lessons are £40 an hour, or £35 when you book a block of ten."
					<ui-accordion-item value='cancel' heading='Can I cancel a lesson?'>
						"Yes, free of charge up to 24 hours before it starts."
					<ui-accordion-item value='online' heading='Do you teach online?'>
						"Most tutors teach both online and in person; check their profile."
					<ui-accordion-item value='exams' heading='Exam preparation' disabled>
						"Available from January."
				<div.out>
					<json-print data={ faq }>

			<demo-section heading='Accordion, several open'>
				<ui-accordion multiple bind=open>
					<ui-accordion-item value='notes' heading='Lesson notes'>
						"Covered fractions and decimals; homework is worksheet 4."
					<ui-accordion-item value='goals' heading='Goals'>
						"Grade 7 in the summer exam."
					<ui-accordion-item value='contact' heading='Parent contact'>
						"Grace Hopper, grace@example.com"
				<div.out>
					<json-print data={ open }>
					<div.set>
						<button @click=(open = ['notes', 'goals', 'contact'])> "Open all"
						<button @click=(open = [])> "Close all"
