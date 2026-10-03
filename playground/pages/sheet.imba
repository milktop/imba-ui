import source from './sheet.imba?raw'

const lessons = [
	{ date: 'Thu 8 Oct', topic: 'Fractions and decimals' }
	{ date: 'Thu 1 Oct', topic: 'Ratio and proportion' }
	{ date: 'Thu 24 Sep', topic: 'Percentages' }
	{ date: 'Thu 17 Sep', topic: 'Negative numbers' }
	{ date: 'Thu 10 Sep', topic: 'Place value' }
]

tag page-sheet
	editing = no
	filtersOpen = no
	sideOpen = no
	side = 'left'
	student = { name: 'Ada Lovelace', email: 'ada@example.com', year: 11, notes: 'Prefers worked examples.' }
	draft = {}
	subjects = ['maths']

	def startEdit do draft = Object.assign({}, student)
	def save
		student = draft
		editing = no

	def openSide value
		side = value
		sideOpen = yes

	css
		.history d:flex fld:column g:3 m:0 p:0 list-style:none
			li d:flex jc:space-between g:4 pb:3 bdb:1px solid $ui-border
			span c:$ui-muted

	<self>
		<demo-page source=source heading='Sheet' intro='ui-sheet slides a panel in from an edge of the screen, for viewing or editing something without leaving the page. Like a dialog it traps focus, and Escape or the backdrop closes it.'>
			<demo-section heading='Edit form'>
				<ui-sheet heading='Edit student' description='Changes are saved to their profile.' bind=editing @openchange=(startEdit! if e.detail)>
					<ui-button slot='trigger' icon='lucide:pencil'> "Edit student"
					<ui-fields>
						<ui-field label='Name' bind=draft.name>
						<ui-field span=8 label='Email' type='email' bind=draft.email>
						<ui-field span=4 label='Year' type='number' min=7 max=13 bind=draft.year>
						<ui-field label='Notes' type='textarea' bind=draft.notes>
					<h3 [fs:sm fw:600 mt:8 mb:3]> "Recent lessons"
					<ul.history> for lesson in lessons
						<li>
							lesson.topic
							<span> lesson.date
					<div slot='footer'>
						<ui-button @click=(editing = no)> "Cancel"
						<ui-button variant='primary' @click=save> "Save"
				<div.out>
					<json-print data={ student }>

			<demo-section heading='Sides'>
				<div.row>
					<ui-button @click=openSide('left')> "Left"
					<ui-button @click=openSide('right')> "Right"
					<ui-button @click=openSide('top')> "Top"
					<ui-button @click=openSide('bottom')> "Bottom"
				<ui-sheet side=side size=(side == 'left' ? 'sm' : 'md') heading="From the {side}" bind=sideOpen>
					<p [m:0 c:$ui-muted]> "Left and right sheets are full height; top and bottom ones fit their content. `size` sets the width (or height): sm, md or lg."

			<demo-section heading='Filters, without a header'>
				<ui-sheet side='right' size='sm' bind=filtersOpen>
					<ui-button slot='trigger' icon='lucide:sliders-horizontal'> "Filters"
					<ui-checkbox-group label='Subjects' items=[{ value: 'maths', label: 'Maths' }, { value: 'english', label: 'English' }, { value: 'science', label: 'Science' }] bind=subjects>
					<div slot='footer'>
						<ui-button variant='primary' @click=(filtersOpen = no)> "Show results"
				<div.out>
					<json-print data={ subjects }>
