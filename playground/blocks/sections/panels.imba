import { upcoming, students } from '../data.imba'

# A card with a header and actions, holding a table edge to edge.
tag panel-table
	columns = [
		{ key: 'student', label: 'Student' }
		{ key: 'subject', label: 'Subject' }
		{ key: 'when', label: 'When' }
		{ key: 'length', label: 'Length', align: 'end' }
	]
	<self>
		<ui-card flush heading='Upcoming lessons' description='The next 7 days'>
			<ui-button slot='actions' size='sm' icon='lucide:calendar'> "Calendar"
			<ui-table flush columns=columns rows=upcoming>

# A card with a short list and a footer link to the rest.
tag panel-list
	css
		.rows d:flex fld:column m:0 p:0 list-style:none
		li d:flex ai:center g:3 px:5 py:3 bdb:1px solid $ui-border
			@last-child bdb:none
		.name flg:1 fw:500
		.meta c:$ui-muted fs:xs
		.footer-link d:flex jc:center w:100%
	<self>
		<ui-card flush heading='New students'>
			<ul.rows> for student in students.slice(0, 4)
				<li>
					<ui-avatar size='sm' name=student.name>
					<span.name> student.name
					<span.meta> student.subject
			<div slot='footer'>
				<ui-button.footer-link size='sm' variant='ghost' iconEnd='lucide:arrow-right'> "All students"

# Two cards side by side: a figure with a breakdown, and a to-do list.
tag panel-pair
	css
		d:grid gtc:repeat(auto-fit, minmax(16rem, 1fr)) g:4
		.figure fs:3xl fw:700 lh:1.1
		.label c:$ui-muted fs:sm
		.bars d:flex fld:column g:3 mt:5
		.todo d:flex fld:column g:3
	<self>
		<ui-card heading='Revenue' description='October so far'>
			<div.figure> "£1,820"
			<div.bars>
				<ui-progress label='Maths' value=62 showValue>
				<ui-progress label='Physics' value=24 showValue>
				<ui-progress label='English' value=14 showValue>
		<ui-card heading='To do'>
			<div.todo>
				<ui-checkbox label='Send October invoices' checked>
				<ui-checkbox label='Mark Thursday’s homework'>
				<ui-checkbox label='Reply to Anne about half term'>
				<ui-checkbox label='Plan Year 11 mock revision'>

export const examples = [
	{ heading: 'Card with a table', tag: 'panel-table' }
	{ heading: 'Card with a list', tag: 'panel-list' }
	{ heading: 'Side by side', tag: 'panel-pair' }
]
