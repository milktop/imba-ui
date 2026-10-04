import source from './banner.imba?raw'

tag page-banner
	shown = yes

	<self>
		<demo-page source=source heading='Banner' intro='ui-banner is a slim, prominent strip for an announcement or a page-wide message, such as across the top of the content. For a message within the content, use ui-alert.'>
			<demo-section heading='Announcement'>
				<ui-banner icon='lucide:sparkles' dismissible bind=shown>
					"Lesson notes can now be shared with parents. "
					<a href='#'> "See how"
				<div.out>
					<json-print data={ shown }>
					<div.set>
						<button @click=(shown = yes)> "Show it again"

			<demo-section heading='Variants'>
				<div [d:flex fld:column g:2 w:100%]>
					<ui-banner icon='lucide:megaphone'> "Accent: the default, for news."
					<ui-banner variant='soft' icon='lucide:info'> "Soft: quieter, for tips."
					<ui-banner variant='neutral' icon='lucide:calendar'> "Neutral: half term starts on 26 October."
					<ui-banner variant='success' icon='lucide:circle-check'> "Success: your calendar is connected."
					<ui-banner variant='warning' icon='lucide:triangle-alert'> "Warning: your card expires this month."
					<ui-banner variant='danger' icon='lucide:circle-x'> "Danger: payouts are paused until you add your bank details."

			<demo-section heading='With actions'>
				<ui-banner variant='warning' icon='lucide:credit-card'>
					"Your trial ends in 3 days."
					<div slot='actions'>
						<ui-button size='sm' variant='ghost'> "Later"
						<ui-button size='sm'> "Choose a plan"

			<demo-section heading='Edge to edge'>
				<ui-banner full variant='soft' icon='lucide:wrench'> "Scheduled maintenance on Sunday, 06:00–07:00."
