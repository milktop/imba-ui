import '@fontsource-variable/inter'
import '@fontsource-variable/plus-jakarta-sans'
import '@fontsource-variable/geist'
import '@fontsource-variable/dm-sans'
import { colorScheme } from '../src/color-scheme.imba'
import { highlightImba } from './demo.imba'

# The playground's appearance switcher: theme, accent, font, radius and
# density, all by overriding the library's $ui-* tokens on <html>, which is
# exactly what an app would do in its own CSS.

# Each accent has light and dark values for the accent tokens and focus ring.
export const accents = {
	blue: { name: 'Blue', light: ['#2563eb', 'white', '#dbeafe', '#1e40af', '#3b82f6'], dark: ['#3b82f6', 'white', '#1e3a8a', '#bfdbfe', '#60a5fa'] }
	indigo: { name: 'Indigo', light: ['#4f46e5', 'white', '#e0e7ff', '#3730a3', '#6366f1'], dark: ['#6366f1', 'white', '#312e81', '#c7d2fe', '#818cf8'] }
	violet: { name: 'Violet', light: ['#7c3aed', 'white', '#ede9fe', '#5b21b6', '#8b5cf6'], dark: ['#8b5cf6', 'white', '#4c1d95', '#ddd6fe', '#a78bfa'] }
	teal: { name: 'Teal', light: ['#0d9488', 'white', '#ccfbf1', '#115e59', '#14b8a6'], dark: ['#14b8a6', '#042f2e', '#134e4a', '#99f6e4', '#2dd4bf'] }
	emerald: { name: 'Emerald', light: ['#059669', 'white', '#d1fae5', '#065f46', '#10b981'], dark: ['#10b981', '#022c22', '#064e3b', '#a7f3d0', '#34d399'] }
	amber: { name: 'Amber', light: ['#d97706', 'white', '#fef3c7', '#92400e', '#f59e0b'], dark: ['#f59e0b', '#451a03', '#451a03', '#fde68a', '#fbbf24'] }
	rose: { name: 'Rose', light: ['#e11d48', 'white', '#ffe4e6', '#9f1239', '#f43f5e'], dark: ['#f43f5e', 'white', '#4c0519', '#fecdd3', '#fb7185'] }
	neutral: { name: 'Neutral', light: ['#18181b', 'white', '#f4f4f5', '#18181b', '#71717a'], dark: ['#fafafa', '#18181b', '#27272a', '#fafafa', '#a1a1aa'] }
}

export const fonts = {
	system: { name: 'System', family: 'system-ui, sans-serif' }
	inter: { name: 'Inter', family: "'Inter Variable', system-ui, sans-serif", pkg: '@fontsource-variable/inter' }
	jakarta: { name: 'Jakarta', family: "'Plus Jakarta Sans Variable', system-ui, sans-serif", pkg: '@fontsource-variable/plus-jakarta-sans' }
	geist: { name: 'Geist', family: "'Geist Variable', system-ui, sans-serif", pkg: '@fontsource-variable/geist' }
	dm: { name: 'DM Sans', family: "'DM Sans Variable', system-ui, sans-serif", pkg: '@fontsource-variable/dm-sans' }
}

export const radii = { sharp: ['Sharp', '2px'], default: ['Default', '6px'], round: ['Round', '12px'] }

# Control heights: [md, sm, lg].
export const densities = { compact: ['Compact', '2rem', '1.75rem', '2.5rem'], default: ['Default', '2.25rem', '2rem', '2.75rem'], comfortable: ['Roomy', '2.5rem', '2.25rem', '3rem'] }

export const layouts = { full: ['Full'], inset: ['Inset'] }

# Light-mode backgrounds (dark mode keeps its own layers): the canvas, and
# the inset sidebar's shade of it (or white). [label, canvas, sidebar shade]
export const canvases = {
	cool: ['Cool', '#f2f4f7', '#f8f9fb']
	warm: ['Warm', '#f4f3ef', '#faf9f6']
	tinted: ['Tinted', 'color-mix(in oklab, var(--ui-accent) 2.5%, #f6f7f9)', 'color-mix(in oklab, var(--ui-accent) 1.2%, #fbfbfc)']
	white: ['White', '#ffffff', '#ffffff']
}
export const sidebars = { shaded: ['Shaded'], white: ['White'] }
export const aligns = { center: ['Centred'], start: ['Left'] }
export const widths = { auto: ['Auto'], default: ['Default'], wide: ['Wide'], full: ['Full'] }

