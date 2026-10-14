import source from './appearance-panel.imba?raw'
import { appearance } from '../../src/appearance.imba'

tag page-appearance-panel
	picked = null

	<self>
		<demo-page source=source heading='Appearance' intro="ui-appearance gathers light and dark, the accent colour and the sidebar style behind one button. The accent becomes the $ui-accent-50 … -950 scale on <html>, so every accent token follows it; the sidebar styles recolour this page's own sidebar (in light mode). The choice is saved, and `appearance.onchange` can save it for the user on your server.">
			<demo-section heading='For users'>
				<ui-appearance accents=['teal', 'blue', 'violet', 'rose'] sidebars=['neutral', 'tint', 'dark'] @change=(picked = e.detail)>
				<div.out>
					<json-print data={ picked, appearance: appearance.value }>
					<p.note> "`accents` and `sidebars` list what users may choose, the default first: a saved choice outside them moves to it."

			<demo-section heading='Dev mode'>
				<ui-appearance dev accents=['teal', 'blue'] sidebars=['neutral', 'dark']>
				<div.out>
					<p.note> "`dev` offers every accent and sidebar style, any colour, a reset, and the props to paste for the current choice. Its switch previews what users get. Take it off before shipping."

			<demo-section heading='Without light and dark'>
				<ui-appearance schemes=false>
				<div.out>
					<p.note> "`schemes=false` leaves light and dark to a ui-theme-toggle elsewhere."
