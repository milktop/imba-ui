import source from './timeline.imba?raw'

const history = [
	{ title: 'Lesson booked', time: '2 Oct', icon: 'lucide:calendar-plus', color: 'accent', description: 'Thursday 8 October, 16:00' }
	{ title: 'Invoice paid', time: '1 Oct', icon: 'lucide:receipt', color: 'success', description: '£120 for September' }
	{ title: 'Lesson cancelled', time: '24 Sep', icon: 'lucide:calendar-x', color: 'danger', description: 'Ill; rescheduled for next week' }
	{ title: 'Joined', time: '1 Sep', icon: 'lucide:user-plus' }
]

tag page-timeline
	<self>
		<demo-page source=source heading='Timeline' intro='ui-timeline lists events down a line, each with a marker (an icon or a dot), a title, a time and a description. Give it `items`, or write ui-timeline-item markup: the same fields as attributes, plus anything inside an item.'>
			<demo-section heading='With icons'>
				<ui-timeline items=history>

			<demo-section heading='As markup'>
				<ui-timeline>
					<ui-timeline-item title='Lesson booked' time='2 Oct' icon='lucide:calendar-plus' color='accent' description='Thursday 8 October, 16:00'>
					<ui-timeline-item title='Invoice paid' time='1 Oct' icon='lucide:receipt' color='success' description='£120 for September'>
					<ui-timeline-item title='Joined' time='1 Sep' icon='lucide:user-plus'>

			<demo-section heading='Dots'>
				<ui-timeline size='sm' items=history.map(do({ icon, ...rest }) rest)>

			<demo-section heading='Cards, with markup'>
				<ui-timeline variant='cards'>
					<ui-timeline-item title='Note added' time='30 Sep' icon='lucide:notebook-pen'>
						<p [m:0 c:$ui-muted]> "Confident with fractions now; start on percentages next week."
					<ui-timeline-item title='Homework set' time='24 Sep' icon='lucide:book-open' color='accent'>
						<div [d:flex g:2 flw:wrap]>
							<ui-badge> "Worksheet 4"
							<ui-badge> "Due 1 Oct"
					<ui-timeline-item title='First lesson' time='10 Sep' icon='lucide:sparkles' color='success' description='Assessment and goals for the year'>
