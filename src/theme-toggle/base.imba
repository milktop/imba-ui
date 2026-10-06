import { colorScheme } from '../color-scheme.imba'
import '../segmented/base.imba'

# Headless theme switch: an icon-only segmented control for light, dark and
# system, with tooltips, driving `colorScheme` (see color-scheme.imba), so
# every toggle on the page stays in step and the choice is saved.
#
#   <ui-theme-toggle>
#   <ui-theme-toggle options=['light', 'dark', 'system']>
#   <ui-theme-toggle system=false>
#
# - `options`: which schemes to offer, in order (default system, light, dark)
# - `system`: false leaves out 'system' (follow the OS) whatever `options` says
# - `labels`: the tooltips and accessible names, `{ light, dark, system }`
# - `label`: names the group for assistive tech
#
# Emits `change` with 'light', 'dark' or 'system'.
tag ui-theme-toggle-base
	prop options = ['system', 'light', 'dark']
	prop system = true
	prop labels = { light: 'Light', dark: 'Dark', system: 'System' }
	prop label = 'Colour scheme'

	def pick scheme
		colorScheme.value = scheme
		emit('change', scheme)

	get offersSystem do system and (options or []).includes('system')

	get items
		let icons = { light: 'lucide:sun', dark: 'lucide:moon', system: 'lucide:monitor' }
		(options or []).filter(do icons[$1] and ($1 !== 'system' or system)).map do(scheme)
			{ value: scheme, label: labels[scheme], icon: icons[scheme] }

	def render
		# Without the system option, show what the OS currently resolves to.
		let value = offersSystem ? colorScheme.value : (colorScheme.dark ? 'dark' : 'light')
		<self role='group' aria-label=label>
			<ui-segmented.segmented iconOnly items=items value=value @change.stop=pick(e.detail)>
