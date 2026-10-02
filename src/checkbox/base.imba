import * as checkbox from '@zag-js/checkbox'
import { Machine, uid } from '../zag.imba'
import '../control.imba'
import { icons } from '../icons.imba'

# Headless checkbox: a box and its label, with a visually hidden native input
# for keyboard, forms (`name`, `value`) and assistive tech.
#
# - `checked`: true, false or 'indeterminate'
#
# As with native checkboxes, the bound value is `checked` (`bind=` or
# `bind:checked=`); `value` is what a form submits. Emits `change` with the
# new checked state.
tag ui-checkbox-base < ui-control
	prop label = null
	prop checked = false
	prop value = 'on'
	prop name = null
	prop required = false
	prop disabled = false

	zagId = uid('checkbox')

	# `bind=` targets `data`, which aliases `checked` here.
	get data do checked
	set data v do checked = v

	def setup
		let initial = data
		machine = new Machine self, checkbox.machine, do
			id: zagId
			name: name
			value: value
			required: required
			disabled: disabled or #locked
			invalid: !!#field..invalid
			defaultChecked: initial
			onCheckedChange: do(details)
				data = details.checked
				emit('change', data) if machine.track(data)
		machine.track(data)

	def mount do machine.start!
	def unmount do machine.stop!

	def render
		connectField!

		# Not api.setChecked: for outside changes Zag also fakes a click on the
		# hidden input, which turns 'indeterminate' into false (and emits it).
		machine.syncValue data, do
			machine.service.send(type: 'CHECKED.SET', checked: data, isTrusted: true)

		let api = machine.connect(checkbox)

		<self>
			<label.root zag=api.getRootProps!>
				<span.control zag=api.getControlProps!>
					<span.indicator zag=api.getIndicatorProps!>
						<ui-icon path=(api.indeterminate ? icons.minus : icons.check) size=12>
				if label
					<span.label zag=api.getLabelProps!> label
				<input zag=describe(api.getHiddenInputProps!) @change.stop>
