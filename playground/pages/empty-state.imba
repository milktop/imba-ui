import source from './empty-state.imba?raw'

tag page-empty-state
	<self>
		<demo-page source=source heading='Empty state' intro='ui-empty-state fills a list or page that has nothing in it yet, and says what to do next.'>
			<demo-section heading='First use'>
				<ui-empty-state icon='lucide:calendar-plus' heading='No lessons yet' description='Book your first lesson to see it here, or share your booking link with a student.'>
					<ui-button variant='primary' icon='lucide:plus'> "Book a lesson"
					<ui-button icon='lucide:link'> "Copy booking link"

			<demo-section heading='No results'>
				<ui-empty-state icon='lucide:search-x' heading='No students match “zz”' description='Check the spelling or clear the filters.'>
					<ui-button size='sm' variant='ghost'> "Clear filters"
