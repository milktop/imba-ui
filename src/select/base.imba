import * as select from '@zag-js/select'
import { Machine, uid } from '../zag.imba'
import { fieldIds } from '../control.imba'
import { icons } from '../icons.imba'
import { itemLabel, itemValue, toCollection, toValueArray } from '../items.imba'

# Headless select: a button that opens a list of options, with typeahead.
#
# - `items`: strings or objects (see `labelKey`, `valueKey`, `disabledKey`)
# - `name`: also renders a hidden native <select> so plain form posts work
#
# Emits `change` with the selected value (or array of values when `multiple`),
# using the items' original values rather than Zag's strings.
tag ui-select-base < ui-control
	prop label = null
	prop items = []
	prop value = null
	prop multiple = false
	prop placeholder = 'Select…'
	prop labelKey = 'label'
	prop valueKey = 'value'
	prop disabledKey = 'disabled'
	prop name = null
	prop clearable = false
	prop disabled = false
	prop placement = 'bottom-start'

	zagId = uid('select')
	#sourceItems = null
	#collection = null

	def setup
		#sourceItems = items
		#collection = toCollection(select, items, labelKey, valueKey, disabledKey)
		let initial = toValueArray(data)
		machine = new Machine self, select.machine, do
			id: zagId
			collection: #collection
			multiple: multiple
			disabled: disabled or #locked
			invalid: !!#field..invalid
			ids: fieldIds(self)
			name: name
			defaultValue: initial
			positioning: { placement, sameWidth: true }
			onValueChange: do(details)
				let values = details.items.map(do itemValue($1, valueKey))
				data = multiple ? values : (values[0] ?? null)
				emit('change', data) if machine.track(data)

		machine.track(data)

	def mount do machine.start!
	def unmount do machine.stop!

	def render
		if items !== #sourceItems
			#sourceItems = items
			#collection = toCollection(select, items, labelKey, valueKey, disabledKey)
			machine.refresh!

		connectField!
		machine.syncValue data, do
			machine.connect(select).setValue(toValueArray(data))

		let api = machine.connect(select)

		<self zag=api.getRootProps!>
			if label and !#field..label
				<label.label zag=api.getLabelProps!> label
			<div.control zag=api.getControlProps!>
				<button.trigger zag=describe(api.getTriggerProps!)>
					<span.value-text .placeholder=api.empty zag=api.getValueTextProps!>
						api.empty ? placeholder : api.valueAsString
					<span.indicator zag=api.getIndicatorProps!> <ui-icon path=icons.down>
				if clearable
					<button.clear zag=api.getClearTriggerProps!> <ui-icon path=icons.x size=14>

			if name
				<select zag=api.getHiddenSelectProps! @change.stop>
					for item in #collection.items
						<option value=String(itemValue(item, valueKey))> itemLabel(item, labelKey)

			<div.positioner zag=api.getPositionerProps!>
				<ul.content zag=api.getContentProps!>
					for item in #collection.items
						<li.item zag=api.getItemProps(item: item)>
							<span.item-text zag=api.getItemTextProps(item: item)> itemLabel(item, labelKey)
							<span.item-indicator zag=api.getItemIndicatorProps(item: item)> <ui-icon path=icons.check size=14>
