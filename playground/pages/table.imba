import source from './table.imba?raw'
import { toaster } from '../../src/toast/index.imba'
import { TableSelection, TableSort } from '../../src/table/index.imba'

const first = ['Ada', 'Alan', 'Grace', 'Katherine', 'Margaret', 'Tim', 'Edsger', 'Barbara', 'Donald', 'Radia', 'Frances', 'John']
const last = ['Lovelace', 'Turing', 'Hopper', 'Johnson', 'Hamilton', 'Berners-Lee', 'Dijkstra', 'Liskov', 'Knuth', 'Perlman', 'Allen', 'McCarthy']
const subjects = ['Maths', 'English', 'Physics', 'Chemistry']
const statuses = ['Active', 'Active', 'Active', 'Paused', 'New']

# 36 made-up students.
const students = Array.from(length: 36) do(_, i)
	let name = "{first[i % 12]} {last[(i * 5 + Math.floor(i / 12)) % 12]}"
	{
		id: i + 1
		name: name
		email: "{name.split(' ')[0].toLowerCase!}{i + 1}@example.com"
		year: 7 + (i * 3) % 7
		subject: subjects[i % 4]
		status: statuses[i % 5]
		lessons: (i * 13) % 40
		fee: 30 + (i % 4) * 5
	}

# Cells with more than text: a tag gets the row (and column and value).
tag StudentCell
	prop row
	css d:flex ai:center g:2.5
		.email c:$ui-muted fs:xs
	<self>
		<ui-avatar name=row.name size='sm'>
		<div>
			<div> row.name
			<div.email> row.email

tag StatusBadge
	prop value
	<self> <ui-badge variant=({ Active: 'success', Paused: 'warning', New: 'accent' }[value])> value

tag RowActions
	prop row
	items = [
		{ value: 'message', label: 'Message', icon: 'lucide:message-square' }
		{ value: 'book', label: 'Book lesson', icon: 'lucide:calendar-plus' }
		{ separator: true }
		{ value: 'archive', label: 'Archive', icon: 'lucide:archive', danger: true }
	]
	<self> <ui-menu items=items label=row.name placement='bottom-end' @select=toaster.info(title: "{e.detail}: {row.name}")>
		<ui-button slot='trigger' size='sm' variant='ghost' icon='lucide:ellipsis' aria-label="Actions for {row.name}">

# Follows a link without reloading the page, as Inertia's `Link` does; a
# table's `linkTag` renders its sorting links with it.
tag RouterLink < a
	def follow e
		return if e.metaKey or e.ctrlKey or e.shiftKey or e.altKey
		e.preventDefault!
		router.go(getAttribute('href'))
	<self @click=follow(e)> <slot>

const invoices = [
	{ id: 'INV-031', student: 'Ada Lovelace', date: '1 Oct', amount: 120 }
	{ id: 'INV-030', student: 'Alan Turing', date: '24 Sep', amount: 140 }
	{ id: 'INV-029', student: 'Grace Hopper', date: '17 Sep', amount: 90 }
]

