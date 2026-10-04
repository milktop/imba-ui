# Notes on a student, newest last, with a box to add one.
tag feed-notes
	draft = ''
	notes = [
		{ who: 'Grace Hopper', when: '24 Sep', text: 'Worked through ratio problems; still unsure with unequal shares.' }
		{ who: 'Anne Byron', when: '25 Sep', text: 'Thanks! She practised a few more at home.' }
		{ who: 'Grace Hopper', when: '1 Oct', text: 'Much better today. Moving on to percentages next week.' }
	]

	def add
		return unless draft.trim!
		notes = [...notes, { who: 'Grace Hopper', when: 'Just now', text: draft.trim! }]
		draft = ''

	css
		d:flex fld:column g:4 max-width:40rem
		.note d:flex g:3
		.bubble flg:1 p:3 bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius + 4px)
		.head d:flex jc:space-between g:2 fs:xs
		.who fw:600 fs:sm
		.when c:$ui-muted
		.text m:0 mt:1
		.compose d:flex g:3 ai:flex-start
		.box flg:1 d:flex fld:column g:2
		.send d:flex jc:flex-end
	<self>
		for note in notes
			<div.note>
				<ui-avatar size='sm' name=note.who>
				<div.bubble>
					<div.head>
						<span.who> note.who
						<span.when> note.when
					<p.text> note.text
		<div.compose>
			<ui-avatar size='sm' name='Grace Hopper'>
			<div.box>
				<ui-textarea placeholder='Add a note…' rows=2 bind=draft>
				<div.send>
					<ui-button size='sm' variant='primary' disabled=!draft.trim! @click=add> "Add note"

# Recent activity in a card, with a link to everything.
tag feed-activity
	css max-width:28rem
	<self>
		<ui-card heading='Activity'>
			<ui-button slot='actions' size='sm' variant='ghost'> "View all"
			<ui-timeline size='sm' items=[
				{ title: 'Alan paid £140', time: '2h', color: 'success' }
				{ title: 'Grace booked Monday 15:30', time: '5h', color: 'accent' }
				{ title: 'Ada cancelled Thursday', time: '1d', color: 'danger' }
				{ title: 'Radia joined', time: '2d' }
			]>

export const examples = [
	{ heading: 'Notes with a composer', tag: 'feed-notes' }
	{ heading: 'Activity card', tag: 'feed-activity' }
]
