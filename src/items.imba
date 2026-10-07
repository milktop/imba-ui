# Helpers for list components (select, menu). Items may be plain strings
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

# Zag's string key for an item, and the reverse: the original value of the
# item with that key (null if none matches).
export def itemKey item, key = 'value'
	String(itemValue(item, key))

export def valueForKey items, str, key = 'value'
	let item = (items or []).find(do itemKey($1, key) == str)
	item == undefined ? null : itemValue(item, key)

export def itemDisabled item, key = 'disabled'
	typeof item == 'object' and !!item..[key]
