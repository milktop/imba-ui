import { icons } from '../icons.imba'
import '../tooltip/base.imba'

# Headless data list: labels and their values, as a description list (<dl>),
# e.g. a student's details.
#
#   <ui-data-list items=[
#     { label: 'Email', value: 'ada@example.com' }
#     { label: 'Year', value: 11, info: 'School year in September' }
#   ]>
#
# Or as markup, when values need more than text:
#
#   <ui-data-list>
#     <ui-data-item label='Status'> <ui-badge variant='success'> 'Active'
#
# - `orientation`: 'horizontal' (default; labels beside values) or
#   'vertical' (labels above)
# - `variant`: 'plain' (default), 'divided' (lines between items) or 'card'
#   (a bordered box with lines between)
# - `columns`: lays items out in a grid of this many columns (stacking on
#   narrow screens); best with vertical items
# - `labelWidth`: the label column's width when horizontal ('10rem')
# - an item's `info` adds an icon with that text in a tooltip
tag ui-data-list-base
	prop items = null
	prop orientation = 'horizontal'
	prop variant = 'plain'
	prop columns = null
	prop labelWidth = null

	isUiDataList = yes
	itemTag = 'ui-data-item-base'

	get vars do [(columns ? "--columns: {columns}" : ''), (labelWidth ? "--label-width: {labelWidth}" : '')].filter(Boolean).join('; ')

	<self .{orientation} .{variant} .grid=!!columns style=vars>
		<dl.list>
			if items
				for item in items
					<{itemTag} label=item.label info=item.info> String(item.value ?? '')
			<slot>

# One label and its value (the default slot).
tag ui-data-item-base
	prop label = ''
	prop info = null

	<self>
		<div.item>
			<dt.label>
				<span> label
				if info
					<ui-tooltip content=info>
						<span.info tabIndex=0 aria-label=info> <ui-icon path=icons.info size=13>
			<dd.value> <slot>
