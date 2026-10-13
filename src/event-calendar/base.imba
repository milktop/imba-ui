import { uiLocale } from '../locale.imba'
import '../button/base.imba'
import '../popover/base.imba'
import '../date-picker/base.imba'
import '../segmented/base.imba'
import '../context-menu/base.imba'
import 'iconify-icon'

# Headless event calendar: a day, a few days or a week across, hours down,
# and optionally a column per resource (a tutor, a vet, a room) within each
# day. Events sit by their times, side by side where they overlap; all-day
# and multi-day events sit in a strip along the top.
#
#   <ui-event-calendar events=lessons selectable editable @slotselect=book(e.detail) @eventclick=open(e.detail) @eventchange=move(e.detail)>
#   <ui-event-calendar view='day' resources=vets slotMinutes=15 events=appointments bind:date=day>
#
# Times are local ISO strings ('2026-10-14T16:00'), as the date picker's
# dates are; an all-day event has dates only ('2026-10-14', its `end` the
# last day).
#
# - `events`: `{ id, title, start, end, allDay, resourceId, color, editable,
#   blocked, pending }`; `color` is 'accent' (default), 'success', 'warning',
#   'danger', 'neutral' or any CSS colour; `editable: false` fixes one;
#   `blocked` draws it hatched (time taken out, not an appointment);
#   `pending` faded and fixed (saving)
# - `resources`: `{ id, title, color, hours, offLabel }`: a column each, per
#   day; events go in their `resourceId`'s column. `color` tints its header,
#   hover, selections and drops, and is its events' colour unless they set
#   their own. `hours`: when it's available on each day shown, as
#   `[{ start: '08:00', end: '13:00' }]` (`[]` for not at all): the rest is
#   shaded and refused, with `offLabel` as the reason
# - `view`: 'day', 'week' (default), 'workweek', or a number of days from
#   `date`; `bind:view=` works. On a narrow screen it shows a day
# - `views`: the toolbar's choices (['day', 'week']; [] for none)
# - `date`: a day in the range shown (today by default); `bind:date=` works
# - `weekStartsOn`: 1 (Monday, default) or 0
# - `startHour`, `endHour`: the hours shown (7 to 21)
# - `slotMinutes`: what selecting, moving and resizing snap to (30)
# - `hourHeight`: a CSS length ('3rem')
# - `height`: a CSS length: the hours scroll inside it under the headers
# - `scrollToTime`: where it opens scrolled to ('08:00', or 'now'), once
# - `rows`: extra rows above the all-day strip, a cell per day (or per column
#   with `perColumn`), e.g. the day's messages: `{ key, label, tag,
#   perColumn, clickable }`; `tag` renders a cell, given `date` and
#   `resource`; a `clickable` row's cells emit `rowclick`
# - `allDayMax`: all-day lanes shown before a "+2 more" (3)
# - `selectable`: an empty slot can be clicked, or a time dragged out (or
#   days in the all-day strip): emits `slotselect`
# - `editable`: events can be moved and resized: drag one to another time,
#   day or resource, or its bottom edge to change its length; or focus it and
#   use ↑↓ (a slot), ←→ (a column), Shift+↑↓ (its length). Emits
#   `eventchange`; update your events in response (or don't, and it stays)
# - `clickableDays`, `clickableResources`: their headers are buttons, emitting
#   `dayclick` and `resourceclick`
# - `isAvailable`: a function given `{ start, end, resourceId, allDay, event,
#   shading }`, returning true, or false or the reason it isn't ('Dr Patel is
#   away'): unavailable time is shaded (the reason on hover) and selecting,
#   moving or resizing into it is refused (emitting `unavailable`). `event` is
#   the one being moved; `shading` is true when it's only asking what to shade
# - `pinned`: an event being placed (it can be from another week): while set,
#   a click on a time moves it there (through `eventchange`, keeping its
#   length); Escape or the bar's Cancel clear it. `bind:pinned=` works
# - `eventMenu`, `slotMenu`: functions giving the items of a menu on
#   right-click (or the Menu key, or Shift+F10, on a focused event), of an
#   event or of an empty slot: `{ label, icon, shortcut, danger, disabled,
#   onSelect }`, `{ separator: true }` or `{ group: 'Heading' }`
# - `eventTag`: a tag rendering an event's content, given `event`, `start`,
#   `end`, `resource` and `compact`
# - `resourceTag`: a resource header's content, given `resource`
# - `dayHeaderTag`: a day header's content, given `date`
# - `eventLabel`: a function giving what screen readers call an event (its
#   title by default)
# - `translations`: its words, over the app's (uiLocale)
# - `locale`: for dates and times (the app's by default)
# - `toolbar`: false hides it; the `actions` slot goes at its end
#
# Emits `slotselect` ({ start, end, resourceId, allDay, keys }: `keys` says
# which of Shift, Alt, Ctrl and ⌘ were held), `eventclick` (the event),
# `eventchange` ({ event, change: { start, end, resourceId }, kind: 'move' or
# 'resize' }), `dayclick` (an ISO date), `resourceclick` ({ resource, date }),
# `rowclick` ({ key, date, resource }), `rangechange` ({ start, end, view }:
# the days shown, when they change: load their events), `unavailable`
# ({ reason, attempt }), `datechange`, `viewchange` and `pinnedchange`.

const pad = do(n) String(n).padStart(2, '0')
export const toISODate = do(d) "{d.getFullYear!}-{pad(d.getMonth! + 1)}-{pad(d.getDate!)}"
export const toISODateTime = do(d) "{toISODate(d)}T{pad(d.getHours!)}:{pad(d.getMinutes!)}"

