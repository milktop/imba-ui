import * as zagSwitch from '@zag-js/switch'
import { Machine, uid } from '../zag.imba'
import '../control.imba'

# Headless switch: an on/off track and thumb with its label, and a visually
# hidden native checkbox for keyboard, forms and assistive tech.
#
# Like ui-checkbox, the bound value is `checked` (`bind=` or `bind:checked=`)
# and `value` is what a form submits. Emits `change` with the new state.
tag ui-switch-base < ui-control
	prop label = null
	prop checked = false
	prop value = 'on'
	prop name = null
	prop required = false
	prop disabled = false

	zagId = uid('switch')

	# `bind=` targets `data`, which aliases `checked` here.
	get data do checked
	set data v do checked = v

	def setup
		let initial = !!data
		machine = new Machine self, zagSwitch.machine, do
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

		# Not api.setChecked, which also fakes a click on the hidden input.
		machine.syncValue data, do
			machine.service.send(type: 'CHECKED.SET', checked: !!data, isTrusted: true)

		let api = machine.connect(zagSwitch)

		<self>
			<label.root zag=api.getRootProps!>
				<span.control zag=api.getControlProps!>
					<span.thumb zag=api.getThumbProps!>
				if label
					<span.label zag=api.getLabelProps!> label
				<input zag=describe(api.getHiddenInputProps!) @change.stop>
