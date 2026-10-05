# Shared pieces for the playground pages.
import './api.imba'

# Pages whose path isn't their component's folder (or covers several).
const apiAliases = {
	'/charts': 'chart'
	'/menu': ['menu', 'context-menu']
	'/table': ['table', 'pagination']
	'/checkbox': ['checkbox', 'checkbox-group']
	'/stat': 'stat'
	'/fields': ['fields', 'field']
	'/toast': 'toast'
}

export const subjects = [
	{ value: 1, label: 'Maths' }
	{ value: 2, label: 'English' }
	{ value: 3, label: 'Physics' }
	{ value: 4, label: 'Chemistry' }
	{ value: 5, label: 'Biology' }
	{ value: 6, label: 'History' }
	{ value: 7, label: 'Latin', disabled: true }
	{ value: 8, label: 'Computer Science' }
]

# Splits text into highlighted tokens: each regex group is one kind.
def tokenize text, re, kinds
	let out = []
	let last = 0
	for m in Array.from(text.matchAll(re))
		out.push({ text: text.slice(last, m.index) }) if m.index > last
		out.push({ text: m[0], kind: kinds[m.slice(1).findIndex(do $1 != undefined)] })
		last = m.index + m[0].length
	out.push({ text: text.slice(last) }) if last < text.length
	out

