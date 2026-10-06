import * as radio from '@zag-js/radio-group'
import { Machine, uid } from '../zag.imba'
import { fieldIds } from '../control.imba'
import { itemLabel, itemKey, valueForKey, itemDisabled } from '../items.imba'
import '../tooltip/base.imba'
import 'iconify-icon'

# Headless segmented control: a row of options with an indicator that slides
# to the selected one (Zag's radio group, so arrow keys move the selection).
#
# - `items`: strings or objects (see `labelKey`, `valueKey`, `disabledKey`)
# - `name`: the hidden radios also post with plain forms
# - an item's `icon` (Iconify) shows before its label; `iconOnly` keeps the
#   labels for assistive tech but shows just the icons
# - `size`: 'sm', 'md' (default, matching the inputs' height) or 'lg'
# - `tooltips`: shows each item's label (or its `tooltip`) in a tooltip on
#   hover and keyboard focus; on by default with `iconOnly`
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
	prop tooltips = null
	prop size = 'md'

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

	get withTooltips do tooltips === null ? iconOnly : tooltips

	# The focusable element is the hidden radio, inside the tooltip's trigger,
	# so keyboard focus opens the tooltip by hand. Pointer focus doesn't
	# (a click already closes it).
	def tipFocus e, open
		let tip = e.target.closest('label')..querySelector('ui-tooltip')
		return unless tip
		if open and e.target.matches(':focus-visible') then tip.show! else tip.hide!

	def render
		connectField!

		machine.syncValue data, do
			let api = machine.connect(radio)
			data == null ? api.clearValue! : api.setValue(String(data))

		let api = machine.connect(radio)

		<self .{size}>
			if label and !#field..label
				<span.label zag=api.getLabelProps!> label
			<div.group zag=describe(api.getRootProps!)>
				<span.indicator zag=api.getIndicatorProps!>
				for item in items
					let props = { value: itemKey(item, valueKey), disabled: itemDisabled(item, disabledKey) }
					let text = itemLabel(item, labelKey)
					<label.item .icon-only=iconOnly .tipped=withTooltips zag=api.getItemProps(props)>
						# Zag's tooltip props go on a wrapper of their own, since the item's
						# carry its id and data-state.
						if withTooltips
							<ui-tooltip content=(item..tooltip or text)>
								<span.item-tip>
									<span.item-text zag=api.getItemTextProps(props)>
										<iconify-icon.item-icon icon=item.icon aria-hidden='true'> if item..icon
										<span.item-label .visually-hidden=iconOnly> text
						else
							<span.item-text zag=api.getItemTextProps(props)>
								<iconify-icon.item-icon icon=item.icon aria-hidden='true'> if item..icon
								<span.item-label .visually-hidden=iconOnly> text
						<input zag=api.getItemHiddenInputProps(props) @change.stop @focus=tipFocus(e, yes) @blur=tipFocus(e, no)>
