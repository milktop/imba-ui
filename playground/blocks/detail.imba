# A detail page: a header, then the main content (about two thirds) beside
# an aside of details and figures (one third), stacking on narrow screens.
tag block-detail
	objectives = ['Compare fractions with different denominators', 'Convert fractions to decimals', 'Order a mixed list of fractions and decimals']
	met = ['Compare fractions with different denominators']
	homework = [
		{ title: 'Worksheet 4: equivalent fractions', due: 'Due Thu 15 Oct', status: 'Set' }
		{ title: 'Times tables practice (7s and 8s)', due: 'Due Mon 12 Oct', status: 'Done' }
	]
	files = [
		{ name: 'Lesson slides.pdf', size: '2.4 MB', icon: 'lucide:file-text' }
		{ name: 'Worksheet 4.pdf', size: '480 KB', icon: 'lucide:file-text' }
		{ name: 'Whiteboard photo.jpg', size: '1.1 MB', icon: 'lucide:image' }
	]
	actions = [
		{ value: 'reschedule', label: 'Reschedule', icon: 'lucide:calendar-clock' }
		{ value: 'duplicate', label: 'Duplicate', icon: 'lucide:copy' }
		{ separator: true }
		{ value: 'cancel', label: 'Cancel lesson', icon: 'lucide:calendar-x', danger: true }
	]

	css
		d:flex fld:column g:6
		.top d:flex fld:column g:3
		.head d:flex ai:flex-end jc:space-between g:4 flw:wrap
		.title d:flex ai:center g:3 flw:wrap
		h2 m:0 fs:xl fw:700
		.meta d:flex g:4 flw:wrap mt:2 c:$ui-muted fs:sm
			span d:inline-flex ai:center g:1.5
		.actions d:flex g:2
		# Main and aside side by side when there's room.
		.layout d:flex flw:wrap g:6 ai:flex-start
		.main fl:2 1 28rem min-width:0 d:flex fld:column g:6
		.aside fl:1 1 16rem min-width:0 d:flex fld:column g:6
		.plan m:0 c:$ui-muted fs:sm lh:1.6
		.objectives mt:4
		.rows d:flex fld:column m:0 p:0 list-style:none
		.rows li d:flex ai:center g:3 px:5 py:3 bdb:1px solid $ui-border
			@last-child bdb:none
		.grow flg:1 min-width:0
		.name fw:500
		.sub c:$ui-muted fs:xs
		.file-icon d:grid place-items:center w:9 h:9 fls:0 rd:$ui-radius bg:$ui-hover c:$ui-muted fs:18px
		.student d:inline-flex ai:center g:2
		.amount d:flex ai:center jc:space-between
		.big fs:2xl fw:700
		.pay d:flex fld:column g:4
		.trend d:flex fld:column g:3

	<self>
		<div.top>
			<ui-breadcrumbs items=[{ label: 'Lessons', href: '#' }, { label: 'October', href: '#' }, { label: 'Fractions and decimals' }]>
			<div.head>
				<div>
					<div.title>
						<h2> "Fractions and decimals"
						<ui-badge variant='accent' dot> "Booked"
					<div.meta>
						<span>
							<iconify-icon icon='lucide:calendar'>
							"Thursday 8 October"
						<span>
							<iconify-icon icon='lucide:clock'>
							"16:00–17:00"
						<span>
							<iconify-icon icon='lucide:video'>
							"Online"
				<div.actions>
					<ui-button icon='lucide:pencil'> "Edit"
					<ui-button variant='primary' icon='lucide:video'> "Join"
					<ui-menu items=actions placement='bottom-end'>
						<ui-button slot='trigger' icon='lucide:ellipsis' aria-label='More actions'>
		<div.layout>
			<div.main>
				<ui-card heading='Lesson plan'>
					<p.plan> "Recap equivalent fractions, then move on to converting between fractions and decimals using place value. Finish with a short ordering activity."
					<ui-checkbox-group.objectives label='Objectives' items=objectives bind=met>
				<ui-card flush heading='Homework'>
					<ui-button slot='actions' size='sm' icon='lucide:plus'> "Set homework"
					<ul.rows> for item in homework
						<li>
							<iconify-icon.file-icon icon='lucide:book-open'>
							<div.grow>
								<div.name> item.title
								<div.sub> item.due
							<ui-badge variant=(item.status == 'Done' ? 'success' : 'neutral')> item.status
				<ui-card flush heading='Files' description='Shared with Ada and her parent'>
					<ui-button slot='actions' size='sm' icon='lucide:upload'> "Upload"
					<ul.rows> for file in files
						<li>
							<span.file-icon> <iconify-icon icon=file.icon>
							<div.grow>
								<div.name> file.name
								<div.sub> file.size
							<ui-button size='sm' variant='ghost' icon='lucide:download' aria-label="Download {file.name}">
				<ui-card heading='Activity'>
					<ui-timeline size='sm' items=[
						{ title: 'Grace added the lesson slides', time: '2h ago', color: 'accent' }
						{ title: 'Anne confirmed the time', time: 'Yesterday', color: 'success' }
						{ title: 'Lesson booked', time: '1 Oct' }
					]>
			<div.aside>
				<ui-card heading='Details'>
					<ui-data-list labelWidth='6rem'>
						<ui-data-item label='Student'>
							<span.student>
								<ui-avatar size='sm' name='Ada Lovelace'>
								"Ada Lovelace"
						<ui-data-item label='Tutor'> "Grace Hopper"
						<ui-data-item label='Subject'> "GCSE Maths"
						<ui-data-item label='Length'> "60 minutes"
						<ui-data-item label='Rate'> "£35 / hour"
				<ui-card heading='Payment'>
					<div.pay>
						<div.amount>
							<span.big> "£35"
							<ui-badge variant='warning' dot> "Unpaid"
						<ui-button block variant='primary' icon='lucide:send'> "Send invoice"
				<ui-card heading='Progress' description='Score in end-of-lesson quizzes'>
					<div.trend>
						<ui-stat label='Last 6 lessons' value='78' unit='%' change=9 changeUnit=' pts' changeLabel='since September'>
						<ui-sparkline data=[58, 62, 60, 69, 72, 78] variant='area' height=48 label='Quiz scores: 58, 62, 60, 69, 72, 78 per cent'>
