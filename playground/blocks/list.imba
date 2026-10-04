import { students, subjectItems } from './data.imba'

# A table page: a title with the main action, then one card holding the
# search and filters, a selectable table and paging, with an action bar for
# the selection.
tag block-list
	query = ''
	subject = null
	statuses = []
	filtersOpen = no
	selected = []
	sort = { key: 'name', dir: 'asc' }
	page = 1
	pageSize = 8

	columns = [
		{ key: 'name', label: 'Student', sortable: yes, tag: 'list-student' }
		{ key: 'subject', label: 'Subject', sortable: yes }
		{ key: 'year', label: 'Year', sortable: yes, align: 'end' }
		{ key: 'status', label: 'Status', sortable: yes, tag: 'list-status' }
		{ key: 'lessons', label: 'Lessons', sortable: yes, align: 'end' }
	]
	statusItems = ['Active', 'Paused', 'New'].map do(s) { value: s, label: s }

	get filtered
		let q = query.trim!.toLowerCase!
		students.filter do(s)
			(!q or "{s.name} {s.email}".toLowerCase!.includes(q)) and (!subject or s.subject == subject) and (!statuses.length or statuses.includes(s.status))

	# Sort everything, then show one page.
	get rows
		let all = $table ? $table.sortList(filtered) : filtered
		all.slice((page - 1) * pageSize, page * pageSize)

	def clearFilters
		subject = null
		statuses = []
		page = 1

	css
		d:flex fld:column g:4
		.head d:flex ai:flex-end jc:space-between g:4 flw:wrap mb:2
		h2 m:0 fs:xl fw:700
		.sub m:0 mt:1 c:$ui-muted fs:sm
		.toolbar d:flex g:2 flw:wrap py:3 px:5 bdb:1px solid $ui-border
		.search flg:1 min-width:48
		.subject w:44
		.pager fl:1

	<self>
		<div.head>
			<div>
				<h2> "Students"
				<p.sub> "{filtered.length} of {students.length} students"
			<ui-button variant='primary' icon='lucide:user-plus'> "Add student"
		# The toolbar, table and paging read as one unit in a card.
		<ui-card flush>
			<div.toolbar>
				<ui-input.search icon='lucide:search' placeholder='Search by name or email' bind=query @input=(page = 1)>
				<ui-select.subject items=subjectItems placeholder='All subjects' clearable bind=subject @change=(page = 1)>
				<ui-sheet side='right' size='sm' heading='Filters' bind=filtersOpen>
					<ui-button slot='trigger' icon='lucide:sliders-horizontal'> statuses.length ? "Filters ({statuses.length})" : "Filters"
					<ui-checkbox-group label='Status' items=statusItems bind=statuses @change=(page = 1)>
					<div slot='footer'>
						<ui-button @click=clearFilters> "Clear"
						<ui-button variant='primary' @click=(filtersOpen = no)> "Show {filtered.length} students"
			<ui-table$table flush columns=columns rows=rows manualSort selectable bind:selected=selected bind:sort=sort label='Students'>
				<div slot='empty'>
					<ui-empty-state icon='lucide:search-x' heading='No students match' description='Try a different search or clear the filters.'>
						<ui-button slot='actions' size='sm' @click=(query = '', clearFilters!)> "Clear search and filters"
			<ui-pagination.pager slot='footer' count=filtered.length pageSize=pageSize summary bind=page>
		<ui-action-bar open=(selected.length > 0) @close=(selected = [])>
			<span slot='selection'> "{selected.length} selected"
			<ui-button size='sm' icon='lucide:send'> "Message"
			<ui-button size='sm' icon='lucide:download'> "Export"
			<ui-button size='sm' variant='danger' icon='lucide:archive' @click=(selected = [])> "Archive"

tag list-student
	prop row
	css d:flex ai:center g:2.5
		.email c:$ui-muted fs:xs
	<self>
		<ui-avatar size='sm' name=row.name>
		<div>
			<div> row.name
			<div.email> row.email

tag list-status
	prop value
	<self> <ui-badge variant=({ Active: 'success', Paused: 'warning', New: 'accent' }[value])> value
