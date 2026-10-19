import { icons } from '../icons.imba'
import '../checkbox/base.imba'
import '../skeleton/base.imba'
import { uiLocale } from '../locale.imba'
import { TableSelection, TableSort, compareValues } from './state.imba'

# Headless data table: rows of objects, laid out by `columns`.
#
#   <ui-table columns=columns rows=students selectable bind:selected=picked>
#
#   columns = [
#     { key: 'name', label: 'Name', sortable: yes }
#     { key: 'year', label: 'Year', align: 'end', sortable: yes }
#     { key: 'fee', label: 'Fee', format: do(v) "£{v}" }
#     { key: 'actions', label: '', tag: StudentActions, width: '3rem' }
#   ]
#
# - `rows`: plain objects, one per row
# - `columns`: what each column shows. `key`: the row property shown (and
#   sorted by); `label`: the heading; `sortable`; `align`: 'start', 'center'
#   or 'end'; `width`: any CSS width; `format(value, row)`: turns the value
#   into text; `value(row)`: computes it instead of `row[key]`; `tag`: a tag
#   that renders the cell, given `row`, `column` and `value` (a tag class,
#   e.g. a local `tag StudentActions`, or a global tag's name)
# - `rowKey`: the property that identifies a row ('id')
# - `sortable` columns sort when their heading is clicked: ascending,
#   descending, then off. Bind the state with `bind:sort=` ({ key, dir });
#   with `manualSort` rows aren't sorted here: sort them yourself, with
#   `sortList(list)` before paging or on a server (listen for `sortchange`).
# - `sorting`: a TableSort to keep the order in instead of `sort`. Following
#   the URL (its default; sorted on the server), the headings are links and
#   rows come in sorted; with `local: yes`, they're sorted here
# - `selectable`: a checkbox per row and a select-all; the selected rows' keys
#   are bindable with `bind:selected=` (`selectionchange` is emitted too).
#   Shift-clicking a row's checkbox ticks (or clears) the rows between it and
#   the last one clicked.
# - `selection`: a TableSelection to keep the ticked rows in instead of
#   `selected`
# - `linkTag`: the tag sorting links render with, e.g. Inertia's `Link`
#   (`<a>` by default); the parts below use it too
# - `loading`: skeleton rows while there are none yet, else dims the rows
# - `emptyText`, or an `empty` slot, for no rows
# - `maxHeight`: scrolls the rows under a sticky header
# - `label`: a caption for assistive tech
# - `size`: 'sm', 'md' (default) or 'lg' (roomier rows)
# - `flush`: no border or rounding, to sit edge to edge in a card
#
# Emits `rowclick` with the row when a row is clicked (outside its controls).
#
# Or write the table yourself: without `columns`, a <table> inside is styled
# the same (`data-align` on cells included), and the parts below add sorting
# and selection, from the `sorting` and `selection` set here.
#
#   <ui-table sorting=sorting selection=selection>
#     <table>
#       <thead> <tr>
#         <ui-table-select-all rows=students>
#         <ui-table-header sort='name'> 'Name'
#         <ui-table-header sort='year' align='end'> 'Year'
#       <tbody> for s in students
#         <ui-table-row row=s>
#           <ui-table-select row=s>
#           <ui-table-cell> <strong> s.name
#           <ui-table-cell align='end'> s.year
tag ui-table-base
	# Child tags; the styled tag uses the styled ones.
	checkboxTag = 'ui-checkbox-base'
	skeletonTag = 'ui-skeleton-base'

	prop columns = []
	prop rows = []
	prop rowKey = 'id'
	prop selectable = false
	prop selected = []
	prop sort = null
	prop manualSort = false
	prop loading = false
	prop loadingRows = 5
	prop emptyText = null
	prop maxHeight = null
	prop label = null
	prop size = 'md'
	prop flush = false
	prop sorting = null
	prop selection = null
	prop linkTag = null

	def keyOf row do row[rowKey]
	def valueOf row, column do column.value ? column.value(row) : row[column.key]
	def display row, column
		let value = valueOf(row, column)
		column.format ? column.format(value, row) : (value ?? '')

	def compare a, b do compareValues(a, b)

	# The order: `sorting`, else a TableSort kept in step with `sort`.
	get sorter
		return sorting if sorting
		#sorter ||= new TableSort(local: yes)
		#sorter.value = sort
		#sorter

	# The ticked rows: `selection`, else a TableSelection kept in step with
	# `selected`.
	get selector
		return selection if selection
		#selector ||= new TableSelection
		#selector.key = rowKey
		#selector.keys = selected
		#selector

	# A copy of `list` in the current sort order. With paging, sort the whole
	# list with this (and set `manualSort`), then hand the table one page.
	def sortList list
		sorter.apply(list, do(row, key) valueOf(row, columns.find(do $1.key == key) or { key }))

	# Sorted on the server (a linked TableSort), rows come in sorted.
	get sortedRows do manualSort or sorter.linked ? (rows or []) : sortList(rows)

	def toggleSort e, column
		# A link opened in a new tab leaves the order here alone.
		return if sorter.linked and (e.metaKey or e.ctrlKey or e.shiftKey or e.altKey)
		let order = sorter.toggle(column.key)
		sort = order unless sorting
		emit('sortchange', order)

	def sortDir column do sorter.directionOf(column.key)
	def ariaSort column
		return undefined unless column.sortable
		{ asc: 'ascending', desc: 'descending' }[sortDir(column)] or 'none'

	def isSelected row do selector.has(row)

	# Checked, unchecked or 'indeterminate', for the select-all box.
	get allState do selector.state(rows)

	def setSelected keys
		selected = keys unless selection
		emit('selectionchange', keys)

	# Change events don't carry the Shift key, so it's noted on the way in;
	# Shift+mousedown would also select the text between.
	def noteShift e
		#shift = e.shiftKey
		e.preventDefault! if e.shiftKey and e.type == 'mousedown' and e.target.closest('.select-cell')

	# With Shift, every row from the last one clicked to this one.
	def toggleRow row, on
		let s = selector
		s.toggle(row, on, sortedRows, #shift)
		setSelected(s.keys)

	def toggleAll on
		let s = selector
		s.toggleAll(rows, on)
		setSelected(s.keys)

	def rowClicked e, row
		return if e.target.closest('a, button, input, label, select, textarea, [data-scope]')
		emit('rowclick', row)

	get columnCount do columns.length + (selectable ? 1 : 0)

	<self .{size} .flush=flush .loading=(loading and rows.length > 0) data-ui-table>
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
									<{checkboxTag} label=uiLocale.messages.table.selectAll labelHidden checked=allState disabled=!rows.length @change.stop=toggleAll(e.detail)>
							for column in columns
								<th scope='col' data-align=(column.align or 'start') aria-sort=ariaSort(column) style=(column.width ? "width: {column.width}" : undefined)>
									if column.sortable
										<{sorter.linked ? (linkTag or 'a') : 'button'}.sort type=(sorter.linked ? undefined : 'button') href=(sorter.linked ? sorter.href(column.key) : undefined) data-dir=(sortDir(column) or 'none') .sorted=!!sortDir(column) @click=toggleSort(e, column)>
											<span> column.label
											<span.sort-icon> <ui-icon path=(sortDir(column) == 'asc' ? icons.up : (sortDir(column) == 'desc' ? icons.down : icons.upDown)) size=14>
									else
										column.label
					<tbody @pointerdown.capture=noteShift @mousedown.capture=noteShift @keydown.capture=noteShift>
						if loading and !rows.length
							for i in [0 ... loadingRows]
								<tr.skeleton-row>
									if selectable
										<td.select-cell>
									for column in columns
										<td> <{skeletonTag} height='0.75rem' width='60%'>
						elif !rows.length
							<tr>
								<td.empty colSpan=columnCount>
									<slot name='empty'> <span> emptyText ?? uiLocale.messages.table.empty
						else
							for row in sortedRows
								<tr key=keyOf(row) .selected=isSelected(row) aria-selected=(selectable ? String(isSelected(row)) : undefined) @click=rowClicked(e, row)>
									if selectable
										<td.select-cell>
											<{checkboxTag} label=uiLocale.messages.table.selectRow(display(row, columns[0])) labelHidden checked=isSelected(row) @change.stop=toggleRow(row, e.detail)>
									for column in columns
										<td data-align=(column.align or 'start')>
											if column.tag
												<{column.tag} row=row column=column value=valueOf(row, column)>
											else
												display(row, column)

# Parts for a table written as markup, inside ui-table: real table elements
# (`tag … < th`), styled like the generated ones. They take `sorting` and
# `selection` from the ui-table they're in (or their own props), which they
# find once mounted: they aren't inside it yet on their first render.
def tableOf el do el.closest('[data-ui-table]')

# Imba's stand-in for customized built-in elements (Safari) adds an <i-hook>
# to the element, which in a <tr> would lay out as an extra cell.
global css tr > i-hook d:none

# A heading for a table written as markup. With `sort`, clicking it sorts by
# that key: a link to the next order when the TableSort follows the URL, else
# a button; an icon shows the current order.
#
#   <ui-table sorting=sorting>
#     <table>
#       <thead> <tr>
#         <ui-table-header sort='name'> 'Name'
#         <ui-table-header sort='fee' align='end'> 'Fee'
#         <ui-table-header> 'Notes'
#
# - `sort`: the key it sorts by; without it, a plain heading
# - `sorting`: the TableSort it shows and changes (ui-table's by default)
# - `align`: 'start', 'center' or 'end'
# - `linkTag`: the tag its link renders with (ui-table's by default, else `<a>`)
#
# Emits `sortchange` with the new order (`{ key, dir }`, or null).
tag ui-table-header-base < th
	prop sort = null
	prop sorting = null
	prop linkTag = null

	# `align` is a native (obsolete) property of cells.
	get align do #align
	set align value do #align = value

	def mount do render!

	get sorter do sorting or tableOf(self)..sorting
	get linked do !!sorter..linked
	get direction do sort and sorter ? sorter.directionOf(sort) : null

	def clicked e
		return unless sorter
		# A link opened in a new tab leaves the order here alone.
		return if linked and (e.metaKey or e.ctrlKey or e.shiftKey or e.altKey)
		emit('sortchange', sorter.toggle(sort))

	<self scope='col' data-align=(#align or undefined) aria-sort=(sort ? ({ asc: 'ascending', desc: 'descending' }[direction] or 'none') : undefined)>
		if sort
			<{linked ? (linkTag or tableOf(self)..linkTag or 'a') : 'button'}.sort type=(linked ? undefined : 'button') href=(linked ? sorter.href(sort) : undefined) data-dir=(direction or 'none') .sorted=!!direction @click=clicked(e)>
				<slot>
				<span.sort-icon> <ui-icon path=(direction == 'asc' ? icons.up : (direction == 'desc' ? icons.down : icons.upDown)) size=14>
		else
			<slot>

# A cell for a table written as markup.
#
#   <ui-table-cell align='end'> "£{s.fee}"
#
# - `align`: 'start', 'center' or 'end'
# - `nowrap`: keeps it on one line (the table scrolls sideways instead)
tag ui-table-cell-base < td
	prop nowrap = false

	get align do #align
	set align value do #align = value

	<self data-align=(#align or undefined) .nowrap=nowrap> <slot>

# A row for a table written as markup, marked selected while its `row` is
# ticked.
#
#   <ui-table-row row=student @click=open(student)>
#
# - `row`: the row's object (or its key)
# - `selection`: the TableSelection it shows (ui-table's by default)
tag ui-table-row-base < tr
	prop row = null
	prop selection = null

	def mount do render!

	get selector do selection or tableOf(self)..selection
	get ticked do row != null and !!selector..has(row)

	<self .selected=ticked aria-selected=(selector and row != null ? String(ticked) : undefined)> <slot>

# The checkbox cell that ticks a row, for a table written as markup.
# Shift-clicking ticks (or clears) the rows between it and the last one
# clicked.
#
#   <ui-table-row row=s>
#     <ui-table-select row=s>
#
# - `row`: the row's object (or its key)
# - `selection`: the TableSelection it changes (ui-table's by default)
# - `label`: what assistive tech hears ("Select" and the row's key by default)
#
# Emits `selectionchange` with the ticked keys.
tag ui-table-select-base < td
	checkboxTag = 'ui-checkbox-base'

	prop row = null
	prop selection = null
	prop label = null

	def mount do render!

	get selector do selection or tableOf(self)..selection

	# Change events don't carry the Shift key, so it's noted on the way in;
	# Shift+mousedown would also select the text between.
	def noteShift e
		#shift = e.shiftKey
		e.preventDefault! if e.shiftKey and e.type == 'mousedown'

	def toggle on
		return unless selector
		# The rows in the order they're shown, for Shift's range.
		let cells = Array.from(closest('tbody, table')..querySelectorAll('[data-ui-table-select]') or [])
		selector.toggle(row, on, cells.map(do $1.row), #shift)
		emit('selectionchange', selector.keys)

	<self.select-cell data-ui-table-select @pointerdown.capture=noteShift @mousedown.capture=noteShift @keydown.capture=noteShift>
		<{checkboxTag} label=(label ?? uiLocale.messages.table.selectRow(String(selector ? selector.keyOf(row) : row))) labelHidden checked=(!!selector..has(row)) disabled=!selector @change.stop=toggle(e.detail)>

# The select-all checkbox heading, for a table written as markup: ticks (or
# clears) all of `rows`.
#
#   <ui-table-select-all rows=students>
#
# - `rows`: the rows it ticks (those on show)
# - `selection`: the TableSelection it changes (ui-table's by default)
# - `label`: what assistive tech hears ("Select all rows" by default)
#
# Emits `selectionchange` with the ticked keys.
tag ui-table-select-all-base < th
	checkboxTag = 'ui-checkbox-base'

	prop rows = []
	prop selection = null
	prop label = null

	def mount do render!

	get selector do selection or tableOf(self)..selection

	def toggle on
		return unless selector
		selector.toggleAll(rows, on)
		emit('selectionchange', selector.keys)

	<self.select-cell scope='col'>
		<{checkboxTag} label=(label ?? uiLocale.messages.table.selectAll) labelHidden checked=(selector ? selector.state(rows) : false) disabled=(!selector or !(rows or []).length) @change.stop=toggle(e.detail)>
