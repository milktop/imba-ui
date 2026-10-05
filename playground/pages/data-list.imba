import source from './data-list.imba?raw'

const details = [
	{ label: 'Name', value: 'Ada Lovelace' }
	{ label: 'Email', value: 'ada@example.com' }
	{ label: 'Year', value: 11, info: 'School year from September' }
	{ label: 'Subject', value: 'GCSE Maths' }
]

tag page-data-list
	css
		.link c:$ui-accent td:underline text-underline-offset:2px

	<self>
		<demo-page source=source heading='Data list' intro='ui-data-list shows labels and their values as a description list. Give it `items`, or write ui-data-item markup: the same fields as attributes, with the value inside (so it can be any markup).'>
			<demo-section heading='Plain'>
				<ui-data-list items=details>

			<demo-section heading='As markup'>
				<ui-data-list>
					<ui-data-item label='Name'> "Ada Lovelace"
					<ui-data-item label='Email'>
						<a.link href='mailto:ada@example.com'> "ada@example.com"
					<ui-data-item label='Year' info='School year from September'> "11"

			<demo-section heading='Divided, with markup values'>
				<ui-data-list variant='divided'>
					<ui-data-item label='Student'>
						<div [d:flex ai:center g:2]>
							<ui-avatar size='sm' name='Ada Lovelace'>
							"Ada Lovelace"
					<ui-data-item label='Status'> <ui-badge variant='success'> "Active"
					<ui-data-item label='Next lesson'> "Thursday 8 October, 16:00"
					<ui-data-item label='Notes' info='Only tutors see these'> "Prefers worked examples; revise fractions before the mock exam."

			<demo-section heading='Card' bare>
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
