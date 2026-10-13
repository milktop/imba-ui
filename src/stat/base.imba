import { icons } from '../icons.imba'
import 'iconify-icon'
import { formatNumber } from '../format/base.imba'
import '../rolling-number/base.imba'
import { uiLocale } from '../locale.imba'

# Headless stat: a headline number with its label, e.g. on a dashboard.
#
#   <ui-stat label='Lessons this month' value=52 change=12.5 changeLabel='vs September'>
#
# - `value` and an optional `unit`: text is shown as given; a number is
#   formatted (grouped digits), with `format` (Intl's options:
#   `{ style: 'currency', currency: 'GBP' }`)
# - `animate`: a number's digits roll to a new value when it changes
#   (ui-rolling-number)
# - `change`: a number, shown as "+12.5%" with an arrow, green when up and red
#   when down; `invert` swaps the colours (for things like cancellations);
#   `changeUnit` replaces the '%'
# - `changeLabel`, `help`: muted text after the change, and under it all
# - `icon`: an Iconify icon in a tinted square, beside the label
# - `variant`: 'plain' (default) or 'card'
# - `size`: 'sm', 'md' (default) or 'lg'
#
# Group stats in ui-stats for a responsive grid.
tag ui-stat-base
	prop label = ''
	prop value = null
	prop format = null
	prop animate = false
	prop unit = null
	prop change = null
	prop changeUnit = '%'
	prop changeLabel = null
	prop invert = false
	prop help = null
	prop icon = null
	prop variant = 'plain'
	prop size = 'md'

	get direction do change > 0 ? 'up' : (change < 0 ? 'down' : 'flat')
	get good do direction == 'flat' ? null : ((direction == 'up') != !!invert)
	get changeText do "{change > 0 ? '+' : ''}{change}{changeUnit}"
	get isNumber do typeof value == 'number' and Number.isFinite(value)
	get valueText do isNumber ? formatNumber(value, format) : String(value ?? '')

	# The tag of the rolling number; the styled stat uses ui-rolling-number.
	rollingTag = 'ui-rolling-number-base'

	# The icon shares the label's row, at the end, so the text keeps one left
	# edge and the rows line up from stat to stat.
	<self .{variant} .{size}>
		<div.header>
			<div.label> label
			if icon
				<span.icon aria-hidden='true'> <iconify-icon icon=icon>
		<div.value>
			if animate and isNumber
				<{rollingTag} value=value format=format>
			else
				<span> valueText
			<span.unit> unit if unit
		if change != null or changeLabel
			<div.footer>
				if change != null
					<span.change .good=(good === true) .bad=(good === false) aria-label="{uiLocale.messages.stat[direction == 'flat' ? 'same' : direction]} {changeText}">
						<ui-icon path=(direction == 'down' ? icons.trendDown : icons.trendUp) size=14> if direction != 'flat'
						changeText
				<span.change-label> changeLabel if changeLabel
		<div.help> help if help
		<slot>

# A responsive grid of stats.
#
# - `columns`: the most per row (4); fewer when there isn't room
# - `variant`: 'plain' (default), 'cards' (each stat a card) or 'divided'
#   (one card split into cells)
tag ui-stats-base
	prop columns = 4
	prop variant = 'plain'

	<self .{variant} data-ui-stats style="--columns: {columns}">
		<div.grid> <slot>
