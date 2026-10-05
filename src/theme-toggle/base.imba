import { colorScheme } from '../color-scheme.imba'
import '../segmented/base.imba'

# Headless theme switch: an icon-only segmented control for light, dark and
# system, with tooltips, driving `colorScheme` (see color-scheme.imba), so
# every toggle on the page stays in step and the choice is saved.
#
#   <ui-theme-toggle>
#   <ui-theme-toggle system=false>
#
# - `system`: offers 'system' (follow the OS) as a third option
# - `labels`: the tooltips and accessible names, `{ light, dark, system }`
# - `label`: names the group for assistive tech
#
# Emits `change` with 'light', 'dark' or 'system'.
tag ui-theme-toggle-base
	prop system = true
	prop labels = { light: 'Light', dark: 'Dark', system: 'System' }
	prop label = 'Colour scheme'

	def pick scheme
		colorScheme.value = scheme
		emit('change', scheme)

	get items
		let list = [
			{ value: 'light', label: labels.light, icon: 'lucide:sun' }
			{ value: 'dark', label: labels.dark, icon: 'lucide:moon' }
		]
		list.push({ value: 'system', label: labels.system, icon: 'lucide:monitor' }) if system
		list

	def render
		# Without the system option, show what the OS currently resolves to.
		let value = system ? colorScheme.value : (colorScheme.dark ? 'dark' : 'light')
		<self role='group' aria-label=label>
			<ui-segmented.segmented iconOnly items=items value=value @change.stop=pick(e.detail)>
