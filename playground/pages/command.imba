import source from './command.imba?raw'

const people = ['Ada Lovelace', 'Alan Turing', 'Grace Hopper', 'Katherine Johnson', 'Margaret Hamilton', 'Tim Berners-Lee', 'Edsger Dijkstra', 'Barbara Liskov']

# Pretends to be a server: matching people, after a short wait.
def findPeople query
	await new Promise(do(done) setTimeout(done, 300))
	let q = query.trim!.toLowerCase!
	people.filter(do $1.toLowerCase!.includes(q)).map do(name)
		{ label: name, value: name, icon: 'lucide:user', description: 'Student' }

tag page-command
	open = no
	picked = null
	searching = no
	person = null

	actions = [
		{ label: 'New lesson', value: 'new-lesson', icon: 'lucide:calendar-plus', shortcut: 'N', group: 'Lessons' }
		{ label: 'Reschedule lesson', value: 'reschedule', icon: 'lucide:calendar-clock', group: 'Lessons', keywords: ['move', 'change'] }
		{ label: 'Cancel lesson', value: 'cancel', icon: 'lucide:calendar-x', group: 'Lessons' }
		{ label: 'Add student', value: 'add-student', icon: 'lucide:user-plus', group: 'Students' }
		{ label: 'Import students', value: 'import', icon: 'lucide:upload', group: 'Students', disabled: yes, description: 'Coming soon' }
		{ label: 'Send invoice', value: 'invoice', icon: 'lucide:receipt', group: 'Billing', keywords: ['payment', 'bill'] }
	]

	<self>
		<demo-page source=source heading='Command menu' intro='ui-command opens a search box over a list of commands. Press ⌘K (Ctrl+K) anywhere in this playground to jump to a page or run an action; the search button in the top bar opens the same one.'>
			<demo-section heading='With a trigger'>
				<p.note> "Type to filter (words match the label, description, group and keywords), ↑/↓ to move, Enter to pick. Set `hotkey=null` when another menu owns ⌘K, as here."
				<ui-command items=actions hotkey=null @select=(picked = e.detail)>
					<ui-button slot='trigger' icon='lucide:terminal'> "Lesson actions"
				<div.out>
					<json-print data={ picked }>

			<demo-section heading='Opened from code'>
				<ui-command items=actions hotkey=null bind=open @select=(picked = e.detail)>
				<ui-button @click=(open = yes)> "Open it"
				<div.out>
					<json-print data={ open, picked }>

			<demo-section heading='Server search'>
				<p.note> "With `load`, each search calls an async function (debounced) for the results."
				<ui-command load=findPeople hotkey=null placeholder='Search students…' emptyText='No students found' bind=searching @select=(person = e.detail)>
				<ui-button icon='lucide:search' @click=(searching = yes)> "Find a student"
				<div.out>
					<json-print data={ person }>
