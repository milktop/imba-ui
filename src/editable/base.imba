import * as editable from '@zag-js/editable'
import { Machine, uid, defined } from '../zag.imba'
import { fieldIds } from '../control.imba'
import 'iconify-icon'

# Headless editable: text you click to edit in place, e.g. a pet's name or a
# price on a details page. It reads as text until clicked; Enter saves and
# Escape cancels.
#
#   <ui-editable bind=pet.name @change=save>
#
# - `placeholder`: shown when it's empty
# - `label`: a label above it (skipped inside a ui-field, which labels it)
# - `activationMode`: 'click' (default), 'dblclick' or 'focus'
# - `controls`: ✓ and ✕ buttons while editing, a pencil otherwise (true)
# - `submitMode`: 'both' (default: Enter or leaving the box saves), 'enter',
#   'blur' or 'none'
# - `maxLength`, `disabled`, `readOnly`
#
# Emits `change` with the text once an edit is saved (not on each key), and
# only if it changed.
tag ui-editable-base < ui-control
	prop value = ''
	prop label = null
	prop placeholder = null
	prop activationMode = 'click'
	prop submitMode = 'both'
	prop controls = true
	prop maxLength = null
	prop disabled = false
	prop readOnly = false

	zagId = uid('editable')

	def setup
		let initial = String(data ?? '')
		machine = new Machine self, editable.machine, do defined({
			id: zagId
			ids: fieldIds(self)
			defaultValue: initial
			placeholder: placeholder ?? undefined
			activationMode: activationMode
			submitMode: submitMode
			maxLength: maxLength ?? undefined
			disabled: disabled or #locked
			readOnly: readOnly
			invalid: !!#field..invalid
			onValueCommit: do(details)
				data = details.value
				emit('change', data) if machine.track(data)
		})
		machine.track(initial)

	def mount do machine.start!
	def unmount do machine.stop!

	def render
		connectField!

		# A new value from outside shows when it isn't being edited.
		machine.syncValue String(data ?? ''), do
			let api = machine.connect(editable)
			api.setValue(String(data ?? '')) unless api.editing

		let api = machine.connect(editable)

		<self zag=api.getRootProps!>
			if label and !#field..label
				<label.label zag=api.getLabelProps!> label
			<div.row>
				<div.area zag=api.getAreaProps!>
					<input.input zag=describe(api.getInputProps!) @change.stop>
					<span.preview zag=api.getPreviewProps!> api.valueText
				if controls
					<div.controls zag=api.getControlProps!>
						if api.editing
							<button.trigger.submit zag=api.getSubmitTriggerProps!> <iconify-icon icon='lucide:check' aria-hidden='true'>
							<button.trigger.cancel zag=api.getCancelTriggerProps!> <iconify-icon icon='lucide:x' aria-hidden='true'>
						else
							<button.trigger.edit zag=api.getEditTriggerProps!> <iconify-icon icon='lucide:pencil' aria-hidden='true'>
