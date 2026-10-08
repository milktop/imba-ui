import source from './theming.imba?raw'
import themeSource from '../../src/theme.imba?raw'
import { highlightImba } from '../demo.imba'

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
			let value = m[2]
			unless byName[name]
				byName[name] = { name, light: '', dark: '' }
				tokens.push(byName[name])
			byName[name][mode] = value.trim!
	tokens

const tokens = readTokens!

# Which tokens are colours (and get a swatch).
def isColour token do !/radius|font|height|width|shadow|stroke/.test(token.name)

const fonts = [
	{ value: 'inherit', label: 'Inherit' }
	{ value: 'Georgia, serif', label: 'Serif' }
	{ value: 'ui-monospace, monospace', label: 'Mono' }
]
const radii = [{ value: '2px', label: 'Sharp' }, { value: '6px', label: 'Default' }, { value: '12px', label: 'Round' }]
const strokes = [{ value: '1.5', label: 'Light' }, { value: '2', label: 'Default' }, { value: '2.5', label: 'Bold' }]

tag page-theming
	accent = '#e11d48'
	radius = '12px'
	font = 'inherit'
	stroke = '2'
	copied = no
	agree = yes

	get dark do document.documentElement.classList.contains('dark')

	# The accent's companions, mixed from it: a soft tint for selections and
	# soft buttons, a deep shade for text on it, and the focus ring.
	def accentTokens colour, dark
		{
			'ui-accent': colour
			'ui-accent-soft': "color-mix(in srgb, {colour} {dark ? 30 : 15}%, {dark ? 'black' : 'white'})"
			'ui-accent-soft-text': "color-mix(in srgb, {colour} {dark ? 35 : 70}%, {dark ? 'white' : 'black'})"
			'ui-ring': colour
			'ui-ring-soft': "color-mix(in srgb, {colour} 25%, transparent)"
		}

	get overrides
		{ ...accentTokens(accent, dark), 'ui-radius': radius, 'ui-font': font, 'ui-icon-stroke': stroke }

	get style do Object.entries(overrides).map(do "--{$1[0]}:{$1[1]}").join(';')

	get snippet
		let block = do(dark)
			let all = { ...accentTokens(accent, dark) }
			unless dark
				all['ui-radius'] = radius
				all['ui-font'] = font unless font == 'inherit'
				all['ui-icon-stroke'] = stroke unless stroke == '2'
			Object.entries(all).map(do "\t\t${$1[0]}:{$1[1]}").join('\n')
		"global css\n\t@root\n{block(no)}\n\thtml.dark, [data-theme=dark]\n{block(yes)}"

	def copy
		await globalThis.navigator.clipboard.writeText(snippet)
		copied = yes
		setTimeout(&, 1500) do
			copied = no
			imba.commit!

	css
		.controls d:flex flw:wrap g:4 ai:flex-end
		.colour d:flex fld:column g:1.5 fs:sm fw:500
			input w:16 h:9 p:1 bd:1px solid $ui-border rd:$ui-radius bg:$ui-surface cursor:pointer
		.sample d:flex fld:column g:4 w:100% box-sizing:border-box p:5 bd:1px dashed $ui-border rd:calc($ui-radius + 4px) ff:$ui-font
		.snippet pos:relative w:100%
			pre m:0 p:4 bg:$ui-hover rd:$ui-radius ff:mono fs:xs lh:1.6 tab-size:2 ofx:auto
			.copy pos:absolute t:2 r:2
		.swatch d:inline-block w:5 h:5 mr:2 rd:sm bd:1px solid $ui-border va:middle
		code ff:mono fs:xs
		.value ff:mono fs:xs c:$ui-muted ws:normal word-break:break-word

	<self>
		<demo-page source=source heading='Theming' intro='Styled components read $ui-* tokens. Override them globally to brand the app, or on any element to restyle just what is inside it. Tokens are CSS custom properties ($ui-accent is --ui-accent), so plain CSS can set them too.'>
			<demo-section heading='Brand a section'>
				<div.controls>
					<label.colour>
						"Accent"
						<input type='color' bind=accent>
					<ui-field label='Radius'>
						<ui-segmented items=radii bind=radius>
					<ui-field label='Font'>
						<ui-segmented items=fonts bind=font>
					<ui-field label='Icons'>
						<ui-segmented items=strokes bind=stroke>
				# The overrides apply to this box only.
				<div.sample style=style>
					<div.row>
						<ui-button variant='primary' icon='lucide:calendar-plus'> "Book a lesson"
						<ui-button variant='soft'> "Soft"
						<ui-button icon='lucide:bell' aria-label='Notifications' count=3 countColor='accent'>
						<ui-badge variant='accent'> "New"
					<div.row>
						<ui-input icon='lucide:search' placeholder='Search students' [w:64]>
						<ui-switch label='Reminders' checked=agree>
						<ui-checkbox label='Agree' checked=agree>
					<ui-progress value=64 label='Monthly goal' showValue>
				<div.out>
					<p.note> "The snippet sets these for the whole app, with dark values (a deeper tint) for dark mode. Paste it into your app's root CSS."
					<div.snippet>
						<pre> <code> for tok in highlightImba(snippet)
							<span .tok-{tok.kind or 'plain'}> tok.text
						<ui-button.copy size='sm' @click=copy> copied ? "Copied" : "Copy"

			<demo-section heading='Tokens' bare>
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
