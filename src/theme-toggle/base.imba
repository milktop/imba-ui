import { colorScheme } from '../color-scheme.imba'
# Renders the styled ui-segmented, ui-menu and ui-tooltip, which the styled
# ui-theme-toggle imports.
import '../segmented/base.imba'
import '../menu/base.imba'
import '../tooltip/base.imba'
import 'iconify-icon'

const icons = { light: 'lucide:sun', dark: 'lucide:moon', system: 'lucide:monitor' }

# Headless theme switch for light, dark and system, driving `colorScheme`
# (see color-scheme.imba), so every toggle on the page stays in step and the
# choice is saved.
#
#   <ui-theme-toggle>
#   <ui-theme-toggle options=['light', 'dark', 'system']>
#   <ui-theme-toggle variant='menu'>
#   <ui-theme-toggle mobile='menu'>
#   <ui-theme-toggle variant='toggle'>
#
# - `variant`: 'segmented' (default: icon-only buttons with tooltips), 'menu'
#   (one button showing the current choice, opening a menu of all of them) or
#   'toggle' (one button flipping between light and dark)
# - `mobile`: the variant below `breakpoint` (e.g. 'menu' where space is tight)
# - `breakpoint`: the width in px `mobile` applies under (default 768)
# - `options`: which schemes to offer, in order (default system, light, dark)
# - `system`: false leaves out 'system' (follow the OS) whatever `options` says
# - `labels`: the tooltips and accessible names, `{ light, dark, system }`
# - `label`: names the group for assistive tech
# - `placement`: where the menu variant opens (default 'bottom-end', or
#   'bottom' with `iconOnly`, centring the icons under the button)
# - `keepOpen`: the menu variant stays open after a choice
# - `iconOnly`: the menu variant lists just the icons (their names stay for
#   screen readers and typing to jump), the current one highlighted
#
# Emits `change` with 'light', 'dark' or 'system'.
tag ui-theme-toggle-base
	prop variant = 'segmented'
	prop mobile = null
	prop breakpoint = 768
	prop options = ['system', 'light', 'dark']
	prop system = true
	prop labels = { light: 'Light', dark: 'Dark', system: 'System' }
	prop label = 'Colour scheme'
	prop placement = null
	prop keepOpen = null
	prop iconOnly = false

	narrow = no

	get mode do (mobile and narrow) ? mobile : variant
	get offersSystem do system and (options or []).includes('system')

	def mount
		return unless mobile and globalThis.matchMedia
		#media = globalThis.matchMedia("(max-width: {breakpoint - 1}px)")
		#onMedia = do
			narrow = #media.matches
			render!
		#media.addEventListener('change', #onMedia)
		#onMedia!

	def unmount
		#media..removeEventListener('change', #onMedia)

	def pick scheme
		colorScheme.value = scheme
		emit('change', scheme)

	# The toggle variant switches what's showing, so 'system' becomes an
	# explicit choice.
	def flip do pick(colorScheme.dark ? 'light' : 'dark')

	get items
		(options or []).filter(do icons[$1] and ($1 !== 'system' or system)).map do(scheme)
			{ value: scheme, label: labels[scheme], icon: icons[scheme] }

	def render
		# Without the system option, show what the OS currently resolves to.
		let value = offersSystem ? colorScheme.value : (colorScheme.dark ? 'dark' : 'light')
		let shown = colorScheme.dark ? 'dark' : 'light'
		<self .icon-only=(!!iconOnly and mode === 'menu') role='group' aria-label=label data-variant=mode>
			if mode === 'menu'
				<ui-menu.menu placement=(placement or (iconOnly ? 'bottom' : 'bottom-end')) keepOpen=keepOpen>
					<button.trigger slot='trigger' type='button' aria-label="{label}: {labels[value]}">
						<iconify-icon.trigger-icon icon=icons[value] aria-hidden='true'>
					<ui-menu-radio-group value=value @change=pick(e.detail)>
						for item in items
							<ui-menu-radio key=item.value value=item.value icon=item.icon> item.label
			elif mode === 'toggle'
				<ui-tooltip content=labels[shown]>
					<button.trigger type='button' aria-label=labels.dark aria-pressed=String(colorScheme.dark) @click=flip>
						<iconify-icon.trigger-icon icon=icons[shown] aria-hidden='true'>
			else
				<ui-segmented.segmented iconOnly items=items value=value @change.stop=pick(e.detail)>
