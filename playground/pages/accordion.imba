import source from './accordion.imba?raw'

tag page-accordion
	faq = 'pricing'
	open = ['notes']

	<self>
		<demo-page source=source heading='Accordion' intro='ui-accordion takes <ui-accordion-item>s with headings that expand their content.'>
			<demo-section heading='One at a time'>
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
					<p.note> "Click the open item to close it again; the last item is disabled."

			<demo-section heading='Several open'>
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
