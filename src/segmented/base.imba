import * as radio from '@zag-js/radio-group'
import { Machine, uid } from '../zag.imba'
import { fieldIds } from '../control.imba'
import { itemLabel, itemKey, valueForKey, itemDisabled } from '../items.imba'
import 'iconify-icon'

# Headless segmented control: a row of options with an indicator that slides
# to the selected one (Zag's radio group, so arrow keys move the selection).
#
# - `items`: strings or objects (see `labelKey`, `valueKey`, `disabledKey`)
# - `name`: the hidden radios also post with plain forms
# - an item's `icon` (Iconify) shows before its label; `iconOnly` keeps the
#   labels for assistive tech but shows just the icons
#
# Emits `change` with the selected item's original value.
tag ui-segmented-base < ui-control
	prop label = null
	prop items = []
	prop value = null
	prop labelKey = 'label'
	prop valueKey = 'value'
	prop disabledKey = 'disabled'
	prop name = null
	prop disabled = false
	prop iconOnly = false

	zagId = uid('segmented')


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
				# Zag's values are strings; map them back to the items' own values.
				data = valueForKey(items, details.value, valueKey)
				emit('change', data) if machine.track(data)
		machine.track(data)

	def mount do machine.start!
	def unmount do machine.stop!

	def render
		connectField!

		machine.syncValue data, do
			let api = machine.connect(radio)
			data == null ? api.clearValue! : api.setValue(String(data))

		let api = machine.connect(radio)

		<self>
			if label and !#field..label
				<span.label zag=api.getLabelProps!> label
			<div.group zag=describe(api.getRootProps!)>
				<span.indicator zag=api.getIndicatorProps!>
				for item in items
					let props = { value: itemKey(item, valueKey), disabled: itemDisabled(item, disabledKey) }
					<label.item .icon-only=iconOnly zag=api.getItemProps(props)>
						<span.item-text zag=api.getItemTextProps(props)>
							<iconify-icon.item-icon icon=item.icon aria-hidden='true'> if item..icon
							<span.item-label .visually-hidden=iconOnly> itemLabel(item, labelKey)
						<input zag=api.getItemHiddenInputProps(props) @change.stop>