const jsonRe = /("(?:\\.|[^"\\])*")(?=\s*:)|("(?:\\.|[^"\\])*")|\b(true|false|null)\b|(-?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?)/g
const imbaRe = /(#[^\n]*)|('(?:\\.|[^'\\])*'|"(?:\\.|[^"\\])*")|(<\/?[\w$.\-]+)|\b(do|if|elif|else|for|in|def|tag|prop)\b|([\w$:\-]+)(?==)|(\b\d+(?:\.\d+)?\b)/g

export def highlightJson text do tokenize(text, jsonRe, ['key', 'string', 'literal', 'number'])
export def highlightImba text do tokenize(text, imbaRe, ['comment', 'string', 'tag', 'keyword', 'attr', 'number'])

# The markup of the section headed `heading` in a page's source, without the
# demo scaffolding (`.out` blocks with readouts and buttons that set values).
export def sectionSource source, heading
	let lines = (source or '').split('\n')
	let start = lines.findIndex(do $1.includes("<demo-section heading='{heading}'>"))
	return '' if start < 0
	let depth = do(line) line.match(/^\t*/)[0].length
	let base = depth(lines[start])
	let out = []
	let skip = null
	for line in lines.slice(start + 1)
		continue unless line.trim!
		let level = depth(line)
		break if level <= base
		if skip != null and level > skip
			continue
		skip = null
		if line.trim!.startsWith('<div.out')
			skip = level
			continue
		out.push(line)
	let min = Math.min(...out.map(depth))
	out.map(do $1.slice(min)).join('\n')

# Page content belongs to each page's scope, so demo helpers (readouts,
# buttons that set values) are styled globally under demo-section.
global css
	demo-section
		# Readouts and buttons that set values: the foot of the preview card.
		.out d:vflex g:2 w:100% box-sizing:border-box mt:1 pt:4 bdt:1px dashed $ui-border
		# Helper classes must not match the components' own parts (several
		# use .group), since these rules reach inside them.
		.row d:hflex flw:wrap g:2 ai:center
		.note m:0 fs:xs c:$ui-muted
		.indent d:vflex g:2 pl:6
		.set d:hcl g:2 flw:wrap
		.set button bd:1px solid $ui-border bg:transparent c:inherit rd:md fs:xs px:2 py:1 cursor:pointer
			@hover bg:$ui-hover

	# Token colours for code and JSON.
	.tok-key c:$ui-text fw:500
	.tok-string c:#15803d
	.tok-number c:#c2410c
	.tok-literal, .tok-keyword c:#7c3aed
	.tok-tag c:#2563eb
	.tok-attr c:#0e7490
	.tok-comment c:$ui-muted fs:italic
	html.dark, [data-theme=dark]
		.tok-string c:#4ade80
		.tok-number c:#fb923c
		.tok-literal, .tok-keyword c:#a78bfa
		.tok-tag c:#60a5fa
		.tok-attr c:#22d3ee

# A data readout: one compact line that expands to indented JSON on click.
# With `fixed` it sits in the bottom-right corner as a toggle button.
tag json-print
	prop data = null
	prop label = null
	prop open = false
	prop fixed = false

	get tokens do highlightJson(JSON.stringify(data ?? null, null, open ? 2 : 0) ?? 'undefined')

	css
		d:block ff:mono fs:xs min-width:0
		.json d:block w:100% m:0 p:0 bd:none bg:transparent c:$ui-muted ff:inherit fs:inherit ta:left ws:pre-wrap word-break:break-all cursor:pointer rd:md
			@hover c:$ui-text
			@focus-visible outline:2px solid $ui-ring-soft
		&.open .json p:3 bg:$ui-hover c:$ui-text tab-size:2
		.label c:$ui-muted mr:2
		&.open .label d:block mb:2 ff:sans fw:500
		&.fixed pos:fixed r:4 b:4 zi:40 max-width:min(420px, calc(100vw - 32px)) max-height:60vh ofy:auto
			.json bg:$ui-surface bd:1px solid $ui-border shadow:$ui-shadow
		.fab d:inline-flex ai:center g:2 h:9 px:3 bd:1px solid $ui-border bg:$ui-surface c:$ui-text rd:full shadow:$ui-shadow ff:sans fs:sm cursor:pointer
			@hover bg:$ui-hover

	<self .open=open .fixed=fixed>
		if fixed and !open
			<button.fab @click=(open = yes)>
				<iconify-icon icon='lucide:braces'>
				label or 'State'
		else
			<button.json aria-expanded=String(open) @click=(open = !open)>
				<span.label> label if label
				for tok in tokens
					<span .tok-{tok.kind or 'plain'}> tok.text

tag demo-page
	prop heading
	prop intro
	# The page's own source (`import source from './x.imba?raw'`), for the
	# sections' code toggles.
	prop source = ''
	# The component folders whose API the Props panel shows; by default the
	# page's own path (/date-picker → date-picker).
	prop api = null
	showApi = no

	get apiNames do [].concat(api ?? (apiAliases[router.pathname] or router.pathname.slice(1)))

	css
		d:block
		.title d:flex ai:center jc:space-between g:4
		h1 fs:xl fw:700 m:0
		.intro m:0 mt:1 c:$ui-muted fs:sm
		.api-toggle d:inline-flex ai:center g:1.5 h:7 px:2 bd:1px solid transparent bg:transparent c:$ui-muted rd:md fs:xs ff:inherit cursor:pointer fls:0
			@hover c:$ui-text bg:$ui-hover
			&.on c:$ui-text bc:$ui-border bg:$ui-surface
		api-panel mt:5
	<self>
		<div.title>
			<h1> heading
			<button.api-toggle .on=showApi aria-pressed=String(showApi) @click=(showApi = !showApi)>
				<iconify-icon icon='lucide:list-tree'>
				"Props"
		<p.intro> intro if intro
		<api-panel names=apiNames> if showApi
		<slot>

tag demo-section
	prop heading
	# For components that are cards themselves: no preview card around them.
	prop bare = false
	showCode = no
	copied = no

	get code do sectionSource(closest('demo-page')..source, heading)

	def copy
		await globalThis.navigator.clipboard.writeText(code)
		copied = yes
		imba.commit!
		setTimeout(&, 1500) do
			copied = no
			imba.commit!

	# The example sits in a white preview card (like the blocks), with its
	# title and Code toggle above it on the canvas.
	css
		d:vtl g:3 py:5
		header d:hcs as:stretch g:4
		h2 fs:md fw:600 m:0
		.toggle d:inline-flex ai:center g:1.5 h:7 px:2 bd:1px solid transparent bg:transparent c:$ui-muted rd:md fs:xs ff:inherit cursor:pointer
			@hover c:$ui-text bg:$ui-hover
			&.on c:$ui-text bc:$ui-border
		.code pos:relative as:stretch
			pre m:0 p:4 pr:16 bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius + 6px) ff:mono fs:xs lh:1.6 tab-size:2 ofx:auto
			.copy pos:absolute t:2 r:2 h:7 px:2 bd:1px solid $ui-border bg:$ui-surface c:$ui-muted rd:md fs:xs ff:inherit cursor:pointer
				@hover c:$ui-text
		.preview d:vtl g:4 w:100% box-sizing:border-box p:5 @md:6 bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius + 6px) shadow:$ui-card-shadow
			&.bare p:0 @md:0 bg:transparent bd:none shadow:none

	<self>
		<header>
			<h2> heading
			<button.toggle .on=showCode aria-pressed=String(showCode) @click=(showCode = !showCode)>
				<iconify-icon icon='lucide:code'>
				"Code"
		if showCode
			<div.code>
				<pre> <code> for tok in highlightImba(code)
					<span .tok-{tok.kind or 'plain'}> tok.text
				<button.copy @click=copy> copied ? "Copied" : "Copy"
		<div.preview .bare=bare> <slot>

# A code sample with a Copy button, for the guide pages. Imba is highlighted;
# other languages (`sh`, `js`) show plain.
tag code-block
	prop code = ''
	prop lang = 'imba'
	copied = no

	get tokens do lang == 'imba' ? highlightImba(code) : [{ text: code }]

	def copy
		await globalThis.navigator.clipboard.writeText(code)
		copied = yes
		imba.commit!
		setTimeout(&, 1500) do
			copied = no
			imba.commit!

	css
		d:block pos:relative
		pre m:0 p:4 pr:16 bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius + 6px) ff:mono fs:xs lh:1.6 tab-size:2 ofx:auto
		.copy pos:absolute t:2 r:2 h:7 px:2 bd:1px solid $ui-border bg:$ui-surface c:$ui-muted rd:md fs:xs ff:inherit cursor:pointer
			@hover c:$ui-text

	<self>
		<pre> <code> for tok in tokens
			<span .tok-{tok.kind or 'plain'}> tok.text
		<button.copy @click=copy> copied ? "Copied" : "Copy"
