import { uiLocale } from '../locale.imba'
import '../popover/base.imba'
import '../button/base.imba'
import '../divider/base.imba'
import '../date-picker/base.imba'
import 'iconify-icon'

# Headless date range filter: a button that opens preset ranges beside a
# calendar, for narrowing a list to some dates.
#
#   <ui-date-range-filter bind=filters.dates>
#   <ui-date-range-filter presets=['today', 'next7', 'nextMonth'] bind=filters.dates>
#
# Binds [from, to] as ISO dates ('YYYY-MM-DD'), empty for all dates, and
# emits `change` with it. A preset fills in the calendar, and dates picked
# there light up the preset they match. The panel stays open until Escape or
# a click outside.
#
# - `presets`: keys of the built-in ranges, or `{ label, range }` for one of
#   your own, `range` being a function returning [from, to] as Dates (it's
#   given the locale's first day of the week, 1 Monday to 7 Sunday)
# - `placeholder`: the button's text with no dates ("All dates")
# - `placement`: where the panel opens ('bottom-end')
# - `locale`: its own, rather than the app's (uiLocale)
#
# Built-in ranges: today, yesterday, tomorrow, last7, last30, next7, next30,
# thisWeek, lastWeek, nextWeek, thisMonth, lastMonth, nextMonth, thisQuarter,
# lastQuarter, thisYear, lastYear. Their labels are uiLocale's
# `dateRangeFilter.ranges`. They're worked out when used, so "today" stays
# today in a page left open overnight.

# Days from today, e.g. days(-6, 0) for the last 7.
def days from, to
	let now = new Date
	[new Date(now.getFullYear!, now.getMonth!, now.getDate! + from), new Date(now.getFullYear!, now.getMonth!, now.getDate! + to)]

def week offset, firstDay
	let now = new Date
	let start = now.getDate! - (now.getDay! - firstDay % 7 + 7) % 7 + offset * 7
	[new Date(now.getFullYear!, now.getMonth!, start), new Date(now.getFullYear!, now.getMonth!, start + 6)]

# Whole months from a month index in this year; Date rolls over past 0–11.
def months start, length
	let year = new Date().getFullYear!
	[new Date(year, start, 1), new Date(year, start + length, 0)]

export const ranges = {
	today: do days(0, 0)
	yesterday: do days(-1, -1)
	tomorrow: do days(1, 1)
	last7: do days(-6, 0)
	last30: do days(-29, 0)
	next7: do days(0, 6)
	next30: do days(0, 29)
	thisWeek: do(firstDay) week(0, firstDay)
	lastWeek: do(firstDay) week(-1, firstDay)
	nextWeek: do(firstDay) week(1, firstDay)
	thisMonth: do months(new Date().getMonth!, 1)
	lastMonth: do months(new Date().getMonth! - 1, 1)
	nextMonth: do months(new Date().getMonth! + 1, 1)
	thisQuarter: do months(Math.floor(new Date().getMonth! / 3) * 3, 3)
	lastQuarter: do months(Math.floor(new Date().getMonth! / 3) * 3 - 3, 3)
	thisYear: do months(0, 12)
	lastYear: do months(-12, 12)
}

# Local 'YYYY-MM-DD'; toISOString would shift it to UTC.
def iso date
	[date.getFullYear!, date.getMonth! + 1, date.getDate!].map(do String($1).padStart(2, '0')).join('-')

def fromIso value
	let [y, m, d] = value.split('-').map(Number)
	new Date(y, m - 1, d)

tag ui-date-range-filter-base
	# The styled tag uses the styled ones.
	popoverTag = 'ui-popover-base'
	buttonTag = 'ui-button-base'
	dividerTag = 'ui-divider-base'
	datePickerTag = 'ui-date-picker-base'

	prop presets = ['today', 'last7', 'last30', 'thisMonth', 'lastMonth', 'thisQuarter', 'lastQuarter', 'thisYear', 'lastYear']
	prop placeholder = null
	prop placement = 'bottom-end'
	prop locale = null

	get currentLocale do locale or uiLocale.locale
	get words do uiLocale.messages.dateRangeFilter

	# 1 Monday to 7 Sunday; Monday where the browser can't say.
	get firstDay
		try
			let info = new Intl.Locale(currentLocale)
			(info.getWeekInfo ? info.getWeekInfo! : info.weekInfo).firstDay or 1
		catch
			1

	get items
		presets.map do(preset)
			typeof preset == 'string' ? { label: words.ranges[preset], range: ranges[preset] } : preset

	get dates do data or []

	def datesOf item do item.range(firstDay).map(iso)

	# Whether a preset matches the dates, however they were picked.
	def matches item
		let [from, to] = dates
		!!to and String(datesOf(item)) == String([from, to])

	get active do items.find(do matches($1))

	get label
		let [from, to] = dates
		return placeholder ?? words.placeholder unless from
		return active.label if active
		let format = new Intl.DateTimeFormat(currentLocale, day: 'numeric', month: 'short', year: 'numeric')
		!to or from == to ? format.format(fromIso(from)) : format.formatRange(fromIso(from), fromIso(to))

	def pick item
		data = datesOf(item)
		emit('change', data)

	def clear
		data = []
		emit('change', data)

	<self>
		<{popoverTag} flush placement=placement>
			<{buttonTag}.trigger slot='trigger' icon='lucide:calendar' iconEnd='lucide:chevron-down'> label
			# Focus lands on the panel when it opens, not on the first preset,
			# which would look picked.
			<div.panel tabindex=-1 data-autofocus=true>
				<div.presets>
					for item in items
						<{buttonTag}.preset block size='sm' variant='ghost' aria-pressed=String(matches(item)) @click=pick(item)> item.label
					<{buttonTag}.clear block size='sm' icon='lucide:x' disabled=!dates.length @click=clear> words.clear
				<{dividerTag} orientation='vertical' spacing='0'>
				<{datePickerTag} inline range locale=locale bind=data @change.stop=emit('change', data)>
