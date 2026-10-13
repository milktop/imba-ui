import source from './kbd.imba?raw'

tag page-kbd
	<self>
		<demo-page source=source heading='Kbd' intro='ui-kbd shows a key, or a shortcut of several, e.g. in help text and menus.'>
			<demo-section heading='Keys and shortcuts'>
				<div.row>
					<ui-kbd> "Esc"
					<ui-kbd keys=['⌘', 'K']>
					<ui-kbd keys=['Ctrl', 'Shift', 'P']>
					<ui-kbd keys=['⌘', 'K'] size='sm'>

			<demo-section heading='In text'>
				<p>
					"Press "
					<ui-kbd keys=['⌘', 'B']>
					" to fold the sidebar, or "
					<ui-kbd> "?"
					" for every shortcut."
