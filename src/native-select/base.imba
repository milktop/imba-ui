import { uid } from '../zag.imba'
import '../control.imba'
import { itemLabel, itemKey, valueForKey, itemDisabled } from '../items.imba'
import 'iconify-icon'

# Headless native select: the browser's own <select>, styled like the inputs.
# For the phone's own picker, long lists that don't need search, and plain
# form posts; ui-select does the rest.
#
#   <ui-native-select label='Species' items=['Dog', 'Cat', 'Rabbit'] bind=species>
#
# - `items`: strings or objects (see `labelKey`, `valueKey`, `disabledKey`;
#   an item's `group` puts it under that heading)
# - `placeholder`: an empty first option (choosing it clears the value)
# - `label`: a label above it (skipped inside a ui-field, which labels it)
# - `size`: 'sm', 'md' (default) or 'lg'
# - `name`, `required`, `disabled`: as on a <select>
#
# Emits `change` with the chosen item's own value (null for the placeholder).
tag ui-native-select-base < ui-control
	prop label = null
	prop items = []
	prop value = null
	prop placeholder = null
	prop labelKey = 'label'
	prop valueKey = 'value'
	prop disabledKey = 'disabled'
	prop name = null
	prop required = false
	prop disabled = false
	prop size = 'md'

	selectId = uid('native-select')

	def groupOf item do typeof item == 'object' and item ? (item.group ?? null) : null

	# Headings in order of first appearance (null for items without one).
	get groups do Array.from(new Set((items or []).map(do groupOf($1))))

	def change e
		# <select> values are strings: map back to the item's own.
		data = valueForKey(items, e.target.value, valueKey)
		emit('change', data)

	# Options exist only after rendering, so the selection is set then.
	def rendered
		$select.value = data == null ? '' : String(data)

	def render
		connectField!
		let groups = groups

		<self .{size} .empty=(data == null)>
			if label and !#field..label
				<label.label htmlFor=selectId> label
			<div.control>
				<select$select.select id=selectId name=(name or undefined) required=required disabled=(disabled or #locked) @change.stop=change>
					if placeholder != null
						<option value=''> placeholder
					for group in groups
						if group
							<optgroup label=group>
								for item in items.filter(do groupOf($1) == group)
									<option value=itemKey(item, valueKey) disabled=itemDisabled(item, disabledKey)> itemLabel(item, labelKey)
						else
							for item in items.filter(do groupOf($1) == null)
								<option value=itemKey(item, valueKey) disabled=itemDisabled(item, disabledKey)> itemLabel(item, labelKey)
				<iconify-icon.indicator icon='lucide:chevron-down' aria-hidden='true'>
