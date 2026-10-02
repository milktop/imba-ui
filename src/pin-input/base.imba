import * as zagPin from '@zag-js/pin-input'
import { Machine, uid, defined } from '../zag.imba'
import { fieldIds } from '../control.imba'

# Headless pin input: one box per character, for verification and booking
# codes. Typing moves to the next box, Backspace to the previous one, and
# pasting fills them all.
#
# - `length`: number of boxes (default 4)
# - `type`: 'numeric' (default), 'alphanumeric' or 'alphabetic'
# - `mask`: hide the characters, like a password
# - `otp`: let browsers offer one-time codes from messages
#
# The value is a string. `change` is emitted with it; `complete` once every
# box is filled.
tag ui-pin-input-base < ui-control
	prop label = null
	prop value = ''
	prop length = 4
	prop type = 'numeric'
	prop mask = false
	prop otp = false
	prop placeholder = '○'
	prop name = null
	prop disabled = false

	zagId = uid('pin')

	def chars value do String(value or '').split('').slice(0, length)

	def setup
		let initial = chars(data)
		machine = new Machine self, zagPin.machine, do defined({
			id: zagId
			ids: fieldIds(self)
			count: length
			type: type
			mask: mask
			otp: otp
			placeholder: placeholder
			name: name
			disabled: disabled or #locked
			invalid: !!#field..invalid
			defaultValue: initial
			onValueChange: do(details)
				data = details.valueAsString
				emit('change', data) if machine.track(data)
			onValueComplete: do(details)
				emit('complete', details.valueAsString)
		})
		machine.track(String(data or ''))

	def mount do machine.start!
	def unmount do machine.stop!

	def render
		connectField!

		machine.syncValue String(data or ''), do
			let api = machine.connect(zagPin)
			data ? api.setValue(chars(data)) : api.clearValue!

		let api = machine.connect(zagPin)

		<self zag=api.getRootProps!>
			if label and !#field..label
				<label.label zag=api.getLabelProps!> label
			<div.control zag=api.getControlProps!>
				for i in [0 ... length]
					<input.box zag=describe(api.getInputProps(index: i)) @change.stop>
			<input zag=api.getHiddenInputProps! @change.stop>
