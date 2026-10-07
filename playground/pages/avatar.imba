import source from './avatar.imba?raw'

tag page-avatar
	people = [
		{ name: 'Ada Lovelace', src: 'https://i.pravatar.cc/120?img=47' }
		{ name: 'Alan Turing', src: null }
		{ name: 'Grace Hopper', src: 'https://example.invalid/missing.jpg' }
		{ name: null, src: null }
	]

	team = ['Ada Lovelace', 'Alan Turing', 'Grace Hopper', 'Katherine Johnson', 'Margaret Hamilton', 'Tim Berners-Lee']

	<self>
		<demo-page source=source heading='Avatar' intro='ui-avatar shows an image, or initials from `name` while it loads and if it fails; with no name, a person icon.'>
			<demo-section heading='Image and fallbacks'>
				<div.row>
					for person in people
						<ui-avatar src=person.src name=person.name>
				<div.out>
					<p.note> "Ada has a photo, Alan has none, Grace’s fails to load, and the last has no name."

			<demo-section heading='Sizes'>
				<div.row>
					<ui-avatar size='sm' name='Ada Lovelace'>
					<ui-avatar name='Ada Lovelace'>
					<ui-avatar size='lg' name='Ada Lovelace'>
					<ui-avatar size='xl' name='Ada Lovelace'>
				<div.row>
					<ui-avatar size=6 name='Ada Lovelace'>
					<ui-avatar size=8 name='Ada Lovelace'>
					<ui-avatar size=12 name='Ada Lovelace'>
					<ui-avatar size=24 name='Ada Lovelace'>

			<demo-section heading='One letter'>
				<div.row>
					<ui-avatar letters=1 name='Ada Lovelace'>
					<ui-avatar letters=1 name='Maths Club' square>

			<demo-section heading='Colours'>
				<div.row>
					for c in ['accent', 'gray', 'red', 'orange', 'amber', 'green', 'teal', 'blue', 'purple', 'pink']
						<ui-avatar color=c name=c>
				<div.row>
					for n in ['Ada Lovelace', 'Alan Turing', 'Grace Hopper', 'Katherine Johnson', 'Edsger Dijkstra', 'Barbara Liskov', 'Donald Knuth', 'Margaret Hamilton']
						<ui-avatar color='auto' name=n>

			<demo-section heading='Stacked, with tooltips'>
				<ui-avatar-group items=team max=4 tooltip color='auto'>
				<div.out>
					<p.note> "ui-avatar-group overlaps them, rings each in the page colour ($ui-avatar-ring), and folds the rest into a “+N” whose tooltip lists them."

			<demo-section heading='Group sizes and spacing'>
				<div [d:vflex g:4 ai:flex-start]>
					<ui-avatar-group items=team.slice(0, 5) size='sm' max=3>
					<ui-avatar-group items=team.slice(0, 5) size='lg' spacing='tight' color='auto'>
					<ui-avatar-group items=team.slice(0, 5) spacing='loose' square letters=1>
					<ui-avatar-group>
						<ui-avatar name='Ada Lovelace' src='https://i.pravatar.cc/120?img=47'>
						<ui-avatar tooltip='Katherine Johnson (owner)' name='Katherine Johnson' color='teal'>
				<div.out>
					<p.note> "`size` and `spacing` ('tight', 'normal' or 'loose'); or put ui-avatars in it yourself."
