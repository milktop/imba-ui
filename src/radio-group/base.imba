import * as radio from '@zag-js/radio-group'
import { Machine, uid } from '../zag.imba'
import { closestField, fieldIds } from '../field/base.imba'
import { itemLabel, itemKey, valueForKey, itemDisabled } from '../items.imba'

# Headless radio group: one choice from a list of options, each with an
# optional description (Zag's radio group, so arrow keys move the selection).
#
# - `items`: strings or objects (see `labelKey`, `valueKey`, `disabledKey`,
#   `descriptionKey`)
# - `orientation`: 'vertical' (default) or 'horizontal'
# - `name`: the hidden radios also post with plain forms
#
# Emits `change` with the selected item's original value. For a compact row
# of short options, see ui-segmented.
tag ui-radio-group-base
	prop label = null
	prop items = []
	prop value = null
	prop labelKey = 'label'
	prop valueKey = 'value'
	prop disabledKey = 'disabled'
	prop descriptionKey = 'description'
	prop orientation = 'vertical'
	prop name = null
	prop disabled = false

	zagId = uid('radio-group')

	# `bind=` targets `data` and `bind:value=` targets `value`. Either way Imba
	# replaces that property with one reading and writing the bound model, so
	# `data` aliases `value` here and the component goes through `data`.
	get data do value
	set data v do value = v

	def description item
		typeof item == 'object' and item ? item[descriptionKey] : null

	def descriptionId item do "{zagId}-{itemKey(item, valueKey)}-description"

	def setup
		let initial = data == null ? null : String(data)
		machine = new Machine self, radio.machine, do
			id: zagId
			ids: fieldIds(self)
			name: name
			orientation: orientation
			disabled: disabled or #locked
			invalid: !!#field..invalid
			defaultValue: initial
			onValueChange: do(details)
				# Zag's values are strings; map them back to the items' own values.
				data = valueForKey(items, details.value, valueKey)
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
				for item in items
					let props = { value: itemKey(item, valueKey), disabled: itemDisabled(item, disabledKey) }
					let about = description(item)
					<label.item zag=api.getItemProps(props)>
						<span.control zag=api.getItemControlProps(props)>
						<span.text>
							<span.item-text zag=api.getItemTextProps(props)> itemLabel(item, labelKey)
							if about
								<span.description id=descriptionId(item)> about
						<input zag=Object.assign({}, api.getItemHiddenInputProps(props), 'aria-describedby': about ? descriptionId(item) : undefined) @change.stop>
