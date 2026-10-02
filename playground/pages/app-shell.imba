import source from './app-shell.imba?raw'

const shellCode = '''
<ui-app-shell persist='sidebar'>
	<ui-sidebar>
		<a slot='logo' href='/'> "Tutor"
		<ui-nav-section heading='Menu'>
			<ui-nav-item icon='lucide:house' href='/' active=isHome> "Dashboard"
			<ui-nav-item icon='lucide:users' href='/students' badge=3> "Students"
			<ui-nav-group icon='lucide:settings' label='Settings'>
				<ui-nav-item href='/settings/billing'> "Billing"
		<div slot='footer'> …
	<ui-topbar>
		"Search…"
		<div slot='end'> <ui-avatar name='Ada Lovelace'>
	<ui-page heading='Students'> …
'''

const itemsCode = '''
const nav = [
	{ heading: 'Menu', items: [
		{ label: 'Dashboard', icon: 'lucide:house', href: '/', active: yes }
		{ label: 'Settings', icon: 'lucide:settings', items: [
			{ label: 'Billing', href: '/settings/billing' }
		] }
	] }
]

<ui-sidebar items=nav>
'''

tag page-app-shell
	get shell do document.querySelector('ui-app-shell')

	css
		pre m:0 p:4 bg:$ui-hover rd:$ui-radius ff:mono fs:xs lh:1.6 tab-size:2 ofx:auto as:stretch
		.frame as:stretch bd:1px dashed $ui-border rd:$ui-radius

	<self>
		<demo-page source=source heading='App shell' intro='ui-app-shell lays out a sidebar, a top bar and the page. This playground is built with it: collapse the sidebar to an icon rail with its button or ⌘B, or narrow the window to get a drawer.'>
			<demo-section heading='This playground'>
				<pre> shellCode
				<div.out>
					<json-print data={ collapsed: !!shell..collapsed, rail: !!shell..rail, mobile: !!shell..mobile }>
					<div.set>
						<button @click=shell.toggle!> "Toggle the sidebar"

			<demo-section heading='Nav from data'>
				<p.note> "Instead of markup, give the sidebar `items`: sections of links, where an item with `items` becomes a group."
				<pre> itemsCode

			<demo-section heading='Page header'>
				<div.frame>
					<ui-page heading='Students' description='12 active, 3 awaiting a first lesson'>
						<div slot='breadcrumbs'> "Home / Students"
						<div slot='actions'>
							<ui-button size='sm'> "Export"
							<ui-button size='sm' variant='primary' icon='lucide:plus'> "Add student"
						<p [m:0 c:$ui-muted fs:sm]> "The page's content goes here."
