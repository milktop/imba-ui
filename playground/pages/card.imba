import source from './card.imba?raw'

tag page-card
	variants = [
		['default', 'A bordered surface, for most things.']
		['elevated', 'Lifted by a shadow, for what should stand out.']
		['outline', 'Just a border, quiet on the canvas.']
		['subtle', 'A tinted fill, for a panel inside a page or card.']
	]
	links = [
		{ icon: 'lucide:users', heading: 'Students', description: '31 active, 3 new this month' }
		{ icon: 'lucide:calendar', heading: 'Calendar', description: '14 lessons this week' }
		{ icon: 'lucide:wallet', heading: 'Billing', description: '£320 outstanding' }
	]

	css
		.grid d:grid gtc:1fr @md:1fr 1fr g:4 w:100%
		.tiles d:grid gtc:repeat(auto-fit, minmax(12rem, 1fr)) g:4 w:100%

	<self>
		<demo-page source=source heading='Card' intro='ui-card groups related content, with an optional header, actions and footer.'>
			<demo-section heading='Header, body and footer' bare>
				<div.grid>
					<ui-card heading='Next lesson' description='Thursday 8 October, 16:00'>
						<ui-button slot='actions' size='sm' variant='ghost' icon='lucide:ellipsis' aria-label='More'>
						<div.row>
							<ui-avatar size='sm' name='Ada Lovelace'>
							<span> "Maths with Ada, Room 4"
						<div slot='footer'>
							<ui-button size='sm'> "Reschedule"
							<ui-button size='sm' variant='primary'> "Join"
					<ui-card heading='This month' description='Lessons taught'>
						<div [fs:3xl fw:700]> "52"
						<ui-progress showValue value=78 label='Monthly goal'>

			<demo-section heading='Body only' bare>
				<ui-card>
					"A plain card is just a bordered surface; give it any content."

			<demo-section heading='Icon and divider'>
				<ui-card icon='lucide:receipt' heading='Invoice #1042' description='Ada Lovelace · due 15 October' divided [max-width:28rem]>
					<ui-badge slot='actions' variant='warning' dot> "Unpaid"
					<div [d:flex ai:baseline jc:space-between]>
						<span [c:$ui-muted]> "4 lessons × £35"
						<span [fs:2xl fw:700]> "£140"
					<div slot='footer'>
						<ui-button size='sm' variant='ghost'> "Download"
						<ui-button size='sm' variant='primary' icon='lucide:send'> "Send reminder"
				<div.out>
					<p.note> "`icon` puts a tinted tile beside the heading; `divided` draws a line under the header. The footer sits on a faint band."

			<demo-section heading='Variants' bare>
				<div.tiles>
					for [variant, text] in variants
						<ui-card variant=variant heading=(variant[0].toUpperCase! + variant.slice(1))>
							<p [m:0 c:$ui-muted]> text

			<demo-section heading='As links' bare>
				<div.tiles>
					for link in links
						<ui-card size='sm' href='/card' icon=link.icon heading=link.heading description=link.description>
				<div.out>
					<p.note> "With `href` the whole card is a link: it lifts on hover. `size` ('sm', 'md' or 'lg') sets the padding."
