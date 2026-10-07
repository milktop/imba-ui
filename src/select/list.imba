import * as select from '@zag-js/select'
import { Machine, uid } from '../zag.imba'
import { fieldIds } from '../control.imba'
import { icons } from '../icons.imba'
import { itemLabel, itemValue, toValueArray } from '../items.imba'

# ui-select without search: a button that opens the list (Zag's select).
# ui-select renders it and documents the props.
tag ui-list-select-base < ui-control
	prop label = null
	prop items = []
	prop value = null
	prop multiple = false
	prop tags = false
	prop variant = 'subtle'
	prop hideSelected = false
	prop deselectable = false
	prop closeOnSelect = null
	prop placeholder = null
	prop emptyText = 'No matches'
	prop labelKey = 'label'
	prop valueKey = 'value'
	prop disabledKey = 'disabled'
	prop name = null
	prop clearable = false
	prop disabled = false
	prop placement = 'bottom-start'
	prop size = 'md'
	prop itemTag = null
	prop emptyTag = null

	zagId = uid('select')
	#collection = null
	#collectionKey = null

	def keyOf item do String(itemValue(item, valueKey))
	get selectedKeys do toValueArray(data)
	def isSelected item do selectedKeys.includes(keyOf(item))
	# With hideSelected the picked items aren't rendered, but stay in Zag's
	# collection (for their labels), disabled so the keys skip them.
	def hidden item do hideSelected and multiple and isSelected(item)
	get listed do (items or []).filter(do !hidden($1))

	# A new collection when the items or what's hidden change.
	def updateCollection
		let key = (items or []).map(do "{keyOf($1)}:{hidden($1)}").join('\n')
		return if key == #collectionKey and #sourceItems === items
		#collectionKey = key
		#sourceItems = items
		#collection = select.collection
			items: items or []
			itemToString: do(item) itemLabel(item, labelKey)
			itemToValue: do(item) keyOf(item)
			isItemDisabled: do(item) hidden(item) or (typeof item == 'object' and !!item..[disabledKey])
		machine..refresh!

	def setup
		updateCollection!
		let initial = toValueArray(data)
		machine = new Machine self, select.machine, do
			id: zagId
			collection: #collection
			multiple: multiple
			deselectable: deselectable
			closeOnSelect: closeOnSelect ?? !multiple
			disabled: disabled or #locked
			invalid: !!#field..invalid
			ids: fieldIds(self)
			name: name
			defaultValue: initial
			positioning: { placement }
			onValueChange: do(details)
				let values = details.items.map(do itemValue($1, valueKey))
				keepPlace(details.value) if multiple
				data = multiple ? values : (values[0] ?? null)
				emit('change', data) if machine.track(data)

		machine.track(data)

	def mount do machine.start!
	def unmount do machine.stop!

	# Picking several: the highlight stays where it was (on the next item, when
	# the picked one leaves the list), so Enter can pick a run of them.
	def keepPlace next
		let before = selectedKeys
		let key = next.find(do !before.includes($1)) ?? before.find(do !next.includes($1))
		let at = listed.findIndex(do keyOf($1) == key)
		return if at < 0
		setTimeout(&, 30) do
			let list = listed
			let item = list[Math.min(at, list.length - 1)]
			let api = machine.connect(select)
			api.setHighlightValue(keyOf(item)) if item and api.open

	# Backspace on the closed button removes the last pick.
	def removeLast e
		let api = machine.connect(select)
		return unless e.key == 'Backspace' and multiple and !api.open and selectedKeys.length
		e.preventDefault!
		api.clearValue(selectedKeys[selectedKeys.length - 1])

	def render
		updateCollection!
		connectField!
		machine.syncValue data, do
			machine.connect(select).setValue(toValueArray(data))

		let api = machine.connect(select)
		let list = listed

		<self .{size} .{variant} data-ui-select-list zag=api.getRootProps!>
			if label and !#field..label
				<label.label zag=api.getLabelProps!> label
			<div.control zag=api.getControlProps!>
				<button.trigger zag=describe(api.getTriggerProps!) @keydown=removeLast(e)>
					if multiple and tags and api.hasSelectedItems
						# Chips, not buttons (a button can't hold buttons): untick an item to remove it.
						<span.tags> for picked in api.selectedItems
							<span.tag> <span.tag-text> itemLabel(picked, labelKey)
					else
						<span.value-text .placeholder=api.empty zag=api.getValueTextProps!>
							api.empty ? (placeholder ?? 'Select…') : api.valueAsString
					<span.indicator zag=api.getIndicatorProps!> <ui-icon path=icons.down>
				if clearable
					<button.clear zag=api.getClearTriggerProps!> <ui-icon path=icons.x size=14>

			if name
				<select zag=api.getHiddenSelectProps! @change.stop>
					for item in (items or [])
						<option value=keyOf(item)> itemLabel(item, labelKey)

			<div.positioner zag=api.getPositionerProps!>
				<ul.content zag=api.getContentProps!>
					for item in list
						<li.item key=keyOf(item) zag=api.getItemProps(item: item)>
							<span.item-text zag=api.getItemTextProps(item: item)>
								if itemTag
									<{itemTag} item=item>
								else
									itemLabel(item, labelKey)
							<span.item-indicator zag=api.getItemIndicatorProps(item: item)> <ui-icon path=icons.check size=14>
					if !list.length
						<li.empty>
							if emptyTag
								<{emptyTag} query=''>
							else
								emptyText
