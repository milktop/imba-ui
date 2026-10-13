import * as radio from '@zag-js/radio-group'
import { Machine, uid } from '../zag.imba'
import { fieldIds } from '../control.imba'
import { icons } from '../icons.imba'
import '../popover/base.imba'

# The palette by name (Tailwind's 500s): the default swatches, and the CSS
# colour of a chosen name (`swatches.teal`).
export const swatches = {
	slate: '#64748b', red: '#ef4444', orange: '#f97316', amber: '#f59e0b', yellow: '#eab308', lime: '#84cc16', green: '#22c55e'
	emerald: '#10b981', teal: '#14b8a6', cyan: '#06b6d4', sky: '#0ea5e9', blue: '#3b82f6', indigo: '#6366f1', violet: '#8b5cf6'
	purple: '#a855f7', fuchsia: '#d946ef', pink: '#ec4899', rose: '#f43f5e'
}

# Headless swatch picker: a colour from a few swatches, e.g. a tutor's colour
# on the calendar. Arrow keys move between them, like radio buttons (which
# they are).
#
#   <ui-swatch-picker label='Colour' bind=color>
#   <ui-swatch-picker items=[{ value: 'brand', color: '#e11d48', label: 'Brand' }] bind=color>
#   <ui-swatch-picker variant='popover' bind=color>
#
# - `items`: colour names from `swatches`, or `{ value, color, label }`
#   (by default every colour in `swatches`); the value is the name, or yours
# - `label`: a label above it (skipped inside a ui-field, which labels it)
# - `size`: 'sm', 'md' (default) or 'lg'
# - `variant`: 'inline' (default: the swatches in the page) or 'popover': a
#   field showing the chosen colour and its name, opening the swatches
#   (closed once one's chosen); `placeholder` shows while none is
# - `name`: the hidden radios post with plain forms
#
# Emits `change` with the chosen value.
tag ui-swatch-picker-base < ui-control
	prop items = Object.keys(swatches)
	prop value = null
	prop label = null
	prop size = 'md'
	prop variant = 'inline'
	prop placeholder = 'Pick a colour'
	prop name = null
	prop disabled = false

	zagId = uid('swatch-picker')
	open = false

	# The popover; the styled picker uses ui-popover.
	popoverTag = 'ui-popover-base'

	get list
		(items or []).map do(item)
			if typeof item == 'string'
				{ value: item, color: swatches[item] ?? item, label: item.charAt(0).toUpperCase! + item.slice(1) }
			else
				item

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
				data = details.value
				open = false
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
		let popover = variant == 'popover'
		let chosen = list.find(do $1.value == data)
		let fieldLabel = #field..labelledBy or (label ? "{zagId}-label" : null)

		<self .{size} .{variant}>
			if label and !#field..label
				<span.label id="{zagId}-label" zag=(popover ? {} : api.getLabelProps!)> label
			if popover
				# A field (like an input) showing the colour, opening the swatches.
				<{popoverTag} placement='bottom-start' bind=open>
					<button.trigger slot='trigger' type='button' aria-labelledby=(fieldLabel ? "{fieldLabel} {zagId}-value" : undefined) aria-invalid=(#field..invalid ? 'true' : undefined) disabled=(disabled or #locked)>
						<span.chip .empty=!chosen style="--swatch: {chosen ? chosen.color : 'transparent'}">
						<span.value .placeholder=!chosen id="{zagId}-value"> chosen ? (chosen.label ?? chosen.value) : placeholder
						<span.indicator> <ui-icon path=icons.down size=16>
					<div.grid zag=describe(Object.assign({}, api.getRootProps!, fieldLabel ? { 'aria-labelledby': fieldLabel } : {}))>
						<div.items> for swatch in list
							<label.item zag=api.getItemProps(value: swatch.value) title=(swatch.label ?? swatch.value) style="--swatch: {swatch.color}">
								<span.swatch zag=api.getItemControlProps(value: swatch.value)> <span.tick> <ui-icon path=icons.check size=14>
								<span.item-text zag=api.getItemTextProps(value: swatch.value)> swatch.label ?? swatch.value
								<input zag=api.getItemHiddenInputProps(value: swatch.value) @change.stop>
			else
				<div.grid zag=describe(api.getRootProps!)>
					<div.items> for swatch in list
						<label.item zag=api.getItemProps(value: swatch.value) title=(swatch.label ?? swatch.value) style="--swatch: {swatch.color}">
							<span.swatch zag=api.getItemControlProps(value: swatch.value)> <span.tick> <ui-icon path=icons.check size=14>
							<span.item-text zag=api.getItemTextProps(value: swatch.value)> swatch.label ?? swatch.value
							<input zag=api.getItemHiddenInputProps(value: swatch.value) @change.stop>
