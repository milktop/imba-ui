import source from './date-range-filter.imba?raw'

# A one-off range: the school year so far, from 1 September.
const schoolYear = {
	label: 'School year'
	range: do
		let now = new Date
		let year = now.getMonth! < 8 ? now.getFullYear! - 1 : now.getFullYear!
		[new Date(year, 8, 1), now]
}

tag page-date-range-filter
	invoices = []
	lessons = []
	term = []
	changes = 0

	<self>
		<demo-page source=source heading='Date range filter' intro='ui-date-range-filter opens preset ranges beside a range calendar, for narrowing a list to some dates. It binds [from, to] as ISO dates; empty means all dates.'>
			<demo-section heading='Past ranges (the default presets)'>
				<ui-date-range-filter bind=invoices @change=(changes++)>
				<div.out>
					<json-print data={ invoices, changes }>
					<p.note> "A preset fills in the calendar; dates picked there light up the preset they match. The panel stays open until Escape or a click outside."

			<demo-section heading='Coming up'>
				<ui-date-range-filter presets=['today', 'tomorrow', 'thisWeek', 'nextWeek', 'next7', 'next30', 'nextMonth'] placement='bottom-start' bind=lessons>
				<div.out>
					<json-print data={ lessons }>
					<p.note> "`presets` picks built-in ranges by key."

			<demo-section heading='A range of your own'>
				<ui-date-range-filter presets=['thisMonth', 'lastMonth', schoolYear] placeholder='Any time' placement='bottom-start' bind=term>
				<div.out>
					<json-print data={ term }>
					<p.note> 'Or give `{ label, range }`, `range` returning [from, to] as Dates.'
