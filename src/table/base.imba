import { icons } from '../icons.imba'
import '../checkbox/base.imba'
import '../skeleton/base.imba'

# Headless data table: rows of objects, laid out by `columns`.
#
#   <ui-table columns=columns rows=students selectable bind:selected=picked>
#
#   columns = [
#     { key: 'name', label: 'Name', sortable: yes }
#     { key: 'year', label: 'Year', align: 'end', sortable: yes }
#     { key: 'fee', label: 'Fee', format: do(v) "£{v}" }
#     { key: 'actions', label: '', tag: 'student-actions', width: '3rem' }
#   ]
#
# A column shows `row[key]` (or `value(row)`), through `format(value, row)`
# if given. For richer cells give it a `tag`: that tag is rendered with
# `row`, `column` and `value`. `align` is 'start' (default), 'center' or 'end'.
#
# - `rowKey`: the property that identifies a row ('id')
# - `sortable` columns sort when their heading is clicked: ascending,
#   descending, then off. Bind the state with `bind:sort=` ({ key, dir });
#   with `manualSort` rows aren't sorted here: sort them yourself, with
#   `sortList(list)` before paging or on a server (listen for `sortchange`).
# - `selectable`: a checkbox per row and a select-all; the selected rows' keys
#   are bindable with `bind:selected=` (`selectionchange` is emitted too)
# - `loading`: skeleton rows while there are none yet, else dims the rows
# - `emptyText`, or an `empty` slot, for no rows
# - `maxHeight`: scrolls the rows under a sticky header
# - `label`: a caption for assistive tech
# - `size`: 'sm' or 'md' (default)
#
# Emits `rowclick` with the row when a row is clicked (outside its controls).
#
# Or write the table yourself, for its look alone (no sorting, selection or
# loading states): without `columns`, a <table> inside is styled the same,
# `data-align` on cells included.
#
#   <ui-table>
#     <table>
#       <thead> <tr> <th> 'Name'; <th data-align='end'> 'Year'
#       <tbody> …
tag ui-table-base
	prop columns = []
	prop rows = []
	prop rowKey = 'id'
	prop selectable = false
	prop selected = []
	prop sort = null
	prop manualSort = false
	prop loading = false
	prop loadingRows = 5
	prop emptyText = 'Nothing here yet'
	prop maxHeight = null
	prop label = null
	prop size = 'md'

	def keyOf row do row[rowKey]
	def valueOf row, column do column.value ? column.value(row) : row[column.key]
	def display row, column
		let value = valueOf(row, column)
		column.format ? column.format(value, row) : (value ?? '')

	# Numbers by value, everything else as text with numbers in order
	# ("Year 2" before "Year 10"); empty values last.
	def compare a, b
		return 0 if a == b
		return 1 if a == null or a === ''
		return -1 if b == null or b === ''
		return a - b if typeof a == 'number' and typeof b == 'number'
		String(a).localeCompare(String(b), undefined, numeric: yes, sensitivity: 'base')

	# A copy of `list` in the current sort order. With paging, sort the whole
	# list with this (and set `manualSort`), then hand the table one page.
	def sortList list
		list = list or []
		let column = sort and columns.find(do $1.key == sort.key)
		return list unless column
		let dir = sort.dir == 'desc' ? -1 : 1
		list.slice!.sort do(a, b) compare(valueOf(a, column), valueOf(b, column)) * dir

	get sortedRows do manualSort ? (rows or []) : sortList(rows)

	def toggleSort column
		let current = sort and sort.key == column.key ? sort.dir : null
		sort = current == null ? { key: column.key, dir: 'asc' } : (current == 'asc' ? { key: column.key, dir: 'desc' } : null)
		emit('sortchange', sort)

	def sortDir column do sort and sort.key == column.key ? sort.dir : null
	def ariaSort column
		return undefined unless column.sortable
		{ asc: 'ascending', desc: 'descending' }[sortDir(column)] or 'none'

	def isSelected row do (selected or []).includes(keyOf(row))

	# Checked, unchecked or 'indeterminate', for the select-all box.
	get allState
		let list = rows or []
		let count = list.filter(do isSelected($1)).length
		count == 0 ? false : (count == list.length ? true : 'indeterminate')

	def setSelected keys
		selected = keys
		emit('selectionchange', keys)

	def toggleRow row, on
		let key = keyOf(row)
		let rest = (selected or []).filter(do $1 != key)
		setSelected(on ? [...rest, key] : rest)

	def toggleAll on
		let keys = (rows or []).map(do keyOf($1))
		let rest = (selected or []).filter(do !keys.includes($1))
		setSelected(on ? [...rest, ...keys] : rest)

	def rowClicked e, row
		return if e.target.closest('a, button, input, label, select, textarea, [data-scope]')
		emit('rowclick', row)

	get columnCount do columns.length + (selectable ? 1 : 0)

	<self .{size} .loading=(loading and rows.length > 0)>
		<div.scroll .sticky=!!maxHeight style=(maxHeight ? "max-height: {maxHeight}" : undefined)>
			# Without columns, a <table> written inside is styled the same.
			if !columns or !columns.length
				<slot>
			else
				<table.table aria-busy=String(!!loading)>
					if label
						<caption.caption> label
					<thead>
						<tr>
							if selectable
								<th.select-cell scope='col'>
									<ui-checkbox label='Select all rows' labelHidden checked=allState disabled=!rows.length @change.stop=toggleAll(e.detail)>
							for column in columns
								<th scope='col' data-align=(column.align or 'start') aria-sort=ariaSort(column) style=(column.width ? "width: {column.width}" : undefined)>
									if column.sortable
										<button.sort type='button' data-dir=sortDir(column) @click=toggleSort(column)>
											<span> column.label
											<ui-icon.sort-icon path=(sortDir(column) == 'asc' ? icons.up : (sortDir(column) == 'desc' ? icons.down : icons.upDown)) size=14>
									else
										column.label
					<tbody>
						if loading and !rows.length
							for i in [0 ... loadingRows]
								<tr.skeleton-row>
									if selectable
										<td.select-cell>
									for column in columns
										<td> <ui-skeleton height='0.75rem' width='60%'>
						elif !rows.length
							<tr>
								<td.empty colSpan=columnCount>
									<slot name='empty'> <span> emptyText
						else
							for row in sortedRows
								<tr key=keyOf(row) .selected=isSelected(row) aria-selected=(selectable ? String(isSelected(row)) : undefined) @click=rowClicked(e, row)>
									if selectable
										<td.select-cell>
											<ui-checkbox label="Select {display(row, columns[0])}" labelHidden checked=isSelected(row) @change.stop=toggleRow(row, e.detail)>
									for column in columns
										<td data-align=(column.align or 'start')>
											if column.tag
												<{column.tag} row=row column=column value=valueOf(row, column)>
											else
												display(row, column)
