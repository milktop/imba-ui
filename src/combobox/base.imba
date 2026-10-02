import * as combobox from '@zag-js/combobox'
import { Machine, uid } from '../zag.imba'
import { icons } from '../icons.imba'
import { itemLabel, itemValue, toCollection, toValueArray } from '../items.imba'

# Headless combobox: a text input that filters a list of options.
#
# - `items`: strings or objects (see `labelKey`, `valueKey`, `disabledKey`)
# - `load`: optional async function(query) returning items, for server search
# - `multiple`: selected items show as removable tags before the input
#
# Emits `change` with the selected value (or array of values when `multiple`),
# using the items' original values rather than Zag's strings.
tag ui-combobox-base
	prop label = null
	prop items = []
	prop value = null
	prop multiple = false
	prop placeholder = ''
	prop emptyText = 'No results'
	prop loadingText = 'Loading…'
	prop labelKey = 'label'
	prop valueKey = 'value'
	prop disabledKey = 'disabled'
	prop load = null
	prop debounce = 200
	prop disabled = false
	prop placement = 'bottom-start'

	zagId = uid('combobox')
	loading = false
	#results = null
	#sourceItems = null
	#collection = null
	#query = 0

	get collection do #collection

	def setResults list
		#results = list
		#collection = toCollection(combobox, list, labelKey, valueKey, disabledKey)

	def filterLocal query
		let q = query.trim!.toLowerCase!
		setResults(q ? items.filter(do itemLabel($1, labelKey).toLowerCase!.includes(q)) : items)

	def search query
		return filterLocal(query) unless load
		let ticket = ++#query
		loading = true
		clearTimeout(#timer)
		#timer = setTimeout(&, debounce) do
			let list = await load(query)
			return unless ticket == #query
			loading = false
			setResults(list or [])
			machine.refresh!

	# `bind=` targets `data` and `bind:value=` targets `value`. Either way Imba
	# replaces that property with one reading and writing the bound model, so
	# `data` aliases `value` here and the component goes through `data`.
	get data do value
	set data v do value = v

	def setup
		#sourceItems = items
		setResults(items)
		let initial = toValueArray(data)
		machine = new Machine self, combobox.machine, do
			id: zagId
			collection: #collection
			multiple: multiple
			disabled: disabled
			placeholder: placeholder
			defaultValue: initial
			openOnClick: true
			inputBehavior: 'autohighlight'
			positioning: { placement, sameWidth: true }
			onInputValueChange: do(details)
				# Swap the collection after Zag finishes this transition, as a
				# framework re-render would; its watcher then re-highlights the
				# first match from the right state.
				globalThis.queueMicrotask do
					# Typing filters; selecting or clearing restores the full list.
					if details.reason == 'input-change'
						search(details.inputValue)
					elif !load
						setResults(items)
					machine.refresh!
			onValueChange: do(details)
				let values = details.items.map(do itemValue($1, valueKey))
				data = multiple ? values : (values[0] ?? null)
				emit('change', data) if machine.track(data)

		machine.track(data)

	def mount do machine.start!
	def unmount do machine.stop!

	def render
		# New items from the parent replace the list (keeping any filter).
		if items !== #sourceItems and !load
			#sourceItems = items
			filterLocal(machine.service.context.get('inputValue') or '')
			machine.refresh!

		machine.syncValue data, do
			machine.connect(combobox).setValue(toValueArray(data))

		let api = machine.connect(combobox)
		let list = #collection.items

		<self zag=api.getRootProps!>
			if label
				<label.label zag=api.getLabelProps!> label
			<div.control zag=api.getControlProps!>
				if multiple
					for item in api.selectedItems
						<span.tag>
							itemLabel(item, labelKey)
							<button.tag-remove type='button' tabIndex=-1 aria-label="Remove {itemLabel(item, labelKey)}" @click.stop=api.clearValue(String(itemValue(item, valueKey)))>
								<ui-icon path=icons.x size=12>
				<input.input zag=api.getInputProps! @change.stop>
				<button.clear zag=api.getClearTriggerProps!> <ui-icon path=icons.x size=14>
				<button.trigger zag=api.getTriggerProps!> <ui-icon path=icons.down>

			<div.positioner zag=api.getPositionerProps!>
				<div.content zag=api.getContentProps!>
					if loading
						<div.status> loadingText
					elif list.length == 0
						<div.status> emptyText
					else
						for item in list
							<div.item zag=api.getItemProps(item: item)>
								<span.item-text zag=api.getItemTextProps(item: item)> itemLabel(item, labelKey)
								<span.item-indicator zag=api.getItemIndicatorProps(item: item)> <ui-icon path=icons.check size=14>
