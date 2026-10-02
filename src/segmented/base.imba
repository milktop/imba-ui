import * as radio from '@zag-js/radio-group'
import { Machine, uid } from '../zag.imba'
import { closestField, fieldIds } from '../field/base.imba'
import { itemLabel, itemValue } from '../items.imba'

# Headless segmented control: a row of options with an indicator that slides
# to the selected one (Zag's radio group, so arrow keys move the selection).
#
# - `items`: strings or objects (see `labelKey`, `valueKey`, `disabledKey`)
# - `name`: the hidden radios also post with plain forms
#
# Emits `change` with the selected item's original value.
tag ui-segmented-base
	prop label = null
	prop items = []
	prop value = null
	prop labelKey = 'label'
	prop valueKey = 'value'
	prop disabledKey = 'disabled'
	prop name = null
	prop disabled = false

	zagId = uid('segmented')

	# `bind=` targets `data` and `bind:value=` targets `value`. Either way Imba
	# replaces that property with one reading and writing the bound model, so
	# `data` aliases `value` here and the component goes through `data`.
	get data do value
	set data v do value = v

	def key item do String(itemValue(item, valueKey))
	def isDisabled item do typeof item == 'object' and !!item..[disabledKey]

	# Zag's values are strings; map them back to the items' own values.
	def fromKey str
		let item = items.find(do key($1) == str)
		item == undefined ? null : itemValue(item, valueKey)

	def setup
		let initial = data == null ? null : String(data)
		machine = new Machine self, radio.machine, do
			id: zagId
			ids: fieldIds(self)
			name: name
			orientation: 'horizontal'
			disabled: disabled or #locked
			invalid: !!#field..invalid
			defaultValue: initial
			onValueChange: do(details)
				data = fromKey(details.value)
				emit('change', data) if machine.track(data)
		machine.track(data)

	def mount do machine.start!
	def unmount do machine.stop!

	def render
		# Inside a ui-field, it owns the label, hint and error. A disabled
		# fieldset (e.g. ui-fields disabled) disables it, which Zag doesn't track.
		#field = closestField(self)
		#locked = !!closest('fieldset:disabled')
		machine.watch "{#field..stateKey}|{#locked}"

		machine.syncValue data, do
			let api = machine.connect(radio)
			data == null ? api.clearValue! : api.setValue(String(data))

		let api = machine.connect(radio)

		<self>
			if label and !#field..label
				<span.label zag=api.getLabelProps!> label
			<div.group zag=(#field ? #field.describe(api.getRootProps!) : api.getRootProps!)>
				<span.indicator zag=api.getIndicatorProps!>
				for item in items
					let props = { value: key(item), disabled: isDisabled(item) }
					<label.item zag=api.getItemProps(props)>
						<span.item-text zag=api.getItemTextProps(props)> itemLabel(item, labelKey)
						<input zag=api.getItemHiddenInputProps(props) @change.stop>
