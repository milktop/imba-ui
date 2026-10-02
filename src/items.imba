# Helpers for list components (select, combobox). Items may be plain strings
# or objects; Zag identifies items by string value, so values are stringified
# going in and mapped back to the original (e.g. numeric Rails ids) coming out.

export def itemLabel item, key = 'label'
	typeof item == 'object' and item ? String(item[key] ?? '') : String(item ?? '')

export def itemValue item, key = 'value'
	typeof item == 'object' and item ? item[key] : item

export def toCollection factory, items, labelKey = 'label', valueKey = 'value', disabledKey = 'disabled'
	factory.collection
		items: items or []
		itemToString: do(item) itemLabel(item, labelKey)
		itemToValue: do(item) String(itemValue(item, valueKey))
		isItemDisabled: do(item) typeof item == 'object' and !!item..[disabledKey]

# Normalises a `value` prop (single value, array or null) to Zag's string[].
export def toValueArray value
	[].concat(value ?? []).map(do String($1))
