# Page headings.

# A title, a line about the page, and its main actions.
tag heading-simple
	css
		d:flex ai:flex-end jc:space-between g:4 flw:wrap
		h1 m:0 fs:2xl fw:700
		p m:0 mt:1 c:$ui-muted fs:sm
		.actions d:flex g:2
	<self>
		<div>
			<h1> "Invoices"
			<p> "Bill students and track what’s been paid."
		<div.actions>
			<ui-button icon='lucide:download'> "Export"
			<ui-button variant='primary' icon='lucide:plus'> "New invoice"

# Breadcrumbs above, and a row of details under the title.
tag heading-meta
	css
		d:flex fld:column g:3
		.row d:flex ai:flex-end jc:space-between g:4 flw:wrap
		h1 m:0 fs:2xl fw:700
		.meta d:flex g:4 flw:wrap mt:2 c:$ui-muted fs:sm
			span d:inline-flex ai:center g:1.5
		.actions d:flex g:2
	<self>
		<ui-breadcrumbs items=[{ label: 'Lessons', href: '#' }, { label: 'October', href: '#' }, { label: 'Maths with Ada' }]>
		<div.row>
			<div>
				<h1> "Maths with Ada"
				<div.meta>
					<span>
						<iconify-icon icon='lucide:calendar'>
						"Thursday 8 October"
					<span>
						<iconify-icon icon='lucide:clock'>
						"16:00–17:00"
					<span>
						<iconify-icon icon='lucide:map-pin'>
						"Online"
			<div.actions>
				<ui-button icon='lucide:pencil'> "Edit"
				<ui-button variant='primary' icon='lucide:video'> "Join"

# A person or account: avatar, name, status and actions.
tag heading-avatar
	css
		d:flex ai:center jc:space-between g:4 flw:wrap
		.who d:flex ai:center g:4
		h1 m:0 fs:2xl fw:700
		.sub d:flex ai:center g:2 mt:1 c:$ui-muted fs:sm
		.actions d:flex g:2
	<self>
		<div.who>
			<ui-avatar size='xl' name='Grace Hopper'>
			<div>
				<h1> "Grace Hopper"
				<div.sub>
					<ui-badge variant='accent'> "Tutor"
					"Maths and physics · since 2019"
		<div.actions>
			<ui-button icon='lucide:share-2'> "Share profile"
			<ui-button variant='primary'> "Edit profile"

# A smaller heading for a section within a page, with a link to the rest.
tag heading-section
	css
		d:flex ai:center jc:space-between g:4 pb:3 bdb:1px solid $ui-border
		h2 m:0 fs:md fw:600
		.count c:$ui-muted fw:400 ml:1
	<self>
		<h2>
			"Homework"
			<span.count> "3"
		<ui-button size='sm' variant='ghost' iconEnd='lucide:arrow-right'> "View all"

export const examples = [
	{ heading: 'Simple', tag: 'heading-simple' }
	{ heading: 'With breadcrumbs and details', tag: 'heading-meta' }
	{ heading: 'With an avatar', tag: 'heading-avatar' }
	{ heading: 'Section heading', tag: 'heading-section' }
]
