# A profile page: a header with the person and actions, then tabs for an
# overview, their lessons and notes.
tag block-profile
	tab = 'overview'
	lessons = [
		{ id: 1, date: 'Thu 8 Oct', topic: 'Fractions and decimals', status: 'Booked' }
		{ id: 2, date: 'Thu 1 Oct', topic: 'Ratio and proportion', status: 'Done' }
		{ id: 3, date: 'Thu 24 Sep', topic: 'Percentages', status: 'Cancelled' }
		{ id: 4, date: 'Thu 17 Sep', topic: 'Negative numbers', status: 'Done' }
	]
	lessonColumns = [
		{ key: 'date', label: 'Date' }
		{ key: 'topic', label: 'Topic' }
		{ key: 'status', label: 'Status', tag: 'profile-status', align: 'end' }
	]
	actions = [
		{ value: 'edit', label: 'Edit details', icon: 'lucide:pencil' }
		{ value: 'invoice', label: 'Send invoice', icon: 'lucide:receipt' }
		{ separator: true }
		{ value: 'archive', label: 'Archive student', icon: 'lucide:archive', danger: true }
	]

	css
		d:flex fld:column g:6
		.top d:flex fld:column g:4
		.head d:flex ai:center jc:space-between g:4 flw:wrap
		.person d:flex ai:center g:4
		h2 m:0 fs:xl fw:700
		.meta d:flex ai:center g:2 mt:1.5 flw:wrap c:$ui-muted fs:sm
		.actions d:flex g:2
		.overview d:flex flw:wrap g:6 ai:flex-start pt:5
		.details fl:3 1 22rem min-width:0
		.numbers fl:2 1 16rem min-width:0
		.panel pt:5

	<self>
		# Breadcrumbs above the header: a detail page's way back.
		<div.top>
			<ui-breadcrumbs items=[{ label: 'Students', href: '#' }, { label: 'Ada Lovelace' }]>
			<div.head>
				<div.person>
					<ui-avatar size='lg' name='Ada Lovelace'>
					<div>
						<h2> "Ada Lovelace"
						<div.meta>
							<ui-badge variant='success' dot> "Active"
							<span> "Year 11 · GCSE Maths"
				<div.actions>
					<ui-button icon='lucide:message-square'> "Message"
					<ui-button variant='primary' icon='lucide:calendar-plus'> "Book lesson"
					<ui-menu items=actions placement='bottom-end'>
						<ui-button slot='trigger' icon='lucide:ellipsis' aria-label='More actions'>
		<ui-tabs bind=tab>
			<ui-tab value='overview' label='Overview'>
				<div.overview>
					<ui-data-list.details variant='card' labelWidth='6rem' items=[
						{ label: 'Email', value: 'ada.lovelace@example.com' }
						{ label: 'Parent', value: 'Anne Byron, 07700 900123' }
						{ label: 'School', value: 'St Mary’s High' }
						{ label: 'Rate', value: '£35 / hour' }
						{ label: 'Since', value: 'September 2025' }
					]>
					<ui-card.numbers>
						<ui-stats columns=2>
							<ui-stat label='Lessons' value=24>
							<ui-stat label='Attendance' value='92' unit='%'>
							<ui-stat label='Paid' value='£840'>
							<ui-stat label='Owed' value='£35' help='Invoice due 15 Oct'>
			<ui-tab value='lessons' label='Lessons'>
				<div.panel>
					<ui-table columns=lessonColumns rows=lessons>
			<ui-tab value='notes' label='Notes'>
				<div.panel>
					<ui-timeline variant='cards'>
						<ui-timeline-item title='Confident with fractions' time='1 Oct' icon='lucide:notebook-pen' description='Start on percentages next week.'>
						<ui-timeline-item title='Homework set' time='24 Sep' icon='lucide:book-open' color='accent' description='Worksheet 4, due 1 October.'>
						<ui-timeline-item title='First lesson' time='10 Sep' icon='lucide:sparkles' color='success' description='Assessment and goals for the year.'>

tag profile-status
	prop value
	<self> <ui-badge variant=({ Booked: 'accent', Done: 'success', Cancelled: 'danger' }[value])> value