# The theme itself is the library's colorScheme (saved on its own); the rest is here.
export const defaults = { accent: 'blue', font: 'jakarta', radius: 'default', density: 'default', layout: 'inset', align: 'center', width: 'full', canvas: 'cool', sidebar: 'shaded' }

# Versioned, so changed defaults reach browsers that saved older settings.
const storageKey = 'imba-ui-playground-appearance-v3'

export def loadAppearance
	let saved = {}
	try saved = JSON.parse(globalThis.localStorage.getItem(storageKey) or '{}')
	Object.assign({}, defaults, saved)

export def saveAppearance state
	try globalThis.localStorage.setItem(storageKey, JSON.stringify(state))

# The tokens a state sets, for light or dark. Backgrounds are light-only, so
# dark mode keeps its own layers.
export def appearanceTokens state, dark
	let [accent, accentText, soft, softText, ring] = (accents[state.accent] or accents.indigo)[dark ? 'dark' : 'light']
	let [_name, md, sm, lg] = densities[state.density] or densities.default
	let tokens = {
		'ui-accent': accent
		'ui-accent-text': accentText
		'ui-accent-soft': soft
		'ui-accent-soft-text': softText
		'ui-ring': ring
		'ui-ring-soft': "{ring}33"
	}
	return tokens if dark
	let [_label, canvas, shade] = canvases[state.canvas] or canvases.cool
	Object.assign tokens, {
		'ui-radius': (radii[state.radius] or radii.default)[1]
		'ui-font': (fonts[state.font] or fonts.system).family
		'ui-control-height': md
		'ui-control-height-sm': sm
		'ui-control-height-lg': lg
		'ui-canvas': canvas
		'ui-sidebar-bg': state.sidebar == 'white' ? '#ffffff' : shade
	}

export def applyAppearance state
	let root = document.documentElement
	let dark = colorScheme.dark
	let tokens = appearanceTokens(state, dark)
	# Dark mode only overrides the colours; the rest carry over from light.
	tokens = { ...appearanceTokens(state, no), ...tokens } if dark
	root.style.setProperty("--{name}", value) for own name, value of tokens
	if dark
		root.style.removeProperty('--ui-canvas')
		root.style.removeProperty('--ui-sidebar-bg')
	document.body.style.fontFamily = tokens['ui-font']
	# The shell reads this for its `inset` prop.
	root.dataset.layout = state.layout or 'full'
	root.dataset.pageAlign = state.align or 'center'
	root.dataset.pageWidth = state.width or 'auto'

# The settings as code to paste into an app: its root CSS, the font import
# and the shell's props.
export def appearanceSnippet state
	let lines = do(tokens) Object.entries(tokens).map(do "\t\t${$1[0]}:{$1[1].replace('var(--ui-accent)', '$ui-accent')}")
	let pkg = fonts[state.font]..pkg
	let shell = state.layout == 'inset' ? "<ui-app-shell inset>" : "<ui-app-shell>"
	let page = ['<ui-page']
	page.push("width='{state.width}'") if state.width and state.width != 'auto'
	page.push("align='start'") if state.align == 'start'
	[
		pkg ? "import '{pkg}'\n\n" : ''
		"global css\n\t@root\n"
		lines(appearanceTokens(state, no)).join('\n')
		"\n\thtml.dark, [data-theme=dark]\n"
		lines(appearanceTokens(state, yes)).join('\n')
		"\n\tbody\n\t\tff:$ui-font\n\n"
		"# In your layout\n{shell}\n\t{page.join(' ')}>"
	].join('')

def options map
	Object.keys(map).map do(key) { value: key, label: Array.isArray(map[key]) ? map[key][0] : map[key].name }

