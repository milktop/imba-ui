import source from './date-picker.imba?raw'

tag page-date-picker
	lesson = '2026-10-02'
	away = []
	start = null
	booking = null
	reason = null
	visitDate = '2026-10-14'
	german = null

	<self>
		<demo-page source=source heading='Date picker' intro='ui-date-picker binds ISO dates. Type a date, pick from the calendar, or step with ↑/↓ (⇧ for a week).'>
			<demo-section heading='Single date'>
				<ui-fields>
					<ui-field span=6 label='Lesson date'>
						<ui-date-picker bind=lesson>
				<div.out>
					<json-print data={ lesson }>
					<div.set>
						<button @click=(lesson = '2026-12-25')> "Christmas"
						<button @click=(lesson = null)> "Clear"

			<demo-section heading='Range'>
				<ui-fields>
					<ui-field span=6 label='Tutor away' hint='From 1 October'>
						<ui-date-picker range min='2026-10-01' value=away @change=(away = e.detail)>
				<div.out>
					<json-print data={ away }>
					<div.set>
						<button @click=(away = ['2026-10-12', '2026-10-16'])> "Half term"

			<demo-section heading='Unavailable dates'>
				<ui-fields>
					<ui-field span=6 label='Start date' hint='Weekends are unavailable; ↑/↓ skip them'>
						<ui-date-picker unavailable=(do(d) d.toDate('UTC').getUTCDay! % 6 == 0) bind=start>
				<div.out>
					<json-print data={ start }>

			<demo-section heading='Typed dates it can’t take'>
				<ui-fields>
					<ui-field span=6 label='Booking' hint='October and November, weekdays'>
						<ui-date-picker min='2026-10-01' max='2026-11-30' unavailable=(do(d) d.toDate('UTC').getUTCDay! % 6 == 0) bind=booking @invalidchange=(reason = e.detail)>
					<ui-field span=6 label='Termin (de-DE)' hint='Type 11102026'>
						<ui-date-picker locale='de-DE' bind=german>
				<div.out>
					<json-print data={ booking, reason, german }>
					<p.note> "Type 12/12/2026, a Saturday, or 11/1 and press Enter: the text stays, marked invalid with the reason, and the value doesn't change. Digits get the locale's separators as you type."

			<demo-section heading='Inline'>
				<ui-card[w:fit-content] size='sm'>
					<ui-date-picker inline bind=visitDate>
				<div.out>
					<json-print data={ visitDate }>
					<p.note> "Inline has no frame of its own: here a card supplies it."

			<demo-section heading='In a popover'>
				<ui-popover flush placement='bottom-start'>
					<ui-button slot='trigger' icon='lucide:calendar' iconEnd='lucide:chevron-down'> visitDate
					<ui-date-picker inline bind=visitDate>
				<div.out>
					<p.note> "A `flush` popover takes the calendar's width and leaves the spacing to it."
