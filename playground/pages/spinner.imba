import source from './spinner.imba?raw'

tag page-spinner
	<self>
		<demo-page source=source heading='Spinner' intro='ui-spinner is for short waits; it has a role of status and a label for assistive tech.'>
			<demo-section heading='Sizes'>
				<div.row>
					<ui-spinner size='sm'>
					<ui-spinner>
					<ui-spinner size='lg'>

			<demo-section heading='With text'>
				<div.row>
					<ui-spinner size='sm' label='Saving'>
					<span [c:$ui-muted fs:sm]> "Saving changes…"
				<div.out>
					<p.note> "For buttons, use ui-button’s `loading` instead."
