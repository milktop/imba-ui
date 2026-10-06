import source from './theme-toggle.imba?raw'
import { colorScheme } from '../../src/color-scheme.imba'

tag page-theme-toggle
	picked = null

	<self>
		<demo-page source=source heading='Theme toggle' intro='ui-theme-toggle switches between light, dark and the OS setting. It drives colorScheme, so every toggle on the page (and the Appearance panel) stays in step, and the choice is saved.'>
			<demo-section heading='Basic'>
				<ui-theme-toggle @change=(picked = e.detail)>
				<div.out>
					<json-print data={ picked, scheme: colorScheme.value, dark: colorScheme.dark }>

			<demo-section heading='Order'>
				<ui-theme-toggle options=['light', 'dark', 'system']>
				<div.out>
					<p.note> "`options` sets which schemes show and their order; the default is system, light, dark."

			<demo-section heading='Light and dark only'>
				<ui-theme-toggle system=false>
				<div.out>
					<p.note> "Or `options=['light', 'dark']`."

			<demo-section heading='Labels'>
				<ui-theme-toggle labels={ light: 'Clair', dark: 'Sombre', system: 'Système' } label='Thème'>
