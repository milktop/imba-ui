import { upcoming, activity, revenue } from './data.imba'

# A dashboard: a greeting with actions, a row of stats, then upcoming lessons
# beside recent activity.
tag block-dashboard
	range = 7
	ranges = [{ value: 3, label: '3m' }, { value: 7, label: '7m' }]
	columns = [
		{ key: 'student', label: 'Student', tag: 'dashboard-student' }
		{ key: 'subject', label: 'Subject' }
		{ key: 'when', label: 'When' }
		{ key: 'length', label: 'Length', align: 'end' }
	]

	css
		d:flex fld:column g:6
		.head d:flex ai:flex-end jc:space-between g:4 flw:wrap
		h2 m:0 fs:xl fw:700
		.sub m:0 mt:1 c:$ui-muted fs:sm
		.actions d:flex g:2
		# Side by side when there's room, stacked when not.
		.columns d:flex flw:wrap g:6 ai:flex-start
		.lessons fl:2 1 28rem min-width:0
		.activity fl:1 1 16rem min-width:0
		.panel-head d:flex ai:center jc:space-between mb:3
		h3 m:0 fs:md fw:600

	<self>
		<div.head>
			<div>
				<h2> "Good morning, Grace"
				<p.sub> "You have 2 lessons today and 3 invoices to send."
			<div.actions>
				<ui-button icon='lucide:receipt'> "New invoice"
				<ui-button variant='primary' icon='lucide:calendar-plus'> "Book lesson"
		<ui-stats variant='cards'>
			<ui-stat icon='lucide:users' label='Active students' value=31 change=6.9 changeLabel='this month'>
			<ui-stat icon='lucide:calendar-check' label='Lessons' value=52 change=12.5 changeLabel='vs September'>
			<ui-stat icon='lucide:clock' label='Hours taught' value='48.5' unit='h' change=-2.1>
			<ui-stat icon='lucide:wallet' label='Outstanding' value='£320' change=15 invert>
		<ui-card heading='Revenue' description='Paid and outstanding, by month'>
			<ui-segmented slot='actions' items=ranges bind=range>
			<ui-area-chart data=revenue.slice(-range) x='month' series=[{ key: 'paid', label: 'Paid' }, { key: 'owed', label: 'Outstanding', color: 'var(--ui-chart-3)' }] format=(do(v) "£{v.toLocaleString!}") height=220 label='Revenue by month'>
		<div.columns>
			<section.lessons>
				<div.panel-head>
					<h3> "Upcoming lessons"
					<ui-button size='sm' variant='ghost' iconEnd='lucide:arrow-right'> "Calendar"
				<ui-table columns=columns rows=upcoming>
			<ui-card.activity heading='Recent activity'>
				<ui-timeline size='sm' items=activity>

# The student column: avatar and name.
tag dashboard-student
	prop row
	css d:flex ai:center g:2.5
	<self>
		<ui-avatar size='sm' name=row.student>
		row.student