# '2026-10-14' or '2026-10-14T16:00' as a local Date.
export def parseLocal value
	let [day, time = '00:00'] = String(value).split('T')
	let [y, m, d] = day.split('-').map(Number)
	let [h, min] = time.split(':').map(Number)
	new Date(y, m - 1, d, h or 0, min or 0)

const addDays = do(d, days) new Date(d.getFullYear!, d.getMonth!, d.getDate! + days, d.getHours!, d.getMinutes!)
const addMinutes = do(d, minutes) new Date(d.getTime! + minutes * 60000)
const minutesOfDay = do(d) d.getHours! * 60 + d.getMinutes!
const sameDay = do(a, b) toISODate(a) == toISODate(b)
const minutesBetween = do(a, b) Math.round((b.getTime! - a.getTime!) / 60000)

# The first day of the week holding `d` (Monday by default).
def startOfWeek d, weekStartsOn = 1
	let back = (d.getDay! - weekStartsOn + 7) % 7
	new Date(d.getFullYear!, d.getMonth!, d.getDate! - back)

def isAllDay event
	!!event.allDay or !String(event.start).includes('T') or String(event.start).slice(0, 10) != String(event.end).slice(0, 10)

# A day's events, side by side where they overlap: each takes the first free
# column in its cluster of overlapping events.
def layoutDay events
	let sorted = events.map(do(event) { event, start: parseLocal(event.start), end: parseLocal(event.end) })
	sorted.sort(do(a, b) (a.start - b.start) or (b.end - a.end))
	let placed = []
	let cluster = []
	let clusterEnd = 0
	let close = do
		let columns = Math.max(1, ...cluster.map(do $1.column + 1))
		item.columns = columns for item in cluster
		cluster = []
	for item in sorted
		close! if cluster.length and item.start.getTime! >= clusterEnd
		let taken = cluster.filter(do $1.end > item.start).map(do $1.column)
		let column = 0
		column++ while taken.includes(column)
		let entry = Object.assign({}, item, { column, columns: 1 })
		cluster.push(entry)
		placed.push(entry)
		clusterEnd = Math.max(clusterEnd, item.end.getTime!)
	close!
	placed

const named = ['accent', 'success', 'warning', 'danger', 'neutral']
# A named colour as its token, or a CSS colour as it is.
def cssColor color
	{ accent: 'var(--ui-accent)', success: 'var(--ui-success)', warning: 'var(--ui-warning)', danger: 'var(--ui-danger)', neutral: 'var(--ui-muted)' }[color] or color

const formats = new Map
def formatter locale, options
	let key = "{locale}|{JSON.stringify(options)}"
	formats.set(key, new Intl.DateTimeFormat(locale, options)) unless formats.has(key)
	formats.get(key)

