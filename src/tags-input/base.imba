import * as zagTags from '@zag-js/tags-input'
import { Machine, uid, defined } from '../zag.imba'
import { fieldIds } from '../control.imba'
import { icons } from '../icons.imba'

# Headless tags input: type and press Enter (or the delimiter, a comma by
# default) to add a tag. Backspace on an empty input selects the last tag and
# then removes it; arrow keys move between tags; double-click (or Enter on a
# selected tag) edits it.
#
# - `max`: most tags allowed
# - `allowDuplicates`, `addOnPaste` (splits pasted text by the delimiter)
# - `validate`: function({ inputValue, value }) returning whether to add it
# - `variant`: 'subtle' (default, grey), 'accent' or 'outline' (styling hooks)
#
# The value is an array of strings; `change` is emitted with it.
tag ui-tags-input-base < ui-control
	prop label = null
	prop value = []
	prop placeholder = ''
	prop max = null
	prop delimiter = ','
	prop allowDuplicates = false
	prop addOnPaste = false
	prop validate = null
	prop name = null
	prop variant = 'subtle'
	prop disabled = false

	zagId = uid('tags')

	def list value do [].concat(value ?? []).map(do String($1))

	def setup
		let initial = list(data)
		machine = new Machine self, zagTags.machine, do defined({
			id: zagId
			ids: fieldIds(self)
			max: max
			delimiter: delimiter
			allowDuplicates: allowDuplicates
			addOnPaste: addOnPaste
			validate: validate
			name: name
			disabled: disabled or #locked
			invalid: !!#field..invalid
			defaultValue: initial
			onValueChange: do(details)
				data = details.value
				emit('change', data) if machine.track(data)
		})
		machine.track(data)

	def mount do machine.start!
	def unmount do machine.stop!

	def render
		connectField!

		machine.syncValue data, do
			machine.connect(zagTags).setValue(list(data))

		let api = machine.connect(zagTags)

		<self .{variant} zag=api.getRootProps!>
			if label and !#field..label
				<label.label zag=api.getLabelProps!> label
			<div.control zag=api.getControlProps!>
				# Tags and the input wrap together; the clear button keeps its own
				# column, however many rows there are.
				<div.tags>
					for tag, index in api.value
						let props = { index, value: tag }
						<span.tag zag=api.getItemProps(props)>
							<span.preview zag=api.getItemPreviewProps(props)>
								<span.text zag=api.getItemTextProps(props)> tag
								<button.remove zag=api.getItemDeleteTriggerProps(props)> <ui-icon path=icons.x size=12>
							<input.edit zag=api.getItemInputProps(props) @change.stop>
					<input.input zag=describe(api.getInputProps!) placeholder=(placeholder or '') @change.stop>
				<button.clear zag=api.getClearTriggerProps!> <ui-icon path=icons.x size=14>
			<input zag=api.getHiddenInputProps! @change.stop>