tag page-table
	query = ''
	page = 1
	selected = []
	sort = { key: 'name', dir: 'asc' }
	loading = no
	empty = no

	picked = new TableSelection
	order = new TableSort(local: yes, default: { key: 'student' })
	# Sorted on the server: the order lives in the URL's query, and without
	# one the server sorts by name.
	serverSort = new TableSort(default: { key: 'name' })

	columns = [
		{ key: 'name', label: 'Student', sortable: yes, tag: StudentCell }
		{ key: 'year', label: 'Year', sortable: yes, align: 'end' }
		{ key: 'subject', label: 'Subject', sortable: yes }
		{ key: 'status', label: 'Status', sortable: yes, tag: StatusBadge }
		{ key: 'lessons', label: 'Lessons', sortable: yes, align: 'end' }
		{ key: 'fee', label: 'Fee', align: 'end', format: do(v) "£{v}" }
		{ key: 'actions', label: '', tag: RowActions, width: '3rem' }
	]
	compactColumns = [
		{ key: 'name', label: 'Student', sortable: yes }
		{ key: 'subject', label: 'Subject' }
		{ key: 'lessons', label: 'Lessons', align: 'end', sortable: yes }
	]

	# Filtered, then sorted, then paged: sorting happens before paging, so the
	# table sorts the whole list (manualSort) and shows just this page.
	get filtered
		let q = query.trim!.toLowerCase!
		q ? students.filter(do "{$1.name} {$1.email} {$1.subject}".toLowerCase!.includes(q)) : students

	get sortedAll do $table ? $table.sortList(filtered) : filtered
	get pageRows do $pager ? $pager.rowsFor(sortedAll) : sortedAll.slice(0, 10)

	css
		.toolbar d:flex ai:center jc:space-between g:3 flw:wrap w:100%
		.search w:100% @sm:64
		.stack d:flex fld:column g:3 w:100%

	<self>
		<demo-page source=source heading='Table' intro='ui-table lays out rows of objects by `columns`: sortable headings, row selection with select-all (Shift-click a checkbox to tick a run of rows, and an action bar appears), custom cells, loading and empty states. ui-pagination pages through them.'>
			<demo-section heading='Students' uses='columns' bare>
				<div.stack>
					<div.toolbar>
						<ui-input.search icon='lucide:search' placeholder='Search students' bind=query @input=(page = 1)>
					<ui-table$table columns=columns rows=pageRows manualSort selectable bind:selected=selected bind:sort=sort label='Students' @sortchange=(page = 1) @rowclick=toaster.info(title: "Open {e.detail.name}")>
					<ui-pagination$pager count=filtered.length pageSize=8 summary noun='students' bind=page>
					# Floats at the bottom of the screen while rows are ticked.
					<ui-action-bar open=(selected.length > 0) @close=(selected = [])>
						<span slot='selection'> "{selected.length} selected"
						<ui-button size='sm' icon='lucide:send' @click=toaster.info(title: "Message {selected.length} students")> "Message"
						<ui-button size='sm' icon='lucide:calendar-plus'> "Book lessons"
						<ui-button size='sm' variant='danger' icon='lucide:archive' @click=(selected = [])> "Archive"

				<div.out>
					<json-print data={ page, sort, selected }>

			<demo-section heading='Written as markup' uses='picked order' bare>
				<p.note> "Without `columns`, write the <table> yourself: plain <th>/<td> get the same look, and the parts add sorting (a TableSort) and selection (a TableSelection), set once on ui-table."
				<ui-table sorting=order selection=picked>
					<table>
						<thead>
							<tr>
								<ui-table-select-all rows=invoices>
								<ui-table-header sort='id'> "Invoice"
								<ui-table-header sort='student'>
									<iconify-icon icon='lucide:user' width='13' [va:-2px]>
									" Student"
								<ui-table-header> "Date"
								<ui-table-header sort='amount' align='end'> "Amount"
						<tbody>
							for invoice in order.apply(invoices)
								<ui-table-row key=invoice.id row=invoice>
									<ui-table-select row=invoice label="Select {invoice.id}">
									<ui-table-cell> <code> invoice.id
									<ui-table-cell> <strong> invoice.student
									<ui-table-cell nowrap> invoice.date
									<ui-table-cell align='end'> "£{invoice.amount}"
						<tfoot>
							<tr>
								<td colSpan=4> "Total"
								<td data-align='end'> "£{invoices.reduce((do $1 + $2.amount), 0)}"
				<div.out>
					<json-print data={ order: order.value, picked: picked.keys }>

			<demo-section heading='Sorted on the server' uses='serverSort' bare>
				<p.note> "A TableSort follows the URL: it reads the order from the query, and its headings link to the next one: the same URL with `sort` and `dir` set and `page` removed. `default` is the server's order when the query has none: its heading shows it and flips rather than turning off. `linkTag` renders them with your router's link (Inertia's `Link`)."
				<ui-table sorting=serverSort linkTag=RouterLink>
					<table>
						<thead>
							<tr>
								<ui-table-header sort='name'> "Student"
								<ui-table-header sort='subject'> "Subject"
								<ui-table-header sort='lessons' align='end'> "Lessons"
						<tbody>
							# Standing in for the server, which would sort the query.
							for s in serverSort.apply(students.slice(0, 5))
								<tr>
									<td> s.name
									<td> s.subject
									<td data-align='end'> s.lessons
				<div.out>
					<json-print data={ query: globalThis.location.search or '(none)', order: serverSort.value }>

			<demo-section heading='Loading and empty' bare>
				<div.stack>
					<ui-table columns=compactColumns rows=(empty or loading ? [] : students.slice(0, 4)) loading=loading>
						<div slot='empty'>
							<ui-empty-state icon='lucide:users' heading='No students yet' description='Add your first student to get started.'>
								<ui-button slot='actions' size='sm' variant='primary' icon='lucide:plus'> "Add student"
				<div.out>
					<div.set>
						<button @click=(loading = !loading)> loading ? "Stop loading" : "Load"
						<button @click=(empty = !empty)> empty ? "Show rows" : "Empty"

			<demo-section heading='Roomy' bare>
				<ui-table columns=compactColumns rows=students.slice(0, 3) size='lg'>
				<div.out>
					<p.note> "`size` is 'sm', 'md' (default) or 'lg'."

			<demo-section heading='Compact, with a sticky header' bare>
				<ui-table columns=compactColumns rows=students size='sm' maxHeight='16rem' sort={ key: 'lessons', dir: 'desc' }>
