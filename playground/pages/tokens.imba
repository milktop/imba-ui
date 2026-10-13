import source from './tokens.imba?raw'
import themeSource from '../../src/theme.imba?raw'

# The tokens and their defaults, read from theme.imba: the @root block, then
# the dark block's overrides.
def readTokens
	let tokens = []
	let byName = {}
	let mode = null
	for line in themeSource.split('\n')
		if /^\t@root/.test(line)
			mode = 'light'
		elif /^\thtml\.dark/.test(line)
			mode = 'dark'
		elif /^\t\S/.test(line) or /^\S/.test(line)
			mode = null
		elif mode and /^\t\t\$ui-/.test(line)
			let m = line.match(/^\t\t\$(ui-[\w-]+):(.+)$/)
			let name = m[1]
			unless byName[name]
				byName[name] = { name, light: '', dark: '' }
				tokens.push(byName[name])
			byName[name][mode] = m[2].trim!
	tokens

# What each group of tokens styles; a token belongs to the first group whose
# test matches its name.
const groups = [
	{ title: 'Text', about: 'Text, and secondary text (hints, labels, placeholders)', test: /^ui-(text|muted)$/ }
	{ title: 'Surfaces', about: 'Cards and popups, their borders, and hovered rows and items', test: /^ui-(surface|border|hover)$/ }
	{ title: 'Form controls', about: 'Inputs, selects, checkboxes and the editor: fill, border, border on hover. Light, they follow the surface; dark, a darker fill and a stronger border', test: /^ui-field-/ }
	{ title: 'App shell', about: 'The page behind cards, the inset layout’s sidebar shade and the frame round it', test: /^ui-(canvas|sidebar-bg|frame)$/ }
	{ title: 'Accent', about: 'Primary buttons, selections, checked controls and soft tints; the text on them; focus rings; selected text and ui-highlight’s marks', test: /^ui-(accent|ring|selection|highlight)/ }
	{ title: 'Status', about: 'Errors and destructive actions, positive changes, cautions (alerts tint themselves from these and the accent)', test: /^ui-(danger|success|warning)$/ }
	{ title: 'Charts', about: 'Chart series, in order (the first follows the accent)', test: /^ui-chart-/ }
	{ title: 'Loading', about: 'Skeleton placeholders', test: /^ui-skeleton$/ }
	{ title: 'Shape and type', about: 'Corner rounding (cards and popups add a little), the components’ font (inherit: the app’s), and the weight of stroke icons such as Lucide’s', test: /^ui-(radius|font|icon-stroke)$/ }
	{ title: 'Sizes', about: 'Buttons and inputs share these heights, so they line up in a row', test: /^ui-control-height/ }
	{ title: 'Shadows', about: 'Popups, and cards at rest', test: /shadow$/ }
	{ title: 'Sidebar', about: 'ui-app-shell’s sidebar: its widths, background, headings and icon buttons; its items’ size, shape and colours, hovered and current; and the same in an inset layout', test: /^ui-sidebar-/ }
]

def groupTokens tokens
	let out = groups.map(do Object.assign({}, $1, { tokens: [] }))
	let other = { title: 'Other', about: '', tokens: [] }
	for token in tokens
		let group = out.find(do $1.test.test(token.name))
		(group or other).tokens.push(token)
	[...out, other].filter(do $1.tokens.length)

const grouped = groupTokens(readTokens!)

# Which tokens are colours (and get a swatch).
def isColour token do !/radius|font|height|width|shadow|stroke|padding|weight/.test(token.name)

tag page-tokens
	query = ''

	# A link from a component's Styling panel (/tokens?q=ui-accent) opens
	# filtered, each time one is followed.
	def syncQuery
		let q = new URLSearchParams(globalThis.location.search).get('q') or ''
		return if q == #linked
		#linked = q
		query = q

	def shown group
		let q = query.trim!.toLowerCase!
		return group.tokens unless q
		group.tokens.filter(do $1.name.includes(q) or group.title.toLowerCase!.includes(q))

	css
		.search w:64 max-width:100%
		.group d:flex fld:column g:2 w:100%
		h3 m:0 fs:md fw:600
		.about m:0 c:$ui-muted fs:sm
		.swatch d:inline-block w:5 h:5 mr:2 rd:sm bd:1px solid $ui-border va:middle
		code ff:mono fs:xs
		.value ff:mono fs:xs c:$ui-muted ws:normal word-break:break-word

	def render
		syncQuery!
		<self>
			<demo-page source=source heading='Tokens' intro="Every $ui-* token, with what it styles and its light and dark values (read from theme.imba). Tokens are CSS custom properties ($ui-accent is --ui-accent): set them in your app's root CSS to brand it, or on any element to restyle what's inside it. Theming shows how.">
				<demo-section heading='Find a token'>
					<ui-input.search icon='lucide:search' placeholder='accent, sidebar, radius…' bind=query>
				for group in grouped
					let tokens = shown(group)
					if tokens.length
						<demo-section key=group.title heading=group.title bare>
							<div.group>
								<p.about> group.about if group.about
								<ui-table>
									<table>
										<thead>
											<tr>
												<th> "Token"
												<th> "Light"
												<th> "Dark"
										<tbody> for token in tokens
											<tr>
												<td>
													<span.swatch style="background:var(--{token.name})"> if isColour(token)
													<code> "${token.name}"
												<td.value> token.light
												<td.value> token.dark or "same"
