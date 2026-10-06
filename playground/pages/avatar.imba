import source from './avatar.imba?raw'

tag page-avatar
	people = [
		{ name: 'Ada Lovelace', src: 'https://i.pravatar.cc/120?img=47' }
		{ name: 'Alan Turing', src: null }
		{ name: 'Grace Hopper', src: 'https://example.invalid/missing.jpg' }
		{ name: null, src: null }
	]

	css
		.stack d:flex
			ui-avatar ml:-2 outline:2px solid $ui-surface
			ui-avatar:first-child ml:0

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

			<demo-section heading='Stacked'>
				<div.stack>
					<ui-avatar name='Ada Lovelace'>
					<ui-avatar name='Alan Turing'>
					<ui-avatar name='Grace Hopper'>
					<ui-avatar name='Katherine Johnson'>