tag ui-event-calendar-base
	prop events = []
	prop resources = null
	prop view = 'week'
	prop views = ['day', 'week']
	prop date = null
	prop weekStartsOn = 1
	prop startHour = 7
	prop endHour = 21
	prop slotMinutes = 30
	prop hourHeight = '3rem'
	prop height = null
	prop scrollToTime = null
	prop rows = []
	prop allDayMax = 3
	prop selectable = false
	prop editable = false
	prop clickableDays = false
	prop clickableResources = false
	prop isAvailable = null
	prop pinned = null
	prop eventMenu = null
	prop slotMenu = null
	prop eventTag = null
	prop resourceTag = null
	prop dayHeaderTag = null
	prop eventLabel = null
	prop translations = null
	prop locale = null
	prop toolbar = true

	# The tags it's built from; the styled calendar uses the styled ones.
	buttonTag = 'ui-button-base'
	popoverTag = 'ui-popover-base'
	datePickerTag = 'ui-date-picker-base'
	segmentedTag = 'ui-segmented-base'
	menuTag = 'ui-context-menu-base'

	narrow = no
	picking = no
	allDayOpen = no
	status = ''
	preview = null
	hoverSlot = null
	menuEntries = []
	now = new Date

	get t do Object.assign({}, uiLocale.messages.calendar, translations)
	get currentLocale do locale or uiLocale.locale
	get today do toISODate(now)

	# ---- Lifecycle: the width (a phone shows a day), and the minute.
	def mount
		#observer = new ResizeObserver do
			let next = clientWidth > 0 and clientWidth < 640
			if next != narrow
				narrow = next
				render!
		#observer.observe(self)
		#clock = setInterval(&, 60000) do
			now = new Date
			render!
		#escape = do(e)
			if e.key == 'Escape' and pinned
				setPinned(null)
		globalThis.addEventListener('keydown', #escape)

	def unmount
		#observer..disconnect!
		clearInterval(#clock)
		globalThis.removeEventListener('keydown', #escape)

	# ---- Bindable values: set, emitted, and the app re-rendered.
	def setDate next
		date = next
		emit('datechange', next)
		imba.commit!

	def setView next
		view = next
		emit('viewchange', next)
		imba.commit!

	def setPinned next
		pinned = next
		emit('pinnedchange', next)
		imba.commit!

	# ---- What's shown.
	get shownView do narrow ? 'day' : view
	get current do parseLocal(date or today)
	get first
		let v = shownView
		v == 'week' ? startOfWeek(current, weekStartsOn) : (v == 'workweek' ? startOfWeek(current, 1) : current)
	get dayCount
		let v = shownView
		v == 'day' ? 1 : (v == 'week' ? 7 : (v == 'workweek' ? 5 : Math.max(1, Number(v) or 1)))
	get step do (shownView == 'week' or shownView == 'workweek') ? 7 : dayCount
	get lanes do resources..length ? resources : [null]
	get span do (endHour - startHour) * 60

	def viewLabel v
		v == 'day' ? t.day : (v == 'week' ? t.week : (v == 'workweek' ? t.workweek : t.days(v)))

	def top minutes do "{((minutes - startHour * 60) / span) * 100}%"
	def length minutes do "{(minutes / span) * 100}%"
	def snap minutes do Math.floor(minutes / slotMinutes) * slotMinutes
	def nameOf event do eventLabel ? eventLabel(event) : (typeof event.title == 'string' ? event.title : t.event)
	def resourceName column do column..resource and typeof column.resource.title == 'string' ? ", {column.resource.title}" : ''
	def resourceOf id do id === undefined or id === null ? null : (resources or []).find(do $1.id == id)
	def columnOf event, iso do columns.findIndex(do $1.iso == iso and (!resources..length or $1.resource..id == event.resourceId))
	def canEdit event do editable and event.editable !== false and !event.pending
	def colorKey color do named.includes(color) ? color : 'custom'

	# ---- Availability: null, or the reason it isn't.
	def clock time do Number(time.slice(0, 2)) * 60 + Number(time.slice(3, 5))

	def hoursReason query
		let resource = resourceOf(query.resourceId)
		let hours = resource..hours
		return null if !hours or query.allDay
		let from = clock(query.start.slice(11))
		let to = query.end.slice(0, 10) == query.start.slice(0, 10) ? clock(query.end.slice(11)) : 24 * 60
		hours.some(do from >= clock($1.start) and to <= clock($1.end)) ? null : (resource.offLabel or t.unavailable)

	def reasonFor query
		let off = hoursReason(query)
		return off if off
		let answer = isAvailable ? isAvailable(query) : true
		answer === true or answer == null ? null : (answer === false ? t.unavailable : answer)

	def timed column, from, to, event = null
		let query = { start: toISODateTime(addMinutes(column.date, from)), end: toISODateTime(addMinutes(column.date, to)), allDay: false }
		query.resourceId = column.resource.id if column.resource
		query.event = event if event
		query

	# A column's unavailable time, slot by slot, merged into runs with one reason.
	def unavailableRuns column
		return [] unless isAvailable or column.resource..hours
		let runs = []
		let from = startHour * 60
		while from < endHour * 60
			let reason = reasonFor(Object.assign(timed(column, from, from + slotMinutes), { shading: yes }))
			let last = runs[runs.length - 1]
			if reason
				if last and last.to == from and last.reason == reason
					last.to = from + slotMinutes
				else
					runs.push({ from, to: from + slotMinutes, reason })
			from += slotMinutes
		runs

	# Worked out again only when what it depends on changes, not on every
	# render (the app re-renders often, and on every pointer move dragging).
	def shadingFor columns
		let key = [columns.map(do "{$1.iso}:{$1.resource..id ?? ''}:{JSON.stringify($1.resource..hours ?? null)}:{$1.resource..offLabel ?? ''}").join('|'), startHour, endHour, slotMinutes, t.unavailable].join('#')
		# Availability often depends on the events (clashes, days away), so
		# new events count as a change too.
		unless #shadingKey == key and #shadingFn == isAvailable and #shadingEvents == events
			#shadingKey = key
			#shadingFn = isAvailable
			#shadingEvents = events
			#shading = columns.map(do unavailableRuns($1))
		#shading

	# Each column's timed events, side by side: again only when they change.
	def timedFor columns
		let key = columns.map(do "{$1.iso}:{$1.resource..id ?? ''}").join('|')
		unless #timedKey == key and #timedEvents == events
			#timedKey = key
			#timedEvents = events
			let list = (events or []).filter(do !isAllDay($1))
			#timed = columns.map do(column)
				layoutDay(list.filter(do String($1.start).startsWith(column.iso) and (!resources..length or $1.resourceId == column.resource..id)))
		#timed

	def refuse reason, attempt
		status = reason
		emit('unavailable', { reason, attempt })
		render!

	# ---- Changing events: by pointer (previewed until dropped) or by keyboard.
	# `byMinutes` kept to the day's hours: an event moves or grows no further
	# than the grid shows.
	def withinHours event, kind, byMinutes
		let start = parseLocal(event.start)
		let from = minutesOfDay(start)
		let to = from + minutesBetween(start, parseLocal(event.end))
		let latest = Math.max(0, endHour * 60 - to)
		let earliest = kind == 'move' ? Math.min(0, startHour * 60 - from) : -Infinity
		Math.max(earliest, Math.min(latest, byMinutes))

	# Where a pinned event placed at `minute` starts: on a slot, ending by the last hour.
	def placeAt minute
		return minute unless pinned
		let duration = minutesBetween(parseLocal(pinned.start), parseLocal(pinned.end)) or slotMinutes
		let latest = startHour * 60 + Math.floor((span - duration) / slotMinutes) * slotMinutes
		Math.max(startHour * 60, Math.min(latest, minute))

	# Where an event would go if moved by `byColumns` and `byMinutes` (or resized).
	def target event, kind, byColumns, byMinutes
		let start = parseLocal(event.start)
		let end = parseLocal(event.end)
		let from = columnOf(event, String(event.start).slice(0, 10))
		return null if from < 0
		byMinutes = withinHours(event, kind, byMinutes)
		return null if !byColumns and !byMinutes
		if kind == 'resize'
			let newEnd = addMinutes(end, byMinutes)
			return null if minutesBetween(start, newEnd) < slotMinutes
			return { start, end: newEnd, column: columns[from] }
		let column = columns[Math.max(0, Math.min(columns.length - 1, from + byColumns))]
		let days = Math.round((column.date - columns[from].date) / 86400000)
		{ start: addMinutes(addDays(start, days), byMinutes), end: addMinutes(addDays(end, days), byMinutes), column }

	def queryFor event, next
		let query = { start: toISODateTime(next.start), end: toISODateTime(next.end), allDay: false, event }
		query.resourceId = next.column.resource.id if next.column.resource
		query

	def timeText date do formatter(currentLocale, { hour: 'numeric', minute: '2-digit' }).format(date)
	def longDayText date do formatter(currentLocale, { weekday: 'long', day: 'numeric', month: 'long' }).format(date)

	# Applies a change, once it's checked to be allowed.
	def applyChange event, kind, next
		let query = queryFor(event, next)
		let reason = reasonFor(query)
		return refuse(reason, query) if reason
		#refocus = event.id
		status = kind == 'resize' ? t.resized(nameOf(event), timeText(next.end)) : t.moved(nameOf(event), "{longDayText(next.start)}, {timeText(next.start)}{resourceName(next.column)}")
		let change = { start: query.start, end: query.end }
		change.resourceId = next.column.resource.id if next.column.resource
		emit('eventchange', { event, change, kind })
		imba.commit!

	def change event, kind, byColumns, byMinutes
		let next = target(event, kind, byColumns, byMinutes)
		applyChange(event, kind, next) if next

	def keysOf e do { shiftKey: e.shiftKey, altKey: e.altKey, ctrlKey: e.ctrlKey, metaKey: e.metaKey }
	def minuteAt y, box do startHour * 60 + snap(Math.max(0, Math.min(span - 1, ((y - box.top) / box.height) * span)))

	def startGesture e, kind, column, event = null
		return unless e.button == 0
		e.stopPropagation!
		try e.currentTarget.setPointerCapture(e.pointerId)
		if kind == 'all-day'
			# The strip spans every column: which one is under the pointer.
			let box = e.currentTarget.getBoundingClientRect!
			let width = box.width / columns.length
			let at = Math.max(0, Math.min(columns.length - 1, Math.floor((e.clientX - box.left) / width)))
			#gesture = { kind, column: at, x: e.clientX, y: e.clientY, top: box.top, height: box.height, width, left: box.left, from: at, moved: no, keys: keysOf(e) }
			preview = { kind: 'all-day', columns: [at] }
			return render!
		let box = e.currentTarget.closest('.day').getBoundingClientRect!
		let from = minuteAt(e.clientY, box)
		#gesture = { kind, column, x: e.clientX, y: e.clientY, top: box.top, height: box.height, width: box.width, left: box.left, from, moved: no, keys: keysOf(e), event }
		preview = { kind: 'select', column, from, to: from + slotMinutes } if kind == 'select'
		preview = { kind: 'place', column, from: placeAt(from) } if kind == 'place'
		render!

	# The columns from one to another (with resources, only the first one's resource).
	def columnRange a, b
		let lo = Math.min(a, b)
		let hi = Math.max(a, b)
		columns.map(do(_, i) i).filter(do $1 >= lo and $1 <= hi and columns[$1].resource == columns[a].resource)

	def track e
		let g = #gesture
		return unless g
		let dx = e.clientX - g.x
		let dy = e.clientY - g.y
		return if !g.moved and Math.hypot(dx, dy) < 4
		g.moved = yes
		let perMinute = g.height / span
		if g.kind == 'all-day'
			let at = Math.max(0, Math.min(columns.length - 1, Math.floor((e.clientX - g.left) / g.width)))
			preview = { kind: 'all-day', columns: columnRange(g.from, at) }
		elif g.kind == 'select'
			let at = minuteAt(e.clientY, g)
			preview = { kind: 'select', column: g.column, from: Math.min(g.from, at), to: Math.max(g.from, at) + slotMinutes }
		elif g.kind == 'place'
			preview = { kind: 'place', column: g.column, from: placeAt(minuteAt(e.clientY, g)) }
		elif g.kind == 'move'
			let byColumns = Math.round(dx / g.width)
			let byMinutes = withinHours(g.event, 'move', Math.round(dy / perMinute / slotMinutes) * slotMinutes)
			preview = { kind: 'move', id: g.event.id, columns: byColumns, minutes: byMinutes, x: byColumns * g.width, y: byMinutes * perMinute }
		else
			preview = { kind: 'resize', id: g.event.id, minutes: withinHours(g.event, 'resize', Math.round(dy / perMinute / slotMinutes) * slotMinutes) }
		render!

	def finish e
		let g = #gesture
		#gesture = null
		let p = preview
		preview = null
		return render! unless g
		if g.kind == 'select' and p..kind == 'select'
			let column = columns[g.column]
			let query = timed(column, p.from, p.to)
			let reason = reasonFor(query)
			return refuse(reason, query) if reason
			status = t.selected("{longDayText(addMinutes(column.date, p.from))}, {timeText(addMinutes(column.date, p.from))} – {timeText(addMinutes(column.date, p.to))}{resourceName(column)}")
			emit('slotselect', Object.assign({}, query, { keys: g.keys }))
			return imba.commit!
		if g.kind == 'all-day' and p..kind == 'all-day'
			let a = columns[p.columns[0]]
			let b = columns[p.columns[p.columns.length - 1]]
			let query = { start: a.iso, end: b.iso, allDay: yes }
			query.resourceId = a.resource.id if a.resource
			let reason = reasonFor(query)
			return refuse(reason, query) if reason
			status = t.selected("{longDayText(a.date)}{p.columns.length > 1 ? ' – ' + longDayText(b.date) : ''}, {t.allDay.toLowerCase!}{resourceName(a)}")
			emit('slotselect', Object.assign({}, query, { keys: g.keys }))
			return imba.commit!
		if g.kind == 'place' and p..kind == 'place' and pinned
			let duration = minutesBetween(parseLocal(pinned.start), parseLocal(pinned.end)) or slotMinutes
			let column = columns[p.column]
			return applyChange(pinned, 'move', { start: addMinutes(column.date, p.from), end: addMinutes(column.date, p.from + duration), column })
		render!
		return unless g.moved and g.event
		# The click that follows a drag isn't a click on the event.
		#suppressClick = yes
		change(g.event, 'move', p.columns, p.minutes) if p..kind == 'move' and (p.columns or p.minutes)
		change(g.event, 'resize', 0, p.minutes) if p..kind == 'resize' and p.minutes

	def cancelGesture
		#gesture = null
		preview = null
		render!

	def eventKeys e, event
		if e.key == 'ContextMenu' or (e.shiftKey and e.key == 'F10')
			let box = e.currentTarget.getBoundingClientRect!
			e.preventDefault! if openMenu(box.left + 8, box.bottom, (eventMenu ? eventMenu(event) : null))
			return
		return unless canEdit(event)
		let move = { ArrowUp: [0, -slotMinutes], ArrowDown: [0, slotMinutes], ArrowLeft: [-1, 0], ArrowRight: [1, 0] }[e.key]
		return unless move
		e.preventDefault!
		if e.shiftKey and move[0] == 0
			change(event, 'resize', 0, move[1])
		else
			change(event, 'move', move[0], move[1])

	def clickEvent event
		if #suppressClick
			#suppressClick = no
			return
		emit('eventclick', event)

	# The slot under the pointer: tinted when it can be selected; while
	# placing a pinned event, its preview.
	def hover e, index
		return if #gesture
		let box = e.currentTarget.getBoundingClientRect!
		let from = minuteAt(e.clientY, box)
		if pinned
			let next = placeAt(from)
			return if preview..kind == 'place' and preview.column == index and preview.from == next
			preview = { kind: 'place', column: index, from: next }
			return render!
		let over = e.target
		let next = selectable and (over == e.currentTarget or over.classList.contains('unavailable')) ? { column: index, from } : null
		return if next..column == hoverSlot..column and next..from == hoverSlot..from
		hoverSlot = next
		render!

	def leaveDay
		hoverSlot = null
		preview = null if pinned and !#gesture
		render!

	# A press on an empty time (or its shading): select, or place the pinned event.
	def pressDay e, index
		let over = e.target
		return unless over == e.currentTarget or over.classList.contains('unavailable')
		if pinned
			startGesture(e, 'place', index)
		elif selectable
			startGesture(e, 'select', index)

	def pressEvent e, index, event
		if canEdit(event) and !pinned
			startGesture(e, 'move', index, event)
		else
			e.stopPropagation!

	def pressAllDay e
		startGesture(e, 'all-day', 0) if selectable and e.target == e.currentTarget

	# ---- One menu, opened where it's wanted: a contextmenu event sent to its
	# hidden trigger at the point is how Zag places a menu there.
	def openMenu x, y, items
		return no unless items..length
		let actions = []
		menuEntries = items.map do(item)
			if item.separator
				{ separator: yes }
			elif item.group
				{ group: item.group }
			else
				{ label: item.label, icon: item.icon, shortcut: item.shortcut, danger: item.danger, disabled: item.disabled, value: actions.push(item.onSelect or (do yes)) - 1 }
		#menuActions = actions
		render!
		let anchor = querySelector('.menu-anchor')
		globalThis.queueMicrotask do
			anchor..dispatchEvent(new MouseEvent('contextmenu', bubbles: yes, cancelable: yes, clientX: x, clientY: y))
		yes

	def runMenu index
		let action = #menuActions..[index]
		action! if action

	def eventContext e, event
		e.preventDefault! if openMenu(e.clientX, e.clientY, (eventMenu ? eventMenu(event) : null))

	def dayContext e, column
		let over = e.target
		return unless over == e.currentTarget or over.classList.contains('unavailable')
		let from = minuteAt(e.clientY, e.currentTarget.getBoundingClientRect!)
		e.preventDefault! if openMenu(e.clientX, e.clientY, (slotMenu ? slotMenu(timed(column, from, from + slotMinutes)) : null))

	def allDayContext e
		return unless e.target == e.currentTarget
		let box = e.currentTarget.getBoundingClientRect!
		let column = columns[Math.max(0, Math.min(columns.length - 1, Math.floor((e.clientX - box.left) / (box.width / columns.length))))]
		let slot = { start: column.iso, end: column.iso, allDay: yes }
		slot.resourceId = column.resource.id if column.resource
		e.preventDefault! if openMenu(e.clientX, e.clientY, (slotMenu ? slotMenu(slot) : null))

	# ---- After each render: the range reported, sticky header offsets, the
	# first scroll, and focus back on a moved event (in its new column).
	def afterRender
		let start = toISODate(dates[0])
		let end = toISODate(dates[dates.length - 1])
		let key = "{start}|{end}|{shownView}"
		unless #rangeKey == key
			#rangeKey = key
			globalThis.queueMicrotask do emit('rangechange', { start, end, view: shownView })
		let grid = querySelector('.grid')
		return unless grid
		if height
			let offset = 0
			let seen = new Set
			for cell in grid.querySelectorAll('[data-sticky-row]')
				let row = cell.dataset.stickyRow
				continue if seen.has(row)
				seen.add(row)
				grid.style.setProperty("--sticky-{row}", "{offset}px")
				offset += cell.getBoundingClientRect!.height
			grid.style.setProperty('--sticky-total', "{offset}px")
			if scrollToTime and !#scrolled
				let day = grid.querySelector('.day')
				if day and day.offsetHeight
					#scrolled = yes
					let [h, m] = scrollToTime == 'now' ? [now.getHours! - 1, 0] : scrollToTime.split(':').map(Number)
					let minutes = Math.max(startHour * 60, Math.min(endHour * 60, h * 60 + (m or 0)))
					grid.scrollTop = day.offsetTop + ((minutes - startHour * 60) / span) * day.offsetHeight - offset
		if #refocus != null
			let id = String(#refocus)
			#refocus = null
			globalThis.queueMicrotask do
				Array.from(querySelectorAll('.event')).find(do $1.dataset.eventId == id)..focus!

	def rendered do afterRender!

	def jump value
		return unless value
		picking = no
		setDate(value)

	def go days do setDate(toISODate(addDays(current, days)))

	def pickView value
		return unless value
		setView(/^\d+$/.test(value) ? Number(value) : value)

	def render
		let t = t
		let first = first
		let count = dayCount
		dates = Array.from({ length: count }, do(_, i) addDays(first, i))
		columns = dates.flatMap do(d) lanes.map do(resource) { date: d, iso: toISODate(d), resource }
		let hours = Array.from({ length: endHour - startHour }, do(_, i) startHour + i)
		let shading = shadingFor(columns)
		let timedByColumn = timedFor(columns)
		let hasResources = !!resources..length
		let twoRows = hasResources and count > 1
		let dayFormat = formatter(currentLocale, { weekday: 'short' })
		let hourFormat = formatter(currentLocale, { hour: 'numeric' })
		let title = count == 1 ? formatter(currentLocale, { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' }).format(first) : formatter(currentLocale, { day: 'numeric', month: 'long', year: 'numeric' }).formatRange(first, dates[count - 1])

		# All-day and multi-day events: bars across the columns they cover, in lanes.
		let bars = []
		for event in (events or []).filter(do isAllDay($1))
			let from = String(event.start).slice(0, 10)
			let to = String(event.end).slice(0, 10)
			let covered = columns.map(do(c, i) c.iso >= from and c.iso <= to and (!hasResources or c.resource..id == event.resourceId) ? i : -1).filter(do $1 >= 0)
			let runs = []
			for i in covered
				let run = runs[runs.length - 1]
				run and run[run.length - 1] == i - 1 ? run.push(i) : runs.push([i])
			bars.push({ event, first: run[0], length: run.length, lane: 0, continued: no }) for run in runs
		bars.sort(do(a, b) (a.first - b.first) or (b.length - a.length))
		let laneEnds = []
		for bar in bars
			let lane = laneEnds.findIndex(do $1 < bar.first)
			lane = laneEnds.length if lane < 0
			laneEnds[lane] = bar.first + bar.length - 1
			bar.lane = lane
		# Past `allDayMax` lanes the rest fold into a "+2 more" per column (until
		# opened); folded bars still show where a shown lane is free.
		let folding = laneEnds.length > allDayMax and !allDayOpen
		let shownLanes = folding ? allDayMax - 1 : laneEnds.length
		let shownBars = bars.filter(do $1.lane < shownLanes)
		let hidden = columns.map(do 0)
		if folding
			let taken = columns.map(do(_, i) new Set(shownBars.filter(do i >= $1.first and i < $1.first + $1.length).map(do $1.lane)))
			for bar in bars.filter(do $1.lane >= shownLanes)
				let piece = null
				let i = bar.first
				while i < bar.first + bar.length
					let lane = Array.from({ length: shownLanes }, do(_, l) l).find(do !taken[i].has($1))
					if lane === undefined
						hidden[i]++
						piece = null
					elif piece and piece.lane == lane and piece.first + piece.length == i
						piece.length++
						taken[i].add(lane)
					else
						piece = Object.assign({}, bar, { first: i, length: 1, lane, continued: i > bar.first })
						shownBars.push(piece)
						taken[i].add(lane)
					i++

		let barColor = do(event) event.color or resourceOf(event.resourceId)..color or 'accent'
		let pinnedMinutes = pinned ? (minutesBetween(parseLocal(pinned.start), parseLocal(pinned.end)) or slotMinutes) : 0
		# The header rows, numbered for sticking: days, resources, extra rows, all-day.
		let rowNumber = 0
		let dayRow = !hasResources or count > 1 ? rowNumber++ : -1
		let resourceRow = hasResources ? rowNumber++ : -1
		let extraRows = (rows or []).map(do rowNumber++)
		let allDayRow = rowNumber

		# The preview's problem, if any, shown as it's dragged.
		let previewReason = null
		let p = preview
		if p and (isAvailable or hasResources)
			if p.kind == 'select'
				previewReason = reasonFor(timed(columns[p.column], p.from, p.to))
			elif p.kind == 'place' and pinned
				previewReason = reasonFor(timed(columns[p.column], p.from, p.from + pinnedMinutes, pinned))
			elif p.kind == 'all-day'
				let a = columns[p.columns[0]]
				let b = columns[p.columns[p.columns.length - 1]]
				let q = { start: a.iso, end: b.iso, allDay: yes }
				q.resourceId = a.resource.id if a.resource
				previewReason = reasonFor(q)
			elif p.kind == 'move' or p.kind == 'resize'
				let event = (events or []).find(do $1.id == p.id)
				let next = event and (p.kind == 'move' ? target(event, 'move', p.columns, p.minutes) : target(event, 'resize', 0, p.minutes))
				previewReason = reasonFor(queryFor(event, next)) if next

		<self .placing=!!pinned style="--columns: {columns.length}; --hour-height: {hourHeight}">
			if toolbar
				<div.toolbar>
					<div.nav>
						<{buttonTag} size='sm' @click=setDate(today)> t.today
						<{buttonTag} size='sm' variant='ghost' icon='lucide:chevron-left' aria-label=t.previous @click=go(-step)>
						<{buttonTag} size='sm' variant='ghost' icon='lucide:chevron-right' aria-label=t.next @click=go(step)>
					# The title opens a month, to jump to any date.
					<div.jump>
						<{popoverTag} placement='bottom-start' bind=picking>
							<button.title slot='trigger' type='button' aria-label="{title}: {t.pickDate}">
								title
								<iconify-icon icon='lucide:chevron-down' aria-hidden='true'>
							<{datePickerTag} inline value=toISODate(current) locale=currentLocale @change.stop=jump(e.detail)>
					<div.actions>
						if !narrow and (views or []).length > 1
							<{segmentedTag} size='sm' aria-label=t.view items=views.map(do { value: String($1), label: viewLabel($1) }) value=String(view) @change.stop=pickView(e.detail)>
						<slot name='actions'>

			if pinned
				<div.pinned-bar role='status'>
					<iconify-icon icon='lucide:move' aria-hidden='true'>
					<span> t.placing(nameOf(pinned))
					<{buttonTag} size='sm' variant='ghost' @click=setPinned(null)> t.cancel

			<div.grid role='grid' aria-label=title .two-rows=twoRows .scroll=!!height style=(height ? "max-height: {height}" : undefined)
				@pointermove.silent=track(e) @pointerup=finish(e) @pointercancel=cancelGesture>
				# Headers: the days (spanning their resources), then the resources.
				<div.corner.sticky data-sticky-row=(dayRow >= 0 ? dayRow : resourceRow) style="grid-row: {twoRows ? 'span 2' : 'auto'}; top: var(--sticky-{dayRow >= 0 ? dayRow : resourceRow})">
				if dayRow >= 0
					for d in dates
						<div.day-header.sticky key=toISODate(d) role='columnheader' .today=sameDay(d, now) data-sticky-row=dayRow style="grid-column: span {lanes.length}; top: var(--sticky-{dayRow})">
							if clickableDays
								<button.header-button type='button' aria-label=longDayText(d) @click=emit('dayclick', toISODate(d))>
									if dayHeaderTag
										<{dayHeaderTag} date=d>
									else
										<span> dayFormat.format(d)
										<strong> d.getDate!
							elif dayHeaderTag
								<{dayHeaderTag} date=d>
							else
								<span> dayFormat.format(d)
								<strong> d.getDate!
				if resourceRow >= 0
					for c in columns
						<div.resource-header.sticky key="{c.iso}-{c.resource.id}" role='columnheader' .colored=!!c.resource.color data-sticky-row=resourceRow
							style="top: var(--sticky-{resourceRow}){c.resource.color ? '; --resource-color: ' + cssColor(c.resource.color) : ''}">
							if clickableResources
								<button.header-button type='button' @click=emit('resourceclick', { resource: c.resource, date: c.iso })>
									if resourceTag
										<{resourceTag} resource=c.resource>
									else
										c.resource.title
							elif resourceTag
								<{resourceTag} resource=c.resource>
							else
								c.resource.title

				for row, r in (rows or [])
					<div.row-label.sticky key="label-{row.key}" data-sticky-row=extraRows[r] style="top: var(--sticky-{extraRows[r]})"> row.label
					for cell in (row.perColumn ? columns : dates.map(do { date: $1, iso: toISODate($1), resource: null }))
						let cellStyle = "{row.perColumn ? '' : 'grid-column: span ' + lanes.length + '; '}top: var(--sticky-{extraRows[r]})"
						if row.clickable
							<div.row-cell.sticky.clickable key="{row.key}-{cell.iso}-{cell.resource..id ?? ''}" style=cellStyle data-sticky-row=extraRows[r] role='button' tabIndex=0
								aria-label="{typeof row.label == 'string' ? row.label : ''} {longDayText(cell.date)}"
								@click=emit('rowclick', { key: row.key, date: cell.iso, resource: cell.resource })
								@keydown.enter.prevent=emit('rowclick', { key: row.key, date: cell.iso, resource: cell.resource })
								@keydown.space.prevent=emit('rowclick', { key: row.key, date: cell.iso, resource: cell.resource })>
								<{row.tag} date=cell.date resource=cell.resource> if row.tag
						else
							<div.row-cell.sticky key="{row.key}-{cell.iso}-{cell.resource..id ?? ''}" style=cellStyle data-sticky-row=extraRows[r]>
								<{row.tag} date=cell.date resource=cell.resource> if row.tag

				if bars.length > 0 or selectable
					# The label opens and closes a folded strip.
					<div.all-day-label.sticky data-sticky-row=allDayRow style="top: var(--sticky-{allDayRow})">
						if laneEnds.length > allDayMax
							<button.fold type='button' aria-expanded=String(allDayOpen) @click=(allDayOpen = !allDayOpen)>
								t.allDay
								<iconify-icon icon=(allDayOpen ? 'lucide:chevron-up' : 'lucide:chevron-down') aria-hidden='true'>
						else
							t.allDay
					<div.all-day.sticky .selectable=selectable data-sticky-row=allDayRow style="--lanes: {Math.max(1, shownLanes + (folding ? 1 : 0))}; top: var(--sticky-{allDayRow})"
						@pointerdown=pressAllDay(e) @contextmenu=allDayContext(e)>
						if p..kind == 'all-day'
							for i in p.columns
								<div.selection.all-day-selection key="sel-{i}" .invalid=!!previewReason style="left: {(i / columns.length) * 100}%; width: {100 / columns.length}%">
						for bar in shownBars
							let color = barColor(bar.event)
							<button.all-day-event key="{bar.event.id}-{bar.first}" type='button' .continued=bar.continued .blocked=!!bar.event.blocked data-color=colorKey(color)
								style="left: {(bar.first / columns.length) * 100}%; width: {(bar.length / columns.length) * 100}%; top: calc({bar.lane} * 1.625rem + 0.25rem){named.includes(color) ? '' : '; --event-color: ' + color}"
								@click=emit('eventclick', bar.event) @contextmenu=eventContext(e, bar.event)>
								if eventTag
									<{eventTag} event=bar.event start=parseLocal(bar.event.start) end=parseLocal(bar.event.end) resource=null compact=yes>
								else
									bar.event.title
						if folding
							for count, i in hidden
								if count > 0
									<button.more key="more-{i}" type='button' @click=(allDayOpen = yes)
										style="left: {(i / columns.length) * 100}%; width: {100 / columns.length}%; top: calc({shownLanes} * 1.625rem + 0.25rem)"> t.more(count)

				<div.gutter aria-hidden='true' style="--hours: {hours.length}">
					for hour in hours
						<span.hour key=hour style="top: {top(hour * 60)}"> hourFormat.format(new Date(2000, 0, 1, hour))
				for column, index in columns
					let selecting = p..kind == 'select' and p.column == index ? p : null
					let placing = p..kind == 'place' and p.column == index ? p : null
					let isToday = sameDay(column.date, now)
					<div.day key="{column.iso}-{column.resource..id ?? ''}" role='gridcell' aria-label="{longDayText(column.date)}{resourceName(column)}"
						.today=isToday .selectable=(selectable or !!pinned) .first=(hasResources and column.resource == lanes[0])
						style="--hours: {hours.length}{column.resource..color ? '; --resource-color: ' + cssColor(column.resource.color) : ''}"
						@pointerdown=pressDay(e, index) @pointermove.silent=hover(e, index) @pointerleave=leaveDay @contextmenu=dayContext(e, column)>
						for run in shading[index]
							<div.unavailable key="off-{run.from}" title=run.reason style="top: {top(run.from)}; height: {length(run.to - run.from)}">
						for item in timedByColumn[index]
							let event = item.event
							let moving = p..kind == 'move' and p.id == event.id ? p : null
							let resizing = p..kind == 'resize' and p.id == event.id ? p : null
							let shownEnd = resizing ? addMinutes(item.end, resizing.minutes) : item.end
							let minutes = minutesBetween(item.start, shownEnd)
							let color = event.color or column.resource..color or 'accent'
							let time = "{timeText(item.start)} – {timeText(shownEnd)}"
							let box = "top: {top(minutesOfDay(item.start))}; left: {(item.column / item.columns) * 100}%; width: {100 / item.columns}%"
							# Where it was, while it's dragged.
							if moving or resizing
								<div.ghost key="ghost-{event.id}" style="{box}; height: {length(minutesBetween(item.start, item.end))}">
							<button.event key="event-{event.id}" type='button' data-event-id=String(event.id) data-color=colorKey(color)
								.dragging=!!(moving or resizing) .invalid=(!!(moving or resizing) and !!previewReason) .editable=canEdit(event)
								.compact=(minutes <= 30) .blocked=!!event.blocked .pending=!!event.pending .being-placed=(pinned..id == event.id)
								aria-label="{nameOf(event)}, {time}" aria-busy=(event.pending ? 'true' : undefined)
								title=((moving or resizing) and previewReason ? previewReason : undefined)
								style="{box}; height: {length(Math.max(slotMinutes, minutes))}{named.includes(color) ? '' : '; --event-color: ' + color}{moving ? '; transform: translate(' + moving.x + 'px, ' + moving.y + 'px)' : ''}"
								@pointerdown=pressEvent(e, index, event) @keydown=eventKeys(e, event) @contextmenu=eventContext(e, event) @click=clickEvent(event)>
								if eventTag
									<{eventTag} event=event start=item.start end=shownEnd resource=column.resource compact=(minutes <= 30)>
								else
									<span.event-title> event.title
									<span.event-time> time
								if canEdit(event) and !pinned
									<span.resize aria-hidden='true' @pointerdown=startGesture(e, 'resize', index, event)>
						if hoverSlot..column == index and !p
							let off = shading[index].find(do hoverSlot.from >= $1.from and hoverSlot.from < $1.to)
							<div.hover .invalid=!!off aria-hidden='true' style="top: {top(hoverSlot.from)}; height: {length(slotMinutes)}">
						if selecting
							<div.selection .invalid=!!previewReason style="top: {top(selecting.from)}; height: {length(selecting.to - selecting.from)}">
								previewReason ?? "{timeText(addMinutes(column.date, selecting.from))} – {timeText(addMinutes(column.date, selecting.to))}"
						if placing and pinned
							<div.selection.placing-selection .invalid=!!previewReason style="top: {top(placing.from)}; height: {length(pinnedMinutes)}">
								previewReason ?? "{nameOf(pinned)}, {timeText(addMinutes(column.date, placing.from))}"
						if isToday and minutesOfDay(now) >= startHour * 60 and minutesOfDay(now) < endHour * 60
							<div.now aria-hidden='true' style="top: {top(minutesOfDay(now))}">

			<{menuTag} items=menuEntries @select.stop=runMenu(e.detail)>
				<span.menu-anchor slot='trigger' aria-hidden='true'>
			<div.status aria-live='polite' role='status'> status
		afterRender!
