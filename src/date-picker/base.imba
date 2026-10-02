import * as datepicker from '@zag-js/date-picker'
import { Machine, uid } from '../zag.imba'
import { closestField } from '../field/base.imba'
import { icons } from '../icons.imba'

# Headless date picker: Zag's machine plus markup, no styles. Elements carry
# Zag's data-scope/data-part/data-state attributes plus a class per part, so a
# subclass can style it with plain scoped CSS (see ./index.imba).
#
# Emits `change` with an ISO date ('YYYY-MM-DD'), or an array of two in range mode.
tag ui-date-picker-base
	prop label = null
	prop value = null
	prop range = false
	prop min = null
	prop max = null
	prop locale = 'en-GB'
	prop placement = 'bottom-start'
	prop disabled = false
	# Function receiving a CalendarDate; return true to make it unselectable.
	prop unavailable = null

	zagId = uid('date-picker')

	def parseDates value
		[].concat(value or []).map(do datepicker.parse($1))

	# `bind=` targets `data` and `bind:value=` targets `value`. Either way Imba
	# replaces that property with one reading and writing the bound model, so
	# `data` aliases `value` here and the component goes through `data`.
	get data do value
	set data v do value = v

	def setup
		let initial = parseDates(data)
		machine = new Machine self, datepicker.machine, do
			id: zagId
			locale: locale
			disabled: disabled
			invalid: !!#field..invalid
			ids: { label: do closestField(self)..labelledBy }
			selectionMode: range ? 'range' : 'single'
			defaultValue: initial
			min: min and datepicker.parse(min)
			max: max and datepicker.parse(max)
			isDateUnavailable: unavailable
			positioning: { placement }
			onValueChange: do(details)
				# CalendarDate#toString is ISO; valueAsString is locale-formatted.
				let iso = details.value.map(String)
				data = range ? iso : (iso[0] or null)
				emit('change', data) if machine.track(data)

		machine.track(data)

	def mount do machine.start!
	def unmount do machine.stop!

	def render
		# Inside a ui-field, it owns the label, hint and error.
		#field = closestField(self)
		if #field..stateKey != #fieldKey
			#fieldKey = #field..stateKey
			machine.refresh!
		machine.syncValue data, do
			machine.connect(datepicker).setValue(parseDates(data))

		let api = machine.connect(datepicker)
		let view = api.view

		<self zag=api.getRootProps!>
			if label and !#field..label
				<label.label zag=api.getLabelProps!> label
			<div.control zag=api.getControlProps!>
				<input.input zag=(#field ? #field.describe(api.getInputProps(index: 0)) : api.getInputProps(index: 0)) @change.stop>
				if range
					<span.separator> "–"
					<input.input zag=(#field ? #field.describe(api.getInputProps(index: 1)) : api.getInputProps(index: 1)) @change.stop>
				<button.clear zag=api.getClearTriggerProps!> <ui-icon path=icons.x size=14>
				<button.trigger zag=api.getTriggerProps!> <ui-icon path=icons.calendar>

			<div.positioner zag=api.getPositionerProps!>
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
