import source from './hover-card.imba?raw'

const team = [
	{ name: 'Ada Lovelace', role: 'Maths', students: 12 }
	{ name: 'Alan Turing', role: 'Computer science', students: 9 }
	{ name: 'Grace Hopper', role: 'Physics', students: 14 }
]

tag page-hover-card
	css
		.person d:flex g:3
		.name fw:600
		.muted c:$ui-muted fs:xs
		.stats d:flex g:4 mt:3 fs:xs c:$ui-muted
			b c:$ui-text fw:600
		.actions d:flex g:2 mt:4
		.link c:$ui-accent td:underline text-underline-offset:2px cursor:pointer
		.team d:flex g:2

	<self>
		<demo-page source=source heading='Hover card' intro='ui-hover-card shows a richer preview while the pointer rests on (or keyboard focus is on) its trigger. It stays open while you move onto it, so its content can be selected or clicked.'>
			<demo-section heading='In a sentence'>
				<p [m:0]>
					"Next lesson: GCSE Maths with "
					<ui-hover-card>
						<a.link slot='trigger' href='/hover-card'> "Ada Lovelace"
						<div.person>
							<ui-avatar name='Ada Lovelace'>
							<div>
								<div.name> "Ada Lovelace"
								<div.muted> "Year 11 · ada@example.com"
						<div.stats>
							<span>
								<b> "24"
								" lessons"
							<span>
								<b> "92%"
								" attendance"
						<div.actions>
							<ui-button size='sm'> "Message"
							<ui-button size='sm' variant='primary'> "View profile"
					", Thursday at 16:00."

			<demo-section heading='Placement and arrow'>
				<div.team>
					for person in team
						<ui-hover-card placement='right' arrow>
							<button slot='trigger' type='button' [p:0 bd:none bg:none rd:full cursor:pointer] aria-label=person.name>
								<ui-avatar name=person.name>
							<div.name> person.name
							<div.muted> "{person.role} · {person.students} students"
