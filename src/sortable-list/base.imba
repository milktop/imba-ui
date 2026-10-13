import { uiLocale } from '../locale.imba'
import { uid } from '../zag.imba'
import 'iconify-icon'

# Headless sortable list: rows people put in order by dragging, or with the
# keyboard. Drag a row by its grip; or focus the grip, press Space to pick it
# up, the arrow keys to move it, Space to drop it (Escape puts it back).
# Screen readers hear each step.
#
#   <ui-sortable-list bind=topics itemTag=TopicRow>
#   <ui-sortable-list items=['Warm-up', 'Reading', 'Quiz'] @change=save(e.detail)>
#
# - `items` (`bind=` works): the rows, in order
# - `itemKey`: the property that identifies an item ('id'), or a function;
#   strings and numbers are their own key
# - `itemTag`: a tag rendering a row's content, given `item`, `index` and
#   `dragging`; by default its label (see `itemLabel`)
# - `itemLabel(item)`: what screen readers call an item as it moves ("Picked
#   up Worksheet 4… moved to position 3 of 5"); by default a string item
#   itself, or its `label`, `title` or `name`
# - `handle`: drag by the grip only (default), or false for the whole row
#   (keyboard users then use the row itself, focused)
# - `variant`: 'card' (default: rows in a bordered box) or 'plain' (separate,
#   spaced rows)
# - `disabled`: no reordering; `label`: the list's accessible name
#
# Emits `change` with the reordered items, and `move` with { item, from, to }.
tag ui-sortable-list-base
	prop items = []
	prop itemKey = 'id'
	prop itemTag = null
	prop itemLabel = null
	prop handle = true
	prop variant = 'card'
	prop disabled = false
	prop label = null

	listId = uid('sortable')
	status = ''

	# `bind=` targets `data`, which aliases `items` here.
	get data do items
	set data v do items = v

	get words do uiLocale.messages.sortableList

	def keyOf item
		return itemKey(item) if typeof itemKey == 'function'
		typeof item == 'object' and item ? item[itemKey] : item

	def nameOf item
		return itemLabel(item) if itemLabel
		return String(item) unless typeof item == 'object' and item
		String(item.label ?? item.title ?? item.name ?? keyOf(item))

	def place index, count do words.position(index + 1, count)

	# The rows as shown: while the keyboard moves one, its working order.
	get rows do #working or (data or [])

	def announce text
		# Cleared first, so the same words twice are still read.
		status = ''
		render!
		globalThis.queueMicrotask do
			status = text
			render!

	def commitOrder next, item, from, to
		data = next
		emit('move', { item, from, to })
		emit('change', data)

	# Pointer: a small move before the drag starts, so clicks still work.
	def press e, index
		return if disabled or e.button != 0
		let rowEls = Array.from(querySelectorAll(':scope > .list > .item'))
		#gesture = {
			index, pointer: e.pointerId, startY: e.clientY, dy: 0, started: no
			rects: rowEls.map(do $1.getBoundingClientRect!)
		}
		try e.currentTarget.setPointerCapture(e.pointerId)

	def move e
		let g = #gesture
		return unless g and e.pointerId == g.pointer
		g.dy = e.clientY - g.startY
		g.started = yes if Math.abs(g.dy) > 4
		return unless g.started
		e.preventDefault!
		# Where the dragged row's middle is now, among the others' middles.
		let rects = g.rects
		let middle = rects[g.index].top + rects[g.index].height / 2 + g.dy
		let target = g.index
		for rect, i in rects
			let center = rect.top + rect.height / 2
			target = i if i > g.index and middle > center
			target = Math.min(target, i) if i < g.index and middle < center
		g.target = target
		render!

	def release e
		let g = #gesture
		return unless g and e.pointerId == g.pointer
		#gesture = null
		if g.started and g.target != null and g.target != g.index
			let list = (data or []).slice!
			let [item] = list.splice(g.index, 1)
			list.splice(g.target, 0, item)
			commitOrder(list, item, g.index, g.target)
			announce(words.dropped(nameOf(item), place(g.target, list.length)))
		# A drag isn't a click on the row.
		#suppressClick = g.started
		render!

	def cancelPointer
		#gesture = null
		render!

	def clicked e
		if #suppressClick
			e.stopPropagation!
			e.preventDefault!
		#suppressClick = no

	# The offset a row is drawn at during a pointer drag: the dragged one
	# follows the pointer, the ones it passed make room.
	def offsetOf index
		let g = #gesture
		return 0 unless g and g.started
		return g.dy if index == g.index
		let size = g.rects[g.index].height + gapOf(g)
		let target = g.target ?? g.index
		return -size if index > g.index and index <= target
		return size if index < g.index and index >= target
		0

	def gapOf g
		return 0 unless g.rects.length > 1
		let [a, b] = g.rects
		Math.max(0, b.top - a.bottom)

	# Keyboard: Space picks up and drops, arrows move, Escape cancels.
	def keydown e, index
		return if disabled
		let picked = #picked
		if e.key == ' ' or e.key == 'Enter'
			e.preventDefault!
			if picked == null
				#picked = index
				#from = index
				#working = (data or []).slice!
				announce(words.pickedUp(nameOf(#working[index]), place(index, #working.length)))
				refocus!
			else
				let item = #working[picked]
				let list = #working
				#working = null
				#picked = null
				commitOrder(list, item, #from, picked) if picked != #from
				announce(words.dropped(nameOf(item), place(picked, list.length)))
			return render!
		return if picked == null
		if e.key == 'Escape'
			e.preventDefault!
			let item = #working[picked]
			#working = null
			#picked = null
			announce(words.cancelled(nameOf(item), place(#from, (data or []).length)))
			return render!
		let step = { ArrowUp: -1, ArrowDown: 1 }[e.key]
		return unless step
		e.preventDefault!
		let to = Math.max(0, Math.min(#working.length - 1, picked + step))
		return if to == picked
		let [item] = #working.splice(picked, 1)
		#working.splice(to, 0, item)
		#picked = to
		announce(words.movedTo(nameOf(item), place(to, #working.length)))
		refocus!

	# The picked-up row moved in the DOM, which drops focus; put it back.
	# (Called after rendering here too: a render! of our own skips `rendered`.)
	def rendered do refocus!

	def refocus
		return if #picked == null
		let row = querySelectorAll(':scope > .list > .item')[#picked]
		let target = handle ? row..querySelector('.handle') : row
		target.focus! if target and document.activeElement != target

	def render
		let rows = rows
		let dragging = #gesture..started ? #gesture.index : #picked
		let grabbable = !disabled
		<self .{variant} .disabled=disabled>
			<ul.list aria-label=(label ?? undefined)>
				for item, index in rows
					let offset = offsetOf(index)
					let mine = index == dragging
					<li.item key=keyOf(item) .dragging=mine .shifting=(#gesture..started and !mine) style=(offset ? "transform: translateY({offset}px)" : undefined)
						role=(!handle and grabbable ? 'button' : undefined) tabIndex=(!handle and grabbable ? 0 : undefined)
						aria-describedby=(!handle and grabbable ? "{listId}-help" : undefined) aria-pressed=(!handle and grabbable ? String(mine and #picked != null) : undefined)
						@pointerdown=(handle ? null : press(e, index)) @pointermove.silent=move(e) @pointerup=release(e) @pointercancel=cancelPointer @click.capture=clicked(e)
						@keydown=(handle ? null : keydown(e, index))>
						if handle and grabbable
							<button.handle type='button' aria-label=words.handle aria-describedby="{listId}-help" aria-pressed=String(mine and #picked != null)
								@pointerdown=press(e, index) @keydown=keydown(e, index)>
								<iconify-icon icon='lucide:grip-vertical' aria-hidden='true'>
						<div.content>
							if itemTag
								<{itemTag} item=item index=index dragging=mine>
							else
								nameOf(item)
			<p.sr-only id="{listId}-help"> words.instructions
			<div.sr-only aria-live='assertive' role='status'> status
