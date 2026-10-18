import * as datepicker from '@zag-js/date-picker'
import { today, getLocalTimeZone, DateFormatter } from '@internationalized/date'
import { parseDateString } from '@zag-js/date-utils'
import { Machine, uid } from '../zag.imba'
import { closestField } from '../control.imba'
import { icons } from '../icons.imba'
import { uiLocale } from '../locale.imba'

# Headless date picker: Zag's machine plus markup, no styles. Elements carry
# Zag's data-scope/data-part/data-state attributes plus a class per part, so a
# subclass can style it with plain scoped CSS (see ./index.imba).
#
# - `inline`: just the calendar, always showing (no input or popup), e.g. a
#   sidebar, a booking panel or a `flush` popover; it has no frame of its own
#
# Typing puts in the locale's separators (11102026 → 11/10/2026; 11.10.2026
# in German); a separator typed by hand, or a pasted date, works too. A typed
# date is taken on Enter or when the input loses focus. One it can't take
# (past `min` or `max`, `unavailable`, or not a whole date) stays in the
# input, marked invalid with the reason under it, and the value doesn't
# change; the input's validity is set too, so a form won't submit with it.
#
# Emits `change` with an ISO date ('YYYY-MM-DD'), or an array of two in range
# mode, and `invalidchange` with the reason a typed date wasn't taken (null
# once the input holds one it takes, or is cleared).

# The input's date pattern for a locale: its fields in order (with how many
# digits each takes) and the separator between them ('/', '.', '-').
def patternOf locale
	let parts = new Intl.DateTimeFormat(locale).formatToParts(new Date(2000, 0, 1))
	let fields = parts.filter(do ['day', 'month', 'year'].includes($1.type)).map(do $1.type == 'year' ? 4 : 2)
	let separator = parts.find(do $1.type == 'literal')..value.trim! or '/'
	{ fields, separator }
