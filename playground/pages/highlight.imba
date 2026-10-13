import source from './highlight.imba?raw'

const students = ['Ada Lovelace', 'Alan Turing', 'Grace Hopper', 'Katherine Johnson', 'Mary Somerville', 'Hedy Lamarr']

tag page-highlight
	search = 'ar'

	css
		ul m:0 p:0 list-style:none d:vflex g:1.5 fs:sm

	<self>
		<demo-page source=source heading='Highlight' intro='ui-highlight marks the parts of a text that match a search, e.g. in results.'>
			<demo-section heading='Search results'>
				<ui-input icon='lucide:search' placeholder='Search students' bind=search>
				<ul> for name in students.filter(do $1.toLowerCase!.includes(search.toLowerCase!))
					<li> <ui-highlight text=name query=search>

			<demo-section heading='Colours'>
				<div.row>
					<ui-highlight text='Accent, the default' query='Accent'>
					<ui-highlight text='Yellow marker' query='Yellow' color='yellow'>
					<ui-highlight text='Green for a match' query='Green' color='green'>
					<ui-highlight text='Any CSS colour' query='CSS' color='#f0abfc'>
