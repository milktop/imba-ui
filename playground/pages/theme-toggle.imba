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

			<demo-section heading='Menu'>
				<ui-theme-toggle variant='menu'>
				<div.out>
					<p.note> "One button showing the current choice; it opens a menu of all of them."

			<demo-section heading='Menu of icons'>
				<ui-theme-toggle variant='menu' iconOnly keepOpen>
				<div.out>
					<p.note> "`iconOnly` lists just the icons, and `keepOpen` keeps the menu open after a choice."

			<demo-section heading='Menu on phones'>
				<ui-theme-toggle mobile='menu' iconOnly keepOpen>
				<div.out>
					<p.note> "Segmented on wide screens and a menu (here of icons) below `breakpoint` (768px by default)."

			<demo-section heading='Toggle'>
				<ui-theme-toggle variant='toggle'>
				<div.out>
					<p.note> "One button flipping between light and dark (from System it picks the opposite of what's showing)."

			<demo-section heading='Sizes'>
				<div.row>
					<ui-theme-toggle size='sm'>
					<ui-theme-toggle>
					<ui-theme-toggle size='lg'>
				<div.row>
					<ui-theme-toggle size='sm' variant='menu' iconOnly>
					<ui-theme-toggle variant='menu' iconOnly>
					<ui-theme-toggle size='lg' variant='menu' iconOnly>
					<ui-theme-toggle size='sm' variant='toggle'>
					<ui-theme-toggle variant='toggle'>
					<ui-theme-toggle size='lg' variant='toggle'>
				<div.out>
					<p.note> "`size` ('sm', 'md' or 'lg') applies to every variant, the menu's icons included."

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