tag ui-date-picker-base < ui-control
	prop label = null
	prop value = null
	prop range = false
	prop min = null
	prop max = null
	prop locale = null

	# Its own `locale`, or the app's (uiLocale).
	get currentLocale do locale or uiLocale.locale
	prop placement = 'bottom-start'
	prop disabled = false
	# Function receiving a CalendarDate; return true to make it unselectable.
	prop unavailable = null
	prop inline = false

	problem = null

	zagId = uid('date-picker')

	def parseDates value
		[].concat(value or []).map(do datepicker.parse($1))

	# Up/Down in an input step its date by a day (with Shift, a week), skipping
	# unavailable dates; on an empty input the first press picks today.
	def stepDate e, index
		let step = { ArrowUp: 1, ArrowDown: -1 }[e.key]
		return unless step and !e.altKey and !e.metaKey and !e.ctrlKey
		e.preventDefault!
		let api = machine.connect(datepicker)
		let values = api.value.slice!
		let date = values[index]
		let days = step * (e.shiftKey ? 7 : 1)
		date = date ? date.add(days: days) : today(getLocalTimeZone!)
		let tries = 0
		while api.isUnavailable(date)
			return if ++tries > 366 # past min/max, or nothing available
			date = date.add(days: step)
		values[index] = date
		# In range mode, the stepped date pushes the other end along with it
		# (and fills it when empty), so start never passes end.
		if range
			let other = 1 - index
			let crossed = values[other] and (index == 0 ? date.compare(values[1]) > 0 : date.compare(values[0]) < 0)
			values[other] = date if !values[other] or crossed
		api.setValue(values)

	get pattern
		#pattern = patternOf(currentLocale) unless #patternLocale == currentLocale
		#patternLocale = currentLocale
		#pattern

	# Typing at the end: once a field has its digits, the separator goes in
	# after it; more digits than it takes (pasted in one go) carry on into the
	# next field; a separator typed straight after one put in is dropped (no
	# "11//"). Runs before Zag's own handler, which then reads the new value.
	def separate e
		let input = e.target
		return unless e.inputType == 'insertText' and input.selectionStart == input.value.length
		let { fields, separator } = pattern
		if e.data == separator and input.value.endsWith(separator + separator)
			input.value = input.value.slice(0, -1)
			return
		let pieces = input.value.split(separator)
		return unless pieces.every(do /^\d*$/.test($1))
		while pieces.length < fields.length and pieces[pieces.length - 1].length > fields[pieces.length - 1]
			let last = pieces.pop!
			pieces.push(last.slice(0, fields[pieces.length]), last.slice(fields[pieces.length]))
		let index = pieces.length - 1
		pieces.push('') if index < fields.length - 1 and pieces[index].length == fields[index]
		let next = pieces.join(separator)
		input.value = next unless next == input.value

	def dateText date do new DateFormatter(currentLocale).format(date.toDate(getLocalTimeZone!))

	# Why a typed date can't be taken, or the date itself (null when empty).
	def check input
		let text = input.value.trim!
		return null unless text
		let pieces = text.split(pattern.separator)
		let whole = pieces.length == pattern.fields.length and pieces.every(do /^\d+$/.test($1))
		let date = whole ? parseDateString(text, currentLocale, getLocalTimeZone!) : undefined
		return { reason: uiLocale.messages.datePicker.format(input.placeholder) } unless date
		return { reason: uiLocale.messages.datePicker.min(dateText(datepicker.parse(min))) } if min and date.compare(datepicker.parse(min)) < 0
		return { reason: uiLocale.messages.datePicker.max(dateText(datepicker.parse(max))) } if max and date.compare(datepicker.parse(max)) > 0
		return { reason: uiLocale.messages.datePicker.unavailable } if machine.connect(datepicker).isUnavailable(date)
		{ date }

	# A typed date it can't take: the reason, shown under the input and set as
	# its validity (so a form won't submit), until one it takes is chosen.
	def report next, input = null
		if next
			input..setCustomValidity(next.reason)
		else
			for el in querySelectorAll('.input')
				el.setCustomValidity('')
		return if next..reason == problem..reason and next..index == problem..index
		problem = next
		emit('invalidchange', next ? next.reason : null)
		render!

	# Takes the typed date, or reports why not (Zag would clamp or revert it).
	def commitInput input, index
		let result = check(input)
		unless result
			report(null, input)
			return yes
		if result.reason
			report({ index, reason: result.reason }, input)
			return no
		report(null, input)
		let api = machine.connect(datepicker)
		let values = api.value.slice!
		values[index] = result.date
		values[1 - index] = result.date if range and !values[1 - index]
		values.reverse! if range and values[0] and values[1] and values[0].compare(values[1]) > 0
		api.setValue(values)
		yes

	def keydown e, index
		# Enter takes the typed date only if it can (Zag shows "undefined" for a
		# part-typed one, 11/1); otherwise it says why.
		if e.key == 'Enter'
			e.preventDefault! unless commitInput(e.target, index)
			return
		stepDate(e, index)

	def setup
		let initial = parseDates(data)
		machine = new Machine self, datepicker.machine, do
			id: zagId
			locale: currentLocale
			translations: uiLocale.zag('datePicker')
			disabled: disabled or #locked
			invalid: !!#field..invalid
			ids: { label: do closestField(self)..labelledBy }
			selectionMode: range ? 'range' : 'single'
			defaultValue: initial
			min: min and datepicker.parse(min)
			max: max and datepicker.parse(max)
			isDateUnavailable: unavailable
			inline: inline or undefined
			positioning: { placement }
			onValueChange: do(details)
				report(null)
				# CalendarDate#toString is ISO; valueAsString is locale-formatted.
				let iso = details.value.map(String)
				data = range ? iso : (iso[0] or null)
				emit('change', data) if machine.track(data)

		machine.track(data)

	get errorId do "{zagId}-error"

	# An input's props: the field's description, and the reason it's invalid.
	def inputProps api, index
		let props = describe(api.getInputProps(index: index, fixOnBlur: false))
		return props unless problem and problem.index == index
		Object.assign({}, props, 'aria-invalid': 'true', 'aria-describedby': [props['aria-describedby'], errorId].filter(Boolean).join(' '))

	def mount do machine.start!
	def unmount do machine.stop!

	def render
		connectField(currentLocale)
		machine.syncValue data, do
			machine.connect(datepicker).setValue(parseDates(data))

		let api = machine.connect(datepicker)
		let view = api.view

		<self .inline=inline .has-problem=!!problem zag=api.getRootProps!>
			if label and !#field..label
				<label.label zag=api.getLabelProps!> label
			unless inline
				<div.control zag=api.getControlProps!>
					<input.input zag=inputProps(api, 0) size=10 @input.capture=separate(e) @keydown=keydown(e, 0) @blur=commitInput(e.target, 0) @change.stop>
					if range
						<span.separator> "–"
						<input.input zag=inputProps(api, 1) size=10 @input.capture=separate(e) @keydown=keydown(e, 1) @blur=commitInput(e.target, 1) @change.stop>
					<button.clear zag=api.getClearTriggerProps! @click=report(null)> <ui-icon path=icons.x size=14>
					<button.trigger zag=api.getTriggerProps!> <ui-icon path=icons.calendar>
				if problem
					<div.error id=errorId role='alert'> problem.reason

			<div.positioner zag=(inline ? {} : api.getPositionerProps!)>
				<div.content zag=api.getContentProps!>
					<div.view zag=api.getViewProps(view: view)>
						<div.view-control zag=api.getViewControlProps(view: view)>
							<button.prev zag=api.getPrevTriggerProps(view: view)> <ui-icon path=icons.left>
							<button.view-trigger zag=api.getViewTriggerProps(view: view)>
								if view == 'day'
									api.visibleRangeText.start
								elif view == 'month'
									api.visibleRange.start.year
								else
									let decade = api.getDecade!
									"{decade.start} – {decade.end}"
							<button.next zag=api.getNextTriggerProps(view: view)> <ui-icon path=icons.right>

						if view == 'day'
							<table.table zag=api.getTableProps(view: 'day')>
								<thead zag=api.getTableHeadProps(view: 'day')>
									<tr zag=api.getTableRowProps(view: 'day')>
										for day in api.weekDays
											<th.weekday scope='col' aria-label=day.long> day.narrow
								<tbody zag=api.getTableBodyProps(view: 'day')>
									for week in api.weeks
										<tr zag=api.getTableRowProps(view: 'day')>
											for date in week
												<td zag=api.getDayTableCellProps(value: date)>
													<div.cell zag=api.getDayTableCellTriggerProps(value: date)> date.day

						elif view == 'month'
							<table.table zag=api.getTableProps(view: 'month', columns: 4)>
								<tbody zag=api.getTableBodyProps(view: 'month')>
									for row in api.getMonthsGrid(columns: 4, format: 'short')
										<tr zag=api.getTableRowProps(view: 'month')>
											for month in row
												<td zag=api.getMonthTableCellProps(value: month.value, columns: 4)>
													<div.cell.wide zag=api.getMonthTableCellTriggerProps(value: month.value, columns: 4)> month.label

						else
							<table.table zag=api.getTableProps(view: 'year', columns: 4)>
								<tbody zag=api.getTableBodyProps(view: 'year')>
									for row in api.getYearsGrid(columns: 4)
										<tr zag=api.getTableRowProps(view: 'year')>
											for year in row
												<td zag=api.getYearTableCellProps(value: year.value, columns: 4)>
													<div.cell.wide zag=api.getYearTableCellTriggerProps(value: year.value, columns: 4)> year.label
