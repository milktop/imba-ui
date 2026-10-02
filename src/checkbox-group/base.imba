import { uid } from '../zag.imba'
import { closestField } from '../field/base.imba'
import { itemLabel, itemValue, itemKey, itemDisabled } from '../items.imba'
import '../checkbox/base.imba'

# Headless checkbox group: one checkbox per item, bound to an array of the
# selected items' values.
#
# - `items`: strings or objects (see `labelKey`, `valueKey`, `disabledKey`)
# - `selectAll`: label for a parent checkbox that selects all or none, and is
#   indeterminate when only some are selected (disabled items keep their state)
# - `orientation`: 'vertical' (default) or 'horizontal'
# - `name`: each checkbox posts its value with plain forms
#
# Emits `change` with the selected values, in item order, as the items' own
# values. It is a labelled group: inside a ui-field it takes the field's
# label, and the field's hint and error are announced once, on the group.
tag ui-checkbox-group-base
	prop label = null
	prop items = []
	prop value = []
	prop labelKey = 'label'
	prop valueKey = 'value'
	prop disabledKey = 'disabled'
	prop selectAll = null
	prop orientation = 'vertical'
	prop name = null
	prop disabled = false

	# The tag of each checkbox; the styled group uses ui-checkbox.
	checkboxTag = 'ui-checkbox-base'
	labelId = "{uid('checkbox-group')}-label"

	# `bind=` targets `data` and `bind:value=` targets `value`. Either way Imba
	# replaces that property with one reading and writing the bound model, so
	# `data` aliases `value` here and the group goes through `data`.
	get data do value
	set data v do value = v

	# The checkboxes treat the group as their field: they pick up its error
	# state, while the hint and error are described on the group itself.
	isUiField = yes
	get invalid do !!#field..invalid
	get stateKey do "|{invalid}"
	def describe props do props

	def isSelected item
		let key = itemKey(item, valueKey)
		[].concat(data ?? []).some(do String($1) == key)

	def isLocked item do disabled or itemDisabled(item, disabledKey)

	def setSelection next
		data = next.map(do itemValue($1, valueKey))
		emit('change', data)

	def toggle item, checked
		setSelection items.filter(do(i) i == item ? checked : isSelected(i))

	def toggleAll checked
		setSelection items.filter(do(i) isLocked(i) ? isSelected(i) : checked)

	# The select-all box: checked when every enabled item is, indeterminate
	# when only some are.
	get allState
		let open = items.filter(do !isLocked($1))
		let on = open.filter(do isSelected($1)).length
		on == 0 ? false : (on == open.length ? true : 'indeterminate')

	def render
		#field = closestField(self)
		let labelledBy = #field..labelledBy or (label ? labelId : undefined)

		<self>
			if label and !#field..label
				<span.label id=labelId> label
			<div.group role='group' zag={ 'aria-labelledby': labelledBy, 'aria-describedby': #field..describedBy ?? undefined }>
				if selectAll
					<{checkboxTag}.select-all label=selectAll checked=allState disabled=disabled @change.stop=toggleAll(e.detail)>
				<div.items .horizontal=(orientation == 'horizontal') .indented=!!selectAll>
					for item in items
						<{checkboxTag}.item label=itemLabel(item, labelKey) checked=isSelected(item) disabled=isLocked(item) name=name value=itemKey(item, valueKey) @change.stop=toggle(item, e.detail)>
