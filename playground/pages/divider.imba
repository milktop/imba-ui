import source from './divider.imba?raw'

tag page-divider
	<self>
		<demo-page source=source heading='Divider' intro='ui-divider is a line between things: across, between sections, or up, between toolbar buttons; with an optional label.'>
			<demo-section heading='Across'>
				<p> "Lesson notes"
				<ui-divider>
				<p> "Homework"

			<demo-section heading='With a label'>
				<ui-button block icon='mdi:google'> "Continue with Google"
				<ui-divider label='or'>
				<ui-input placeholder='Email address'>
				<ui-divider label='Today' align='start' variant='dashed'>
				<ui-divider label='Earlier' align='end' variant='dotted'>

			<demo-section heading='Up, between buttons'>
				<div.row>
					<ui-button variant='ghost' icon='lucide:bold' aria-label='Bold'>
					<ui-button variant='ghost' icon='lucide:italic' aria-label='Italic'>
					<ui-divider orientation='vertical'>
					<ui-button variant='ghost' icon='lucide:list' aria-label='List'>
					<ui-button variant='ghost' icon='lucide:link' aria-label='Link'>
