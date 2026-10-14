import { colorScheme } from '../color-scheme.imba'
import { appearance, accents as allAccents, sidebarStyles as allSidebars } from '../appearance.imba'
# Renders the styled ui-popover, ui-button, ui-segmented, ui-swatch-picker,
# ui-native-select and ui-switch, which the styled ui-appearance imports.
import '../popover/base.imba'
import '../button/base.imba'
import '../segmented/base.imba'
import '../swatch-picker/base.imba'
import '../native-select/base.imba'
import '../switch/base.imba'
import { uiLocale } from '../locale.imba'

const schemeIcons = { system: 'lucide:monitor', light: 'lucide:sun', dark: 'lucide:moon' }

# Headless appearance panel: light or dark (colorScheme), the accent colour
# and the sidebar style (appearance), behind one button.
#
#   <ui-appearance accents=['teal', 'blue', 'violet'] sidebars=['neutral-accent', 'tint', 'dark']>
#   <ui-appearance dev>
#
# - `accents`, `sidebars`: what users may choose, by name (every one if left
#   out; see `accents` and `sidebarStyles` in appearance.imba). A saved
#   choice outside them moves to their first item, so put the default first.
# - `dev`: for trying themes out while building the app; take it off before
#   shipping. Offers every accent and sidebar style whatever the lists say,
#   any colour, a reset, and the `accents` and `sidebars` to paste for the
#   current choice. Its switch turns dev mode off to preview what users get.
# - `schemes`: false leaves out light and dark (e.g. with ui-theme-toggle
#   elsewhere)
# - `placement`: where the panel opens (default 'bottom-end')
# - `labels`: words over uiLocale's `appearance` ones
#
# Emits `change` with appearance's value when the user changes it.
tag ui-appearance-base
	prop accents = null
	prop sidebars = null
	prop dev = false
	prop schemes = true
	prop placement = 'bottom-end'
	prop labels = null

	devMode = yes

	get words do Object.assign({}, uiLocale.messages.appearance, labels)
	get schemeWords do uiLocale.messages.themeToggle

	get exploring do !!dev and devMode

	# In the lists' own order (the first is the fallback), or every one
	get accentNames do (exploring or !accents) ? Object.keys(allAccents) : accents.filter(do allAccents[$1])
	get sidebarNames do (exploring or !sidebars) ? allSidebars : sidebars.filter(do allSidebars.includes($1))

	get schemeItems do ['system', 'light', 'dark'].map(do { value: $1, label: schemeWords[$1], icon: schemeIcons[$1] })
	get accentItems do accentNames.map(do { value: $1, label: words.accents[$1] ?? $1, color: allAccents[$1][0][6] })
	get sidebarItems do sidebarNames.map(do { value: $1, label: words.sidebars[$1] ?? $1 })

	# The current choice as code to paste into the app: the props that offer
	# it, or for a custom colour, the default that sets it.
	get config
		let sidebar = "sidebars=['{appearance.sidebar}']"
		return "accents=['{appearance.accent}'] {sidebar}" unless appearance.custom
		"appearance.defaults = " + JSON.stringify({ custom: appearance.custom, sidebar: appearance.sidebar })

	def mount do restrict!

	def restrict
		appearance.restrict(accentNames, sidebarNames) unless exploring

	def setDevMode on
		devMode = on
		restrict!

	def pick changes
		appearance.update(changes)
		emit('change', appearance.value)

	def render
		<self>
			<ui-popover.popover heading=words.label placement=placement>
				<ui-button.trigger slot='trigger' variant='ghost' icon='lucide:palette' aria-label=words.label>
				<div.panel>
					if schemes
						<div.setting>
							<div.label> words.mode
							<ui-segmented size='sm' items=schemeItems value=colorScheme.value
								@change.stop=(colorScheme.value = e.detail)>
					<div.setting>
						<div.label> words.accent
						<ui-swatch-picker size='sm' items=accentItems value=(appearance.custom ? null : appearance.accent)
							@change.stop=pick(accent: e.detail, custom: null)>
					if exploring
						<label.custom>
							<input type='color' value=(appearance.custom or appearance.scale[6])
								@input=pick(custom: e.target.value)>
							<span> words.custom
							<code> appearance.custom if appearance.custom
					<div.setting>
						<div.label>
							<span> words.sidebar
							<span.hint> words.lightOnly if colorScheme.dark
						if sidebarItems.length <= 4
							<ui-segmented size='sm' items=sidebarItems value=appearance.sidebar
								@change.stop=pick(sidebar: e.detail)>
						else
							<ui-native-select size='sm' items=sidebarItems value=appearance.sidebar
								@change.stop=pick(sidebar: e.detail)>
					if dev
						<div.dev>
							<ui-switch label=words.dev checked=devMode @change.stop=setDevMode(e.detail)>
							if exploring
								<code.config> config
								<ui-button size='sm' @click=(appearance.reset!, emit('change', appearance.value))> words.reset
