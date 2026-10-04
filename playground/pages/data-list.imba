import source from './data-list.imba?raw'

const details = [
	{ label: 'Name', value: 'Ada Lovelace' }
	{ label: 'Email', value: 'ada@example.com' }
	{ label: 'Year', value: 11, info: 'School year from September' }
	{ label: 'Subject', value: 'GCSE Maths' }
]

const dataCode = '''
# Each item is a plain object: a label and a value (shown as text).
const details = [
	{ label: 'Name', value: 'Ada Lovelace' }
	{ label: 'Email', value: 'ada@example.com' }
	{ label: 'Year', value: 11, info: 'School year from September' }
	{ label: 'Subject', value: 'GCSE Maths' }
]

<ui-data-list items=details>
'''

const fields = [
	['label', 'The term', "'Email'"]
	['value', 'Its value, shown as text', "'ada@example.com'"]
	['info', 'Adds an icon with this text in a tooltip', "'School year from September'"]
]

const listOptions = [
	['orientation', "'horizontal' (labels beside values) or 'vertical' (above)", "'vertical'"]
	['variant', "'plain', 'divided' or 'card'", "'card'"]
	['columns', 'A grid of this many columns (one on phones)', '3']
	['labelWidth', 'The label column, when horizontal', "'8rem'"]
]

tag page-data-list
	css
		.code m:0 p:4 w:100% box-sizing:border-box bg:$ui-hover rd:$ui-radius ff:mono fs:xs lh:1.6 tab-size:2 ofx:auto
		code ff:mono fs:xs
		.link c:$ui-accent td:underline text-underline-offset:2px

	<self>
		<demo-page source=source heading='Data list' intro='ui-data-list shows labels and their values as a description list. Give it `items`, or write ui-data-item markup: the same fields as attributes, with the value inside (so it can be any markup).'>
			<demo-section heading='Plain'>
				<ui-data-list items=details>

			<demo-section heading='The data'>
				<p.note> "Items are plain objects. ui-data-item takes the same fields as attributes, with its value inside, so it can hold markup (badges, avatars, links)."
				<pre.code> dataCode

			<demo-section heading='Item fields and list options'>
				<ui-table>
					<table>
						<thead>
							<tr>
								<th> "Item field"
								<th> "What it does"
								<th> "Example"
						<tbody> for field in fields
							<tr>
								<td> <code> field[0]
								<td> field[1]
								<td> <code> field[2]
				<ui-table>
					<table>
						<thead>
							<tr>
								<th> "List option"
								<th> "What it does"
								<th> "Example"
						<tbody> for option in listOptions
							<tr>
								<td> <code> option[0]
								<td> option[1]
								<td> <code> option[2]

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
