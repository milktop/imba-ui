import source from './breadcrumbs.imba?raw'

const lesson = [
	{ label: 'Home', href: '/', icon: 'lucide:house' }
	{ label: 'Students', href: '/breadcrumbs' }
	{ label: 'Ada Lovelace', href: '/breadcrumbs' }
	{ label: 'Lessons', href: '/breadcrumbs' }
	{ label: 'Term 1', href: '/breadcrumbs' }
	{ label: 'Fractions and decimals, week 4' }
]

tag page-breadcrumbs
	max = 4

	css
		.narrow w:100% max-width:72 p:3 bd:1px dashed $ui-border rd:$ui-radius box-sizing:border-box

	<self>
		<demo-page source=source heading='Breadcrumbs' intro='ui-breadcrumbs shows where the current page sits. The last item is the current page; items without a link show as plain text. The top bar of this playground uses one.'>
			<demo-section heading='From items'>
				<ui-breadcrumbs items=[
					{ label: 'Home', href: '/' }
					{ label: 'Students', href: '/breadcrumbs' }
					{ label: 'Ada Lovelace' }
				]>

			<demo-section heading='Icons and separators'>
				<ui-breadcrumbs items=lesson.slice(0, 3)>
				<ui-breadcrumbs separator='/' items=lesson.slice(0, 3)>
				<ui-breadcrumbs separator='·' items=lesson.slice(1, 4)>

			<demo-section heading='Folding long trails'>
				<p.note> "With `max`, the middle crumbs fold into a … button that lists them."
				<ui-breadcrumbs items=lesson max=max>
				<div.out>
					<json-print data={ max }>
					<div.set>
						<button @click=(max = 3)> "max = 3"
						<button @click=(max = 4)> "max = 4"
						<button @click=(max = null)> "No max"

			<demo-section heading='Narrow spaces'>
				<p.note> "Crumbs never wrap. When they don't fit, the middle ones fold into the … (as many as needed), then long labels are cut short, the current page's last."
				<div.narrow>
					<ui-breadcrumbs items=lesson.slice(1)>

			<demo-section heading='As markup'>
				<ui-breadcrumbs>
					<ui-breadcrumb href='/' icon='lucide:house'> "Home"
					<ui-breadcrumb href='/breadcrumbs'> "Settings"
					<ui-breadcrumb current> "Billing"

			<demo-section heading='In a page header'>
				<ui-card>
					<ui-page heading='Ada Lovelace' description='GCSE Maths, Thursdays at 16:00'>
						<ui-breadcrumbs slot='breadcrumbs' items=lesson.slice(0, 3)>
						<ui-button slot='actions' size='sm' variant='primary' icon='lucide:calendar-plus'> "Book lesson"
