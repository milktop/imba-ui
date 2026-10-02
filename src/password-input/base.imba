import * as zagPassword from '@zag-js/password-input'
import { Machine, uid, defined } from '../zag.imba'
import { closestField, fieldIds } from '../field/base.imba'

# Headless password input with a show/hide button.
#
# - `autocomplete`: 'current-password' (default) or 'new-password'
# - `icon`: an Iconify name shown before the input
#
# Works with `bind=`, `bind:value=` or `value` + `@change` like the other
# inputs; `change` emits on commit, native `input` events bubble. A ui-field
# with type='password' renders one.
tag ui-password-input-base
	prop label = null
	prop value = ''
	prop name = null
	prop placeholder = null
	# Imba passes `autocomplete` (like inputmode, autofocus, spellcheck) through
	# set$, which only assigns a property that has a setter; a `prop` has none.
	get autocomplete do #autocomplete ?? 'current-password'
	set autocomplete v do #autocomplete = v
	prop icon = null
	prop required = false
	prop disabled = false

	zagId = uid('password')

	# `bind=` targets `data` and `bind:value=` targets `value`. Either way Imba
	# replaces that property with one reading and writing the bound model, so
	# `data` aliases `value` here and the input goes through `data`.
	get data do value
	set data v do value = v

	def setup
		machine = new Machine self, zagPassword.machine, do defined({
			id: zagId
			ids: fieldIds(self)
			name: name
			autoComplete: autocomplete
			required: required
			disabled: disabled or #locked
			invalid: !!#field..invalid
		})

	def mount do machine.start!
	def unmount do machine.stop!

	def render
		# Inside a ui-field, it owns the label, hint and error. A disabled
		# fieldset (e.g. ui-fields disabled) disables it, which Zag doesn't track.
		#field = closestField(self)
		#locked = !!closest('fieldset:disabled')
		machine.watch "{#field..stateKey}|{#locked}"

		let api = machine.connect(zagPassword)
		let input = api.getInputProps!
		input = #field.describe(input) if #field

		<self zag=api.getRootProps!>
			if label and !#field..label
				<label.label zag=api.getLabelProps!> label
			<div.control zag=api.getControlProps!>
				if icon
					<span.affix> <iconify-icon icon=icon>
				<input.input zag=input placeholder=(placeholder or '') bind=data @change.stop=emit('change', data)>
				<button.toggle zag=api.getVisibilityTriggerProps!>
					<iconify-icon icon=(api.visible ? 'lucide:eye-off' : 'lucide:eye') aria-hidden='true'>
