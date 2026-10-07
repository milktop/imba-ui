import * as combobox from '@zag-js/combobox'
import { Machine, uid } from '../zag.imba'
import { fieldIds } from '../control.imba'
import { icons } from '../icons.imba'
import { itemLabel, itemValue, toValueArray } from '../items.imba'
import 'iconify-icon'

# The key of the "Create …" option, which no item's can match.
const CREATE = '__ui-select-create__'

# ui-select with search: an input that filters the list, loads it from a
# server, or creates items (Zag's combobox). ui-select renders it and
# documents the props.
tag ui-search-select-base < ui-control
	prop label = null
	prop items = []
	prop value = null
	prop multiple = false
	prop variant = 'subtle'
	prop hideSelected = false
	prop closeOnSelect = null
	prop placeholder = null
	prop emptyText = 'No matches'
	prop loadingText = 'Loading…'
	prop labelKey = 'label'
	prop valueKey = 'value'
	prop disabledKey = 'disabled'
	prop load = null
	prop debounce = 200
	prop oncreate = null
	prop name = null
	prop clearable = false
	prop disabled = false
	prop placement = 'bottom-start'
	prop size = 'md'
	prop itemTag = null
	prop createTag = null
	prop emptyTag = null

	zagId = uid('select')
	# What's been typed (not the picked item's label), filtering the list.
	query = ''
	loading = no
	#loaded = []
	# Items found by `load` or made by `oncreate`, so picked ones keep their labels.
	#seen = []
	#created = []
	#ticket = 0
	#collection = null
	#collectionKey = null

	def keyOf item do String(itemValue(item, valueKey))
	def labelOf item do itemLabel(item, labelKey)
	get pool do [...(load ? #seen : (items or [])), ...#created]
	def byKey key do pool.find(do keyOf($1) == key)
	get selectedKeys do toValueArray(data)
	def isSelected item do selectedKeys.includes(keyOf(item))
	get picked do multiple ? selectedKeys.map(do byKey($1)).filter(do $1 !== undefined) : []

	# Labels starting with the text first, then those containing it; with
	# `load`, what the server sent.
	get shown
		return (loading ? [] : #loaded) if load
		let q = query.toLowerCase!
		let list = items or []
		return list unless q
		let starts = list.filter(do labelOf($1).toLowerCase!.startsWith(q))
		[...starts, ...list.filter(do !starts.includes($1) and labelOf($1).toLowerCase!.includes(q))]

	get listed do hideSelected and multiple ? shown.filter(do !isSelected($1)) : shown

	# The selected items the list doesn't show (left out by a search or
	# hideSelected). Zag still needs them for their labels, so they stay in
	# its collection, disabled so the keys skip them, but unrendered.
	get offList
		let list = listed
		selectedKeys.filter(do(key) !list.some(do keyOf($1) == key)).map(do byKey($1)).filter(do $1 !== undefined)

	# The "Create …" option: for typed text that matches no item.
	get typed do query.trim!
	get creating
		return null unless oncreate and typed and !loading
		return null if pool.some(do labelOf($1).toLowerCase! == typed.toLowerCase!)
		{ __create: yes, label: typed }

	def updateCollection
		let off = offList
		let create = creating
		let all = [...listed, ...(create ? [create] : []), ...off]
		let key = all.map(do $1.__create ? CREATE : "{keyOf($1)}:{off.includes($1)}").join('\n')
		return if key == #collectionKey
		#collectionKey = key
		#collection = combobox.collection
			items: all
			itemToString: do(item) item.__create ? item.label : labelOf(item)
			itemToValue: do(item) item.__create ? CREATE : keyOf(item)
			isItemDisabled: do(item) off.includes(item) or (typeof item == 'object' and !item.__create and !!item..[disabledKey])
		machine..refresh!

	# With `load`, the server filters: ask it (debounced), keeping only the latest answer.
	def search text
		query = text
		return unless load
		let ticket = ++#ticket
		loading = yes
		clearTimeout(#timer)
		#timer = setTimeout(&, debounce) do
			let list = (await load(text)) or []
			return unless ticket == #ticket
			#loaded = list
			#seen = [...#seen.filter(do(item) !list.some(do keyOf($1) == keyOf(item))), ...list]
			loading = no
			render!

	def setup
		search('') if load
		updateCollection!
		let initial = toValueArray(data)
		machine = new Machine self, combobox.machine, do
			id: zagId
			collection: #collection
			multiple: multiple
			closeOnSelect: closeOnSelect ?? !multiple
			selectionBehavior: multiple ? 'clear' : 'replace'
			disabled: disabled or #locked
			invalid: !!#field..invalid
			ids: fieldIds(self)
			name: name
			placeholder: placeholder ?? 'Search…'
			defaultValue: initial
			openOnClick: true
			inputBehavior: 'autohighlight'
			positioning: { placement, sameWidth: true }
			# Typing filters; a pick resets the filter (the server's results
			# stay, so the picked item keeps its place). After Zag finishes this
			# transition, as a framework re-render would.
			onInputValueChange: do(details)
				globalThis.queueMicrotask do
					if details.reason == 'input-change'
						# Emptying the input clears a single pick; partial edits revert on blur.
						machine.connect(combobox).clearValue! if !details.inputValue and !multiple and selectedKeys.length
						search(details.inputValue)
					elif !load or details.reason == 'clear-trigger'
						query = ''
					render!
			onValueChange: do(details)
				return createFrom(typed) if details.value.includes(CREATE)
				let values = details.value.map(do byKey($1)).filter(do $1 !== undefined).map(do itemValue($1, valueKey))
				keepPlace(details.value) if multiple
				data = multiple ? values : (values[0] ?? null)
				emit('change', data) if machine.track(data)

		machine.track(data)

	def mount do machine.start!
	def unmount
		clearTimeout(#timer)
		machine.stop!

	# Hands the typed text to `oncreate`; what it returns (or resolves to) is
	# added and selected.
	def createFrom text
		query = ''
		let made = await oncreate(text)
		let api = machine.connect(combobox)
		if made != null
			#created = [...#created, made]
			data = multiple ? [...(data or []), itemValue(made, valueKey)] : itemValue(made, valueKey)
			emit('change', data)
			api.setInputValue(multiple ? '' : labelOf(made))
		else
			api.setInputValue(multiple ? '' : (selectedKeys.length ? labelOf(byKey(selectedKeys[0]) ?? '') : ''))
		render!

	# Picking several: the highlight stays where it was (on the next item, when
	# the picked one leaves the list), so Enter can pick a run of them. Not
	# after a search, which the pick clears. Zag only acts on Enter once the
	# keys have moved the highlight, so it moves there the way they would.
	def keepPlace next
		let before = selectedKeys
		let key = next.find(do !before.includes($1)) ?? before.find(do !next.includes($1))
		let at = listed.findIndex(do keyOf($1) == key)
		return if at < 0 or query
		setTimeout(&, 30) do
			let list = listed
			let n = Math.min(at, list.length - 1)
			let api = machine.connect(combobox)
			return if n < 0 or !api.open
			api.setHighlightValue(keyOf(list[n - 1])) if n > 0
			$input..dispatchEvent(new KeyboardEvent('keydown', key: (n > 0 ? 'ArrowDown' : 'Home'), bubbles: yes))

	# Backspace in an empty input removes the last pick.
	def removeLast e
		return unless e.key == 'Backspace' and multiple and !e.target.value and selectedKeys.length
		machine.connect(combobox).clearValue(selectedKeys[selectedKeys.length - 1])

	# A click on the box (around the tags, not on a button) types into the input.
	def focusInput e
		return if e.target.closest('button, input')
		e.preventDefault!
		$input..focus!

	# Zag reverts stray text only while the list is open; when focus leaves
	# the whole select, put the selected item's label back (or nothing). An
	# emptied input has already cleared the pick (see onInputValueChange).
	def revert e
		return if contains(e.relatedTarget)
		let text = multiple ? '' : (selectedKeys.length ? labelOf(byKey(selectedKeys[0]) ?? '') : '')
		# After Zag has handled the blur (closing the list, if a search left it open).
		setTimeout(&, 0) do
			return if contains(globalThis.document.activeElement)
			let api = machine.connect(combobox)
			api.setInputValue(text) if api.inputValue != text
			query = ''

	def render
		# New items from the parent are filtered like the old ones.
		updateCollection!
		connectField!
		machine.syncValue data, do
			machine.connect(combobox).setValue(toValueArray(data))

		let api = machine.connect(combobox)
		let list = listed
		let tags = picked
		let create = creating

		<self .{size} .{variant} data-ui-select-list zag=api.getRootProps! @focusout=revert(e)>
			if label and !#field..label
				<label.label zag=api.getLabelProps!> label
			<div.control zag=api.getControlProps! @mousedown=focusInput(e)>
				# Tags and the input wrap together; the buttons keep their own column.
				<div.tags>
					for item in tags
						<span.tag key=keyOf(item)>
							<span.tag-text> labelOf(item)
							<button.tag-remove type='button' tabIndex=-1 aria-label="Remove {labelOf(item)}" @click.stop=api.clearValue(keyOf(item))>
								<ui-icon path=icons.x size=12>
					<input$input.input zag=describe(api.getInputProps!) placeholder=(tags.length ? '' : (placeholder ?? 'Search…')) @keydown=removeLast(e) @change.stop>
				if clearable
					<button.clear zag=api.getClearTriggerProps!> <ui-icon path=icons.x size=14>
				<button.trigger zag=api.getTriggerProps!> <ui-icon path=icons.down>

			<div.positioner zag=api.getPositionerProps!>
				<ul.content zag=api.getContentProps!>
					for item in list
						<li.item key=keyOf(item) zag=api.getItemProps(item: item)>
							<span.item-text zag=api.getItemTextProps(item: item)>
								if itemTag
									<{itemTag} item=item>
								else
									labelOf(item)
							<span.item-indicator zag=api.getItemIndicatorProps(item: item)> <ui-icon path=icons.check size=14>
					if !list.length and !create
						<li.empty>
							if loading
								loadingText
							elif emptyTag
								<{emptyTag} query=typed>
							else
								emptyText
					if create
						<li.create zag=api.getItemProps(item: create)>
							if createTag
								<{createTag} query=create.label>
							else
								<iconify-icon icon='lucide:plus' aria-hidden='true'>
								<span> "Create “{create.label}”"