tag appearance-panel
	state = loadAppearance!
	fontItems = options(fonts)
	radiusItems = options(radii)
	layoutItems = options(layouts)
	canvasItems = options(canvases)
	sidebarItems = options(sidebars)
	alignItems = options(aligns)
	widthItems = options(widths)
	densityItems = options(densities)
	showCode = no

	# Accents have light and dark values, so re-apply when the scheme changes.
	def mount
		#stop = colorScheme.listen do
			applyAppearance(state)
			render!

	def unmount do #stop!

	def update changes
		state = Object.assign({}, state, changes)
		applyAppearance(state)
		saveAppearance(state)

	def toggleCode
		showCode = !showCode

	def reset
		colorScheme.value = 'system'
		update(defaults)

	css
		d:block
		# Two columns of settings in a wider panel (one on phones).
		>>> .content[data-scope=popover] w:min(40rem, calc(100vw - 32px)) max-height:calc(100vh - 80px) ofy:auto
		.rows d:grid gtc:1fr @sm:1fr 1fr g:4 cg:6 ai:start
		# Fields span the 12-column ui-fields grid by default; here, one cell each.
		.rows > ui-field gc:auto
		.footer gc:1 / -1
		.swatches d:flex flw:wrap g:2
		.swatch w:7 h:7 p:0 rd:full bd:2px solid $ui-surface cursor:pointer outline:1px solid $ui-border
			@hover outline-color:$ui-muted
			@focus-visible outline:2px solid $ui-ring
			&[aria-checked=true] outline:2px solid $ui-text
		.footer d:flex jc:space-between
		.code gc:1 / -1 pos:relative
			pre m:0 p:3 pr:12 bg:$ui-hover rd:$ui-radius ff:mono fs:xs lh:1.6 tab-size:2 ofx:auto
			.copy pos:absolute t:1.5 r:1.5

	<self>
		<ui-popover heading='Appearance' description='Overrides the $ui-* tokens on <html>.' closable placement='bottom-end'>
			<ui-button slot='trigger' size='sm' variant='ghost' icon='lucide:palette' aria-label='Appearance'>
			<div.rows>
				<ui-field label='Theme'>
					<ui-theme-toggle>
				<ui-field label='Accent'>
					<div.swatches role='radiogroup' aria-label='Accent'>
						for own key, accent of accents
							<button.swatch type='button' role='radio' aria-checked=String(state.accent == key) aria-label=accent.name [bg:{accent[colorScheme.dark ? 'dark' : 'light'][0]}] @click=update(accent: key)>
				<ui-field label='Font'>
					<ui-select size='sm' items=fontItems value=state.font @change=update(font: e.detail)>
				<ui-field label='Radius'>
					<ui-segmented items=radiusItems value=state.radius @change=update(radius: e.detail)>
				<ui-field label='Layout' hint='ui-app-shell’s inset option'>
					<ui-segmented items=layoutItems value=state.layout @change=update(layout: e.detail)>
				<ui-field label='Background' hint='$ui-canvas, in light mode'>
					<ui-segmented items=canvasItems value=state.canvas @change=update(canvas: e.detail)>
				<ui-field label='Sidebar' hint='$ui-sidebar-bg (inset layout)'>
					<ui-segmented items=sidebarItems value=state.sidebar @change=update(sidebar: e.detail)>
				<ui-field label='Width' hint='ui-page’s width (Auto: blocks wide)'>
					<ui-segmented items=widthItems value=state.width @change=update(width: e.detail)>
				<ui-field label='Page' hint='ui-page’s align, for capped pages'>
					<ui-segmented items=alignItems value=state.align @change=update(align: e.detail)>
				<ui-field label='Density' hint='Sets $ui-control-height'>
					<ui-segmented items=densityItems value=state.density @change=update(density: e.detail)>
				if showCode
					<div.code>
						<pre> <code> for tok in highlightImba(appearanceSnippet(state))
							<span .tok-{tok.kind or 'plain'}> tok.text
						<ui-copy-button.copy value=appearanceSnippet(state) iconOnly>
				<div.footer>
					<ui-button variant='ghost' size='sm' icon='lucide:code' @click=toggleCode> showCode ? "Hide code" : "Code"
					<ui-button variant='link' size='sm' @click=reset> "Reset"
