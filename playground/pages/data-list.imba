import source from './data-list.imba?raw'

const details = [
	{ label: 'Name', value: 'Ada Lovelace' }
	{ label: 'Email', value: 'ada@example.com' }
	{ label: 'Year', value: 11, info: 'School year from September' }
	{ label: 'Subject', value: 'GCSE Maths' }
]

tag page-data-list
	<self>
		<demo-page source=source heading='Data list' intro='ui-data-list shows labels and their values as a description list. Give it `items`, or write ui-data-item markup when a value needs more than text.'>
			<demo-section heading='Plain'>
				<ui-data-list items=details>

			<demo-section heading='Divided, with markup values'>
				<ui-data-list variant='divided'>
					<ui-data-item label='Student'>
						<div [d:flex ai:center g:2]>
							<ui-avatar size='sm' name='Ada Lovelace'>
							"Ada Lovelace"
					<ui-data-item label='Status'> <ui-badge variant='success'> "Active"
					<ui-data-item label='Next lesson'> "Thursday 8 October, 16:00"
					<ui-data-item label='Notes' info='Only tutors see these'> "Prefers worked examples; revise fractions before the mock exam."

			<demo-section heading='Card'>
				<ui-data-list variant='card' items=details labelWidth='8rem'>

			<demo-section heading='Stacked, in a grid'>
				<ui-data-list orientation='vertical' columns=3 items=[
					{ label: 'Lessons', value: '24' }
					{ label: 'Attendance', value: '92%' }
					{ label: 'Since', value: 'September 2025' }
					{ label: 'Tutor', value: 'Grace Hopper' }
					{ label: 'Rate', value: '£35 / hour' }
					{ label: 'Payment', value: 'Monthly, by card' }
				]>

			<demo-section heading='Stacked and divided'>
				<ui-data-list orientation='vertical' variant='divided' items=details.slice(0, 3)>
