import '@fontsource-variable/inter'
import '@fontsource-variable/plus-jakarta-sans'

# The playground's appearance switcher: theme, accent, font, radius and
# density, all by overriding the library's $ui-* tokens on <html>, which is
# exactly what an app would do in its own CSS.

# Each accent has light and dark values for the accent tokens and focus ring.
export const accents = {
	indigo: { name: 'Indigo', light: ['#4f46e5', 'white', '#e0e7ff', '#3730a3', '#6366f1'], dark: ['#6366f1', 'white', '#312e81', '#c7d2fe', '#818cf8'] }
	teal: { name: 'Teal', light: ['#0d9488', 'white', '#ccfbf1', '#115e59', '#14b8a6'], dark: ['#14b8a6', '#042f2e', '#134e4a', '#99f6e4', '#2dd4bf'] }
	emerald: { name: 'Emerald', light: ['#059669', 'white', '#d1fae5', '#065f46', '#10b981'], dark: ['#10b981', '#022c22', '#064e3b', '#a7f3d0', '#34d399'] }
	amber: { name: 'Amber', light: ['#d97706', 'white', '#fef3c7', '#92400e', '#f59e0b'], dark: ['#f59e0b', '#451a03', '#451a03', '#fde68a', '#fbbf24'] }
	rose: { name: 'Rose', light: ['#e11d48', 'white', '#ffe4e6', '#9f1239', '#f43f5e'], dark: ['#f43f5e', 'white', '#4c0519', '#fecdd3', '#fb7185'] }
	neutral: { name: 'Neutral', light: ['#18181b', 'white', '#f4f4f5', '#18181b', '#71717a'], dark: ['#fafafa', '#18181b', '#27272a', '#fafafa', '#a1a1aa'] }
}

export const fonts = {
	system: { name: 'System', family: 'system-ui, sans-serif' }
	inter: { name: 'Inter', family: "'Inter Variable', system-ui, sans-serif" }
	jakarta: { name: 'Jakarta', family: "'Plus Jakarta Sans Variable', system-ui, sans-serif" }
}

export const radii = { sharp: ['Sharp', '2px'], default: ['Default', '6px'], round: ['Round', '12px'] }

# Control heights: [md, sm, lg].
export const densities = { compact: ['Compact', '2rem', '1.75rem', '2.5rem'], default: ['Default', '2.25rem', '2rem', '2.75rem'], comfortable: ['Roomy', '2.5rem', '2.25rem', '3rem'] }

export const defaults = { scheme: 'system', accent: 'indigo', font: 'system', radius: 'default', density: 'default' }

const storageKey = 'imba-ui-playground-appearance'

export def loadAppearance
	let saved = {}
	try saved = JSON.parse(globalThis.localStorage.getItem(storageKey) or '{}')
	# Older saves had `dark: true/false`.
	if saved.dark !== undefined and !saved.scheme
		saved.scheme = saved.dark ? 'dark' : 'light'
	Object.assign({}, defaults, saved)

# 'system' follows the OS setting, live.
const prefersDark = globalThis.matchMedia('(prefers-color-scheme: dark)')
export def isDark state do state.scheme == 'dark' or (state.scheme == 'system' and prefersDark.matches)

export def saveAppearance state
	try globalThis.localStorage.setItem(storageKey, JSON.stringify(state))

export def applyAppearance state
	let root = document.documentElement
	let dark = isDark(state)
	root.classList.toggle('dark', dark)
	let [accent, accentText, soft, softText, ring] = (accents[state.accent] or accents.indigo)[dark ? 'dark' : 'light']
	let [_name, md, sm, lg] = densities[state.density] or densities.default
	let tokens = {
		'--ui-accent': accent
		'--ui-accent-text': accentText
		'--ui-accent-soft': soft
		'--ui-accent-soft-text': softText
		'--ui-ring': ring
		'--ui-ring-soft': "{ring}33"
		'--ui-radius': (radii[state.radius] or radii.default)[1]
		'--ui-control-height': md
		'--ui-control-height-sm': sm
		'--ui-control-height-lg': lg
	}
	root.style.setProperty(name, value) for own name, value of tokens
	document.body.style.fontFamily = (fonts[state.font] or fonts.system).family

def options map
	Object.keys(map).map do(key) { value: key, label: Array.isArray(map[key]) ? map[key][0] : map[key].name }

tag appearance-panel
	state = loadAppearance!
	fontItems = options(fonts)
	radiusItems = options(radii)
	densityItems = options(densities)
	themeItems = [{ value: 'light', label: 'Light' }, { value: 'dark', label: 'Dark' }, { value: 'system', label: 'System' }]

	def mount
		# Re-apply when the OS switches while 'system' is chosen.
		#onScheme = do
			return unless state.scheme == 'system'
			applyAppearance(state)
			render!
		prefersDark.addEventListener('change', #onScheme)

	def unmount do prefersDark.removeEventListener('change', #onScheme)

	def update changes
		state = Object.assign({}, state, changes)
		applyAppearance(state)
		saveAppearance(state)

	def reset do update(defaults)

	css
		d:block
		.rows d:vflex g:4
		.swatches d:flex flw:wrap g:2
		.swatch w:7 h:7 p:0 rd:full bd:2px solid $ui-surface cursor:pointer outline:1px solid $ui-border
			@hover outline-color:$ui-muted
			@focus-visible outline:2px solid $ui-ring
			&[aria-checked=true] outline:2px solid $ui-text
		.footer d:flex jc:flex-end

	<self>
		<ui-popover heading='Appearance' description='Overrides the $ui-* tokens on <html>.' closable placement='bottom-end'>
			<ui-button slot='trigger' size='sm' variant='ghost' icon='lucide:palette' aria-label='Appearance'>
			<div.rows>
				<ui-field label='Theme'>
					<ui-segmented items=themeItems value=state.scheme @change=update(scheme: e.detail)>
				<ui-field label='Accent'>
					<div.swatches role='radiogroup' aria-label='Accent'>
						for own key, accent of accents
							<button.swatch type='button' role='radio' aria-checked=String(state.accent == key) aria-label=accent.name [bg:{accent[isDark(state) ? 'dark' : 'light'][0]}] @click=update(accent: key)>
				<ui-field label='Font'>
					<ui-segmented items=fontItems value=state.font @change=update(font: e.detail)>
				<ui-field label='Radius'>
					<ui-segmented items=radiusItems value=state.radius @change=update(radius: e.detail)>
				<ui-field label='Density' hint='Sets $ui-control-height'>
					<ui-segmented items=densityItems value=state.density @change=update(density: e.detail)>
				<div.footer>
					<ui-button variant='link' size='sm' @click=reset> "Reset"
