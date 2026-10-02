import source from './tooltip.imba?raw'

tag page-tooltip
	css
		.toolbar d:inline-flex g:0.5 p:1 bd:1px solid $ui-border rd:$ui-radius
		# Spaced out so each placement's tooltip has room.
		.placements d:hflex flw:wrap g:2 12

	<self>
		<demo-page source=source heading='Tooltip' intro='ui-tooltip shows a short hint on hover or keyboard focus. It puts Zag’s props straight onto the element inside it, so a button keeps its own label and clicks.'>
			<demo-section heading='Toolbar'>
				<div.toolbar>
					<ui-tooltip content='Bold'>
						<ui-button variant='ghost' icon='lucide:bold' aria-label='Bold'>
					<ui-tooltip content='Italic'>
						<ui-button variant='ghost' icon='lucide:italic' aria-label='Italic'>
					<ui-tooltip content='Underline'>
						<ui-button variant='ghost' icon='lucide:underline' aria-label='Underline'>
					<ui-tooltip content='Insert link'>
						<ui-button variant='ghost' icon='lucide:link' aria-label='Insert link'>
					<ui-tooltip content='Clear formatting'>
						<ui-button variant='ghost' icon='lucide:remove-formatting' aria-label='Clear formatting'>
				<div.out>
					<p.note> "Slide along the toolbar: each tooltip animates in as the last one hides."

			<demo-section heading='Placements'>
				<div.placements>
					<ui-tooltip content='Top'>
						<ui-button> "Top"
					<ui-tooltip content='Right' placement='right'>
						<ui-button> "Right"
					<ui-tooltip content='Bottom' placement='bottom'>
						<ui-button> "Bottom"
					<ui-tooltip content='Left' placement='left'>
						<ui-button> "Left"

			<demo-section heading='Interactive'>
				<ui-tooltip interactive placement='right'>
					<ui-button icon='lucide:key-round'> "Booking code"
					<div slot='content'>
						"Code "
						<strong> "TUT-4821-XQ"
						" (select to copy)"
				<div.out>
					<p.note> "Stays open while the pointer is over it, so its text can be selected."

			<demo-section heading='Rich content and a delay'>
				<ui-tooltip placement='top-start' openDelay=300>
					<ui-button> "Rich content"
					<div slot='content'>
						<strong> "Keyboard"
						<div> "Tab here to open it without hovering"
