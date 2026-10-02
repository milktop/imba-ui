import source from './date-picker.imba?raw'

tag page-date-picker
	lesson = '2026-10-02'
	away = []
	start = null

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
