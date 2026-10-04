# Empty and error states: a first run, a search with no results, a failed
# load and a page that doesn't exist.
tag block-empty-states
	css
		d:grid gtc:repeat(auto-fit, minmax(18rem, 1fr)) g:4
		.wide gc:1 / -1
		.notfound d:flex fld:column ai:center ta:center py:12
		.code fs:5xl fw:800 ls:-0.03em c:$ui-accent lh:1
		h2 m:0 mt:4 fs:xl fw:700
		p m:0 mt:2 c:$ui-muted fs:sm max-width:24rem
		.actions d:flex g:2 mt:6 flw:wrap jc:center

	<self>
		<ui-card>
			<ui-empty-state icon='lucide:users' heading='No students yet' description='Add your first student to start booking lessons.'>
				<div slot='actions'>
					<ui-button icon='lucide:upload'> "Import"
					<ui-button variant='primary' icon='lucide:user-plus'> "Add student"
		<ui-card>
			<ui-empty-state icon='lucide:search-x' heading='No results for “quantum”' description='Check the spelling or try fewer words.'>
				<ui-button slot='actions' variant='ghost'> "Clear search"
		<ui-alert.wide variant='danger' heading='Couldn’t load invoices' dismissible>
			"The server didn’t respond. Your data is safe; try again in a moment."
			<ui-button slot='actions' size='sm'> "Retry"
		<ui-card.wide>
			<div.notfound>
				<span.code> "404"
				<h2> "Page not found"
				<p> "The page you’re looking for doesn’t exist or has moved."
				<div.actions>
					<ui-button icon='lucide:arrow-left'> "Go back"
					<ui-button variant='primary' icon='lucide:house'> "Dashboard"
