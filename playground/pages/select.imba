import source from './select.imba?raw'

const students = [
	{ id: 1, name: 'Ada Lovelace', level: 'A Level' }
	{ id: 2, name: 'Alan Turing', level: 'GCSE' }
	{ id: 3, name: 'Grace Hopper', level: 'GCSE', disabled: yes }
	{ id: 4, name: 'Katherine Johnson', level: 'A Level' }
	{ id: 5, name: 'Tim Berners-Lee', level: 'IB' }
]

const cities = ['Aberdeen', 'Bath', 'Belfast', 'Brighton', 'Bristol', 'Cambridge', 'Cardiff', 'Edinburgh', 'Glasgow', 'Leeds', 'Liverpool', 'London', 'Manchester', 'Norwich', 'Oxford', 'York'].map(do(name, id) { id, name })

# Stands in for fetch("/cities?q={query}").
def searchCities query
	await new Promise(do setTimeout($1, 400))
	cities.filter(do $1.name.toLowerCase!.includes(query.toLowerCase!)).slice(0, 6)

# An option's content: name and level.
tag student-option
	prop item
	css d:flex fld:column
		.level fs:xs c:$ui-muted
	<self>
		<span> item.name
		<span.level> item.level

# The create option's content.
tag room-create
	prop query
	<self>
		<span [c:$ui-muted]> "Add room "
		<b> query

tag page-select
	level = null
	studentId = 2
	days = ['Mon', 'Wed']
	subjects = ['Maths']
	examLevel = 'GCSE'
	room = 'Library'
	searchedId = null
	picked = ['Maths']
	cityId = null
	topics = ['Algebra', 'Geometry', 'Statistics']
	pickedTopics = ['Algebra']
	rooms = [{ id: 1, name: 'Library' }, { id: 2, name: 'Lab' }]
	roomId = null

	# Add it to the list and return it, so it's picked too.
	def addTopic name
		topics = [...topics, name]
		name

	# Stands in for saving it: POST /rooms, then the saved room.
	def saveRoom name
		await new Promise(do setTimeout($1, 300))
		let saved = { id: rooms.length + 1, name }
		rooms = [...rooms, saved]
		saved

	css
		.grid d:grid gtc:1fr @sm:1fr 1fr g:5 6 w:100% ai:start

	<self>
		<demo-page source=source heading='Select' intro='ui-select picks one or several items from a list: a button that opens it, or, with `searchable`, `load` or `oncreate`, an input that filters it. It binds the items’ own values.'>
			<demo-section heading='Strings and objects'>
				<div.grid>
					<ui-select label='Level' items=['Key Stage 3', 'GCSE', 'A Level', 'IB'] bind=level>
					<ui-select label='Student' items=students labelKey='name' valueKey='id' bind=studentId>
				<div.out>
					<json-print data={ level, studentId }>
					<p.note> "Plain strings, or objects with `labelKey` and `valueKey`; the bound value is the item’s own (a number here). Grace is disabled."

			<demo-section heading='Several, toggling and clearing'>
				<div.grid>
					<ui-select label='Days' multiple items=['Mon', 'Tue', 'Wed', 'Thu', 'Fri'] bind=days>
					<ui-select label='Subjects' multiple tags variant='accent' hideSelected items=['Maths', 'Physics', 'Chemistry', 'Biology'] bind=subjects>
					<ui-select label='Level' deselectable items=['GCSE', 'A Level', 'IB'] bind=examLevel>
					<ui-select label='Room' clearable items=['Library', 'Lab', 'Online'] bind=room>
				<div.out>
					<json-print data={ days, subjects, examLevel, room }>
					<p.note> "`multiple` binds an array, with picks ticked in the list, or shown as `tags`; `hideSelected` takes them out of the list. Enter picks a run (the highlight keeps its place) and Backspace removes the last pick. `deselectable` lets a second click clear the pick; `clearable` adds a clear button."

			<demo-section heading='Searchable'>
				<div.grid>
					<ui-select label='Student' items=students labelKey='name' valueKey='id' searchable clearable bind=searchedId>
					<ui-select label='Subjects' items=['Biology', 'Chemistry', 'English', 'French', 'Geography', 'History', 'Maths', 'Physics'] searchable multiple hideSelected variant='accent' placeholder='Add a subject…' bind=picked>
				<div.out>
					<json-print data={ searchedId, picked }>
					<p.note> "`searchable` turns it into an input that filters the list (labels starting with the text first). With `multiple`, the picks show as tags."

			<demo-section heading='Server search'>
				<div.grid>
					<ui-select label='City' load=searchCities labelKey='name' valueKey='id' placeholder='Search cities…' bind=cityId>
				<div.out>
					<json-print data={ cityId }>
					<p.note> "`load` is an async function(query) returning items: here a fake API with a delay. It’s debounced, shows “Loading…”, and only the latest answer counts."

			<demo-section heading='Creating'>
				<div.grid>
					<ui-select label='Topics' items=topics multiple oncreate=(do(name) addTopic(name)) placeholder='Add a topic…' bind=pickedTopics>
					<ui-select label='Room' items=rooms labelKey='name' valueKey='id' oncreate=(do(name) saveRoom(name)) createTag='room-create' bind=roomId>
				<div.out>
					<json-print data={ pickedTopics, roomId, rooms: rooms.length }>
					<p.note> "`oncreate` offers “Create …” for text that matches nothing, and hands you the text. Return the new item to select it (or a promise of it, after saving); `createTag` changes the option’s content."

			<demo-section heading='Custom items'>
				<div.grid>
					<ui-select label='Student' items=students labelKey='name' valueKey='id' value=1 itemTag='student-option'>
				<div.out>
					<p.note> "`itemTag` renders each option, given `item`."
