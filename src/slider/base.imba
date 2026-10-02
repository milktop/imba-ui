import * as zagSlider from '@zag-js/slider'
import { Machine, uid, defined } from '../zag.imba'
import { closestField, fieldIds } from '../field/base.imba'

# Headless slider. Give it an array value for a range (two thumbs).
#
# - `min`, `max`, `step`: as on a range input (defaults 0, 100, 1)
# - `marks`: values (or { value, label }) shown as ticks under the track
# - `showValue`: shows the value, formatted with `formatOptions` and `locale`
#
# Arrow keys step (Page Up/Down and Shift step by 10), Home/End jump to the
# ends. The value (a number, or [from, to]) updates while dragging, so a
# binding stays live; `change` is emitted when the drag or key press ends.
tag ui-slider-base
	prop label = null
	prop value = null
	prop min = 0
	prop max = 100
	prop step = 1
	prop marks = null
	prop showValue = false
	prop formatOptions = null
	prop locale = 'en-GB'
	prop name = null
	prop disabled = false

	zagId = uid('slider')

	# `bind=` targets `data` and `bind:value=` targets `value`. Either way Imba
	# replaces that property with one reading and writing the bound model, so
	# `data` aliases `value` here and the component goes through `data`.
	get data do value
	set data v do value = v

	get range do Array.isArray(data)
	def values value do value == null ? [min] : [].concat(value)

	get formatter do #formatter ||= new Intl.NumberFormat(locale, formatOptions or {})
	def format n do formatter.format(n)
	get valueText do values(data).map(do format($1)).join(' – ')

	def markValue mark do typeof mark == 'object' ? mark.value : mark
	def markLabel mark do typeof mark == 'object' ? mark.label : format(mark)

	def setup
		let initial = values(data)
		machine = new Machine self, zagSlider.machine, do defined({
			id: zagId
			ids: fieldIds(self)
			min: min
			max: max
			step: step
			name: name
			disabled: disabled or #locked
			invalid: !!#field..invalid
			defaultValue: initial
			# Screen readers hear the formatted value (e.g. £20).
			getAriaValueText: do(details) format(details.value)
			# Two thumbs can't pass each other.
			minStepsBetweenThumbs: range ? 1 : 0
			onValueChange: do(details)
				data = range ? details.value : details.value[0]
				machine.track(data)
			onValueChangeEnd: do(details)
				let key = machine.valueKey(data)
				return if key == #emitted
				#emitted = key
				emit('change', data)
		})
		machine.track(data)
		#emitted = machine.valueKey(data)

	def mount do machine.start!
	def unmount do machine.stop!

	def render
		# Inside a ui-field, it owns the label, hint and error. A disabled
		# fieldset (e.g. ui-fields disabled) disables it, which Zag doesn't track.
		#field = closestField(self)
		#locked = !!closest('fieldset:disabled')
		machine.watch "{#field..stateKey}|{#locked}"

		machine.syncValue data, do
			#emitted = machine.valueKey(data)
			machine.connect(zagSlider).setValue(values(data))

		let api = machine.connect(zagSlider)
		let thumbs = values(data)

		<self zag=api.getRootProps!>
			if (label and !#field..label) or showValue
				<div.header>
					if label and !#field..label
						<label.label zag=api.getLabelProps!> label
					if showValue
						<output.value zag=api.getValueTextProps!> valueText
			<div.control zag=api.getControlProps!>
				<div.track zag=api.getTrackProps!>
					<div.range zag=api.getRangeProps!>
				for v, i in thumbs
					<div.thumb zag=(#field ? #field.describe(api.getThumbProps(index: i)) : api.getThumbProps(index: i))>
						<input zag=api.getHiddenInputProps(index: i) @change.stop>
			if marks
				<div.markers zag=api.getMarkerGroupProps!>
					for mark in marks
						<span.marker zag=api.getMarkerProps(value: markValue(mark))> markLabel(mark)
