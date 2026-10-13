import source from './locale.imba?raw'
import { uiLocale } from '../../src/locale.imba'

tag page-locale
	revenue = 18420.5
	upload = 2516582
	lastSeen = new Date(Date.now! - 1000 * 60 * 95)
	lesson = '2026-10-14'
	fee = 45
	rooms = ['Library', 'Lab', 'Hall']
	room = null

	<self>
		<demo-page source=source heading='Locale and formatting' intro="uiLocale is the app's locale and the components' words, set once: dates, numbers and every placeholder, empty state and screen-reader label follow it. English and French are built in. The Appearance panel's Language sets it for the whole playground.">
			<demo-section heading='Setting it'>
				<div.row>
					for tag in ['en-GB', 'en-US', 'fr-FR', 'de-DE']
						<ui-button size='sm' variant=(uiLocale.locale == tag ? 'primary' : 'default') @click=uiLocale.set(tag)> tag
				<div.out>
					<p.note> "German has no built-in words, so its dates and numbers change but the words stay English (pass them all to `set` to add a language)."

			<demo-section heading='Numbers, sizes and times'>
				<ui-data-list>
					<ui-data-item label='Revenue'> <ui-format-number value=revenue format={ style: 'currency', currency: 'GBP' }>
					<ui-data-item label='Compact'> <ui-format-number value=1284000 format={ notation: 'compact' }>
					<ui-data-item label='Attendance'> <ui-format-number value=0.923 format={ style: 'percent', maximumFractionDigits: 1 }>
					<ui-data-item label='Upload'> <ui-format-bytes value=upload>
					<ui-data-item label='Last seen'> <ui-format-relative value=lastSeen>
				<div.out>
					<p.note> "As functions too, for strings: formatNumber, formatBytes and formatRelative."

			<demo-section heading='Components follow it'>
				<ui-fields>
					<ui-field span=4 label='Lesson'>
						<ui-date-picker bind=lesson>
					<ui-field span=4 label='Fee'>
						<ui-number-input formatOptions={ style: 'currency', currency: 'EUR' } bind=fee>
					<ui-field span=4 label='Room'>
						<ui-select items=rooms clearable bind=room>
				<ui-table columns=[{ key: 'name', label: 'Name' }] rows=[]>

			<demo-section heading='Changing words'>
				<div.row>
					<ui-button size='sm' @click=uiLocale.set(uiLocale.locale, { table: { empty: 'No pupils yet' }, select: { placeholder: 'Choose one…' } })> "Override two words"
					<ui-button size='sm' @click=uiLocale.set(uiLocale.locale)> "Back to the built-in ones"
				<div.out>
					<p.note> "`uiLocale.set(locale, words)` merges your words over the built-in list; the table and select above change. A component's own text (`emptyText`, `placeholder`) still wins."
