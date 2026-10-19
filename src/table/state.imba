# A table's state kept outside it, so a page holds it in one field: which
# rows are ticked (TableSelection) and how they're sorted (TableSort). Plain
# classes: change them in an event handler (or call `imba.commit`) and the
# page and the table's parts re-render.

# Numbers by value, everything else as text with numbers in order
# ("Year 2" before "Year 10"); empty values last.
export def compareValues a, b
	return 0 if a == b
	return 1 if a == null or a === ''
	return -1 if b == null or b === ''
	return a - b if typeof a == 'number' and typeof b == 'number'
	String(a).localeCompare(String(b), undefined, numeric: yes, sensitivity: 'base')

# The ticked rows, by key.
#
#   selection = new TableSelection
#   selection.has(row)       # ticked?
#   selection.keys           # the ticked rows' keys (settable)
#   selection.clear!
#
# - `key`: the row property that identifies a row ('id')
# - `keys`: the rows ticked to begin with
# - `onchange(keys)`: called on every change
export class TableSelection
	constructor options = {}
		key = options.key or 'id'
		onchange = options.onchange or null
		#keys = options.keys or []

	get keys do #keys
	set keys value
		#keys = value or []
		onchange(#keys) if onchange

	get count do #keys.length

	def keyOf row do row and typeof row == 'object' ? row[key] : row
	def has row do #keys.includes(keyOf(row))

	# Ticks (or clears) a row. With `shift` (Shift held) and `list` (the rows
	# in order), every row from the last one toggled to this one.
	def toggle row, on = !has(row), list = null, shift = no
		let k = keyOf(row)
		let range = [k]
		if shift and list and #anchor !== undefined
			let order = list.map(do keyOf($1))
			let from = order.indexOf(#anchor)
			let to = order.indexOf(k)
			range = order.slice(Math.min(from, to), Math.max(from, to) + 1) if from >= 0 and to >= 0
		#anchor = k
		let rest = #keys.filter(do !range.includes($1))
		keys = on ? [...rest, ...range] : rest

	# Ticks (or clears) all of `rows`, leaving other ticked keys alone.
	def toggleAll rows, on = state(rows) !== true
		let all = (rows or []).map(do keyOf($1))
		let rest = #keys.filter(do !all.includes($1))
		keys = on ? [...rest, ...all] : rest

	# Whether `rows` are all ticked (true), none (false) or 'indeterminate'.
	def state rows
		let list = rows or []
		let count = list.filter(do has($1)).length
		count == 0 ? false : (count == list.length ? true : 'indeterminate')

	def clear do keys = []

# `{ key, dir }` with dir 'asc' (the default) or 'desc'; null without a key.
def orderOf order
	order and order.key ? { key: order.key, dir: order.dir == 'desc' ? 'desc' : 'asc' } : null

# How rows are sorted: a key and 'asc' or 'desc', or none. Sortable headers
# cycle ascending, descending, then off (back to the default order, if any).
#
# By default it follows the URL, for sorting on the server: it reads the
# order from the query (`sort` and `dir`), and sortable headers become links
# to the next one.
#
#   sorting = new TableSort(default: { key: 'date', dir: 'desc' })
#   sorting = new TableSort(url: do getPage!.url)   # Inertia's page URL (SSR too)
#
# With `local`, it keeps the order itself, for rows sorted here:
#
#   sorting = new TableSort(local: yes, default: { key: 'name' })
#   sorting.apply(rows)
#
# - `default`: the order rows are in when none is picked (`{ key, dir }`),
#   e.g. the server's when the query has no `sort`. Its heading shows it, and
#   flips between ascending and descending rather than turning off; links
#   back to it leave `sort` and `dir` out of the URL
# - `url`: the URL to read (or a function returning it); the current
#   location by default. Links keep the rest of its query, minus the page,
#   so a new order starts on the first
# - `params`: the query's names, `{ sort: 'sort', dir: 'dir', page: 'page' }`
# - `local`: keeps the order here instead of in the URL; headers are buttons
# - `onchange(order)`: called when a header changes it (`{ key, dir }`, or
#   null back to the default)
export class TableSort
	constructor options = {}
		#url = options.url ?? null
		local = !!options.local
		params = { sort: 'sort', dir: 'dir', page: 'page', ...(options.params or {}) }
		onchange = options.onchange or null
		#order = null
		#default = orderOf(options.default)

	get linked do !local

	def currentUrl
		let href = typeof #url == 'function' ? #url() : (typeof #url == 'string' ? #url : null)
		let here = globalThis.location..href
		new URL(href or here or '/', here or 'http://localhost')

	# The order: `{ key, dir }`, or null. Linked, the URL's; just after a
	# header click, the new one until the URL catches up. Without one, the
	# default.
	get value do picked ?? #default

	# The order picked (in the URL, or here), leaving out the default.
	get picked
		return #order unless linked
		let url = currentUrl!
		if #pending
			return #pending.order if url.href == #pending.from
			#pending = null
		orderOf({ key: url.searchParams.get(params.sort), dir: url.searchParams.get(params.dir) })
	set value order
		#order = orderOf(order)

	get default do #default

	get key do value..key ?? null
	get dir do value..dir ?? null

	# 'asc' or 'desc' when rows are sorted by `key`, else null.
	def directionOf key
		let order = value
		order and order.key == key ? order.dir : null

	# The order a click on `key`'s header moves to.
	def next key
		let dir = directionOf(key)
		let order = dir == null ? { key, dir: 'asc' } : (dir == 'asc' ? { key, dir: 'desc' } : null)
		# Turning it off would go back to the default, so its own column flips.
		order = { key, dir: 'asc' } if !order and #default and #default.key == key
		order

	# A link to the next order for `key`: the current URL with `sort` and `dir`
	# set (or removed, going back to the default or none) and `page` removed.
	def href key
		let url = currentUrl!
		let order = next(key)
		if order and !(#default and order.key == #default.key and order.dir == #default.dir)
			url.searchParams.set(params.sort, order.key)
			url.searchParams.set(params.dir, order.dir)
		else
			url.searchParams.delete(params.sort)
			url.searchParams.delete(params.dir)
		url.searchParams.delete(params.page)
		url.pathname + url.search + url.hash

	# Moves `key` to its next order. Linked, the header's link does the visit,
	# and this shows the new order meanwhile.
	def toggle key
		let order = next(key)
		if linked
			#pending = { order, from: currentUrl!.href }
		else
			#order = order
		onchange(order) if onchange
		order

	# A sorted copy of `list`. `valueOf(row, key)` reads a row's value
	# (`row[key]` by default).
	def apply list, valueOf = null
		let order = value
		return (list or []) unless order
		let dir = order.dir == 'desc' ? -1 : 1
		let read = valueOf or (do(row, key) row[key])
		(list or []).slice!.sort do(a, b) compareValues(read(a, order.key), read(b, order.key)) * dir
