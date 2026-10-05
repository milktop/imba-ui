import * as numberInput from '@zag-js/number-input'
import { Machine, uid, defined } from '../zag.imba'
import { fieldIds } from '../control.imba'
import { icons } from '../icons.imba'
import 'iconify-icon'

# Headless number input: a text input with decrement/increment buttons,
# arrow-key and Shift stepping, clamping to `min`/`max` on blur, and
# locale-aware formatting (`formatOptions`, e.g. { style: 'currency', currency: 'GBP' }).
#
# - `icon`, `prefix`, `suffix`: as on ui-input
# - `allowMouseWheel`: scroll over the focused input to step
# - `steppers`: false hides the buttons for narrow spaces (keys still step)
#
# The value is a number (or null when empty). It updates while typing, so a
# binding stays live; `change` is emitted on commit (blur or Enter), as with
# native inputs.
tag ui-number-input-base < ui-control
	prop label = null
	prop value = null
	prop min = null
	prop max = null
	prop step = null
	prop formatOptions = null
	prop locale = 'en-GB'
	prop name = null
	prop placeholder = null
	prop icon = null
	prop suffix = null
	prop required = false
	prop disabled = false
	prop allowMouseWheel = false
	prop steppers = yes

	zagId = uid('number-input')

	# `prefix` is a read-only DOM property (a namespace prefix), so a `prop`
	# can't assign it; an accessor of our own can.
	get prefix do #prefix
	set prefix v do #prefix = v

	def toNumber n
		Number.isNaN(n) ? null : n

	# After each change Zag puts the caret back with setSelectionRange, mapping
	# its old position onto the new value, so a step can leave it mid-number
	# ("1|" becomes "1|.5"). From a step (keys, buttons, wheel) until the next
	# typing, those calls go to the end instead; typing keeps Zag's mapping.
	def startStep do #stepping = yes
	def stepKey e
		startStep! if ['ArrowUp', 'ArrowDown', 'PageUp', 'PageDown'].includes(e.key)

	def rendered
		let el = $input
		return if !el or #caretInput == el
		#caretInput = el
		let setRange = el.setSelectionRange
		el.setSelectionRange = do(start, end, direction)
			start = end = el.value.length if #stepping
			setRange.call(el, start, end, direction)

	def setup
		let initial = data == null ? '' : String(data)
		#emitted = initial
		machine = new Machine self, numberInput.machine, do defined({
			id: zagId
			ids: fieldIds(self)
			defaultValue: initial
			min, max, step, formatOptions, locale, name, placeholder, allowMouseWheel
			required: required
			disabled: disabled or #locked
			# Left unset, Zag marks out-of-range values invalid itself, but it
			# counts an empty input as out of range too; empty isn't invalid.
			invalid: #field..invalid or (data == null ? false : undefined)
			onValueChange: do(details)
				data = toNumber(details.valueAsNumber)
				machine.track(data)
			onValueCommit: do(details)
				let key = machine.valueKey(data)
				return if key == #emitted
				#emitted = key
				emit('change', data)
		})
		machine.track(data)

	def mount do machine.start!
	def unmount do machine.stop!

	def render
		# Inside a ui-field it owns the label, hint and error; empty vs filled
		# also matters, as `invalid` depends on it.
		connectField(data == null)

		machine.syncValue data, do
			#emitted = machine.valueKey(data)
			let api = machine.connect(numberInput)
			data == null ? api.clearValue! : api.setValue(data)

		let api = machine.connect(numberInput)

		<self zag=api.getRootProps!>
			if label and !#field..label
				<label.label zag=api.getLabelProps!> label
			<div.control zag=api.getControlProps!>
				if icon
					<span.affix.start> <iconify-icon icon=icon>
				if prefix
					<span.affix.start> prefix
				<input$input.input zag=describe(api.getInputProps!) @keydown.capture=stepKey @wheel.capture=startStep @beforeinput=(#stepping = no) @change.stop>
				# The suffix and buttons sit together at the end.
				<div.end>
					if suffix
						<span.affix> suffix
					if steppers
						<button.step zag=api.getDecrementTriggerProps! @pointerdown.capture=startStep> <ui-icon path=icons.minus size=14>
						<button.step zag=api.getIncrementTriggerProps! @pointerdown.capture=startStep> <ui-icon path=icons.plus size=14>
