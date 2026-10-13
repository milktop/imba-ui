import { highlightImba } from './demo.imba'
import { apiOf, baseSource } from './api.imba'
import themeSource from '../src/theme.imba?raw'
import pkg from '../package.json'

# How to style each component, read from its files like the Props panel:
# the theme tokens its styled tag uses, variables of its own, its parts with
# the states they're styled by, and starter code with its real names.

const styledSources = import.meta.glob('../src/*/index.imba', { query: '?raw', import: 'default', eager: true })
def styledSource name do styledSources["../src/{name}/index.imba"] or ''

# A folder's other files (ui-select's list and search modes live in list.imba
# and search.imba): their tags are styled in index.imba too.
const allSources = import.meta.glob('../src/*/*.imba', { query: '?raw', import: 'default', eager: true })
def innerSources name
	Object.keys(allSources).filter(do $1.startsWith("../src/{name}/") and !/\/(base|index)\.imba$/.test($1)).map(do allSources[$1])

# The shared tokens: everything theme.imba defines.
const themeTokens = new Set(Array.from(themeSource.matchAll(/^\t\t\$(ui-[\w-]+):/gm)).map(do $1[1]))
const colourLike = do(name) !/radius|font|height|width|shadow|stroke|padding|weight/.test(name)

# The entry point a folder is imported from ('@milktop/imba-ui/date-picker').
def importPath folder, base = no
	let target = "./src/{folder}/{base ? 'base' : 'index'}.imba"
	let key = Object.keys(pkg.exports).find(do pkg.exports[$1] == target)
	key ? "@milktop/imba-ui{key.slice(1)}" : "@milktop/imba-ui"

def unique list do Array.from(new Set(list))

# The lines of `tag name <` in a file, up to its next top-level line.
def tagBlock source, name
	let lines = source.split('\n')
	let start = lines.findIndex(do $1.startsWith("tag {name} <") or $1 == "tag {name}")
	return null if start < 0
	let out = []
	for line in lines.slice(start + 1)
		break if line.trim! and !line.startsWith('\t') and !line.startsWith('#')
		out.push(line)
	out

# The file's global css blocks (shared parts, e.g. the select's list).
def globalBlocks source
	let out = []
	let inside = no
	for line in source.split('\n')
		if line.startsWith('global css')
			inside = yes
		elif line.trim! and !line.startsWith('\t') and !line.startsWith('#')
			inside = no
		out.push(line) if inside
	out

# Each part's states: what its rules are keyed on, from a styled css block.
# `.control` then `&[data-state=checked]` (or `.item@hover`) gives control
# its checked and hover states.
def statesOf lines, parts
	let states = {}
	let current = []
	let currentIndent = -1
	for line in lines
		let text = line.trim!
		continue if !text or text.startsWith('#')
		let indent = line.match(/^\t*/)[0].length
		# A rule naming parts: `.a, .b …`, `.a[data-x] …`, `.a@hover …`.
		let named = Array.from(text.matchAll(/(?:^|[\s,>])\.([\w-]+)((?:\[[^\]]+\]|@[\w-]+|\.[\w-]+)*)/g))
		let mine = named.filter(do parts.includes($1[1]))
		if mine.length and !text.startsWith('&')
			current = unique(mine.map(do $1[1]))
			currentIndent = indent
			for m in mine
				states[m[1]] ||= []
				states[m[1]].push(...Array.from(m[2].matchAll(/\[[^\]]+\]|@[\w-]+/g)).map(do $1[0]))
		elif indent > currentIndent and current.length and (text.startsWith('&') or text.startsWith('@'))
			let found = Array.from(text.split(/\s/)[0].matchAll(/\[[^\]]+\]|@[\w-]+|^&\.[\w-]+/g)).map(do $1[0].replace(/^&/, ''))
			for part in current
				states[part] ||= []
				states[part].push(...found)
		elif indent <= currentIndent
			current = []
			currentIndent = -1
	for own part, list of states
		states[part] = unique(list)
	states

# Which parts carry Zag's props (and so its data-part and state attributes).
def zagPartsOf body
	unique(Array.from(body.join('\n').matchAll(/<(?!self\b)[\w-]+\.([\w-]+)[^\n>]*?\bzag=/g)).map(do $1[1]))

export def stylingOf folder
	let base = baseSource(folder)
	let styled = styledSource(folder)
	return [] unless styled
	let shared = globalBlocks(styled)
	# The tags in base.imba, then any inner ones from the folder's other files.
	let main = apiOf(base).map(do Object.assign({}, $1, { source: base }))
	let inner = innerSources(folder).flatMap(do(source) apiOf(source).map(do Object.assign({}, $1, { source, inner: yes })))
	let out = [...main, ...inner].map(do(api)
		let block = tagBlock(styled, api.tag)
		return null unless block
		let baseBlock = tagBlock(api.source, "{api.tag}-base") or []
		let rules = [...block, ...shared]
		let names = unique(Array.from([...rules, ...baseBlock].join('\n').matchAll(/\$(ui-[\w-]+)|--(ui-[\w-]+)/g)).map(do $1[1] or $1[2]))
		let doc = base.split('\n').filter(do $1.startsWith('#')).join('\n')
		let states = statesOf(rules, api.parts)
		let zag = zagPartsOf(baseBlock)
		{
			tag: api.tag
			inner: !!api.inner
			folder
			tokens: names.filter(do themeTokens.has($1))
			# Variables of its own: ones its docs name (the rest are internal).
			own: names.filter(do !themeTokens.has($1) and doc.includes($1))
			parts: api.parts.map(do { name: $1, states: states[$1] or [], zag: zag.includes($1) })
			path: importPath(folder)
			basePath: importPath(folder, yes)
		}
	).filter(Boolean)
	# A tag with no parts of its own (ui-select) names an inner tag's in its starter code.
	let innerPart = out.find(do $1.inner and $1.parts.length)..parts[0].name
	item.firstPart = item.parts[0]..name or innerPart for item in out
	out

# Starter code for one component, with its real names.
def snippets s
	let part = s.firstPart or 'part'
	let mine = s.tag.replace(/^ui-/, 'my-')
	# An inner tag is styled through the one it's inside.
	return [{ title: 'Through ui-' + s.folder, code: '<ui-' + s.folder + ">\n\tcss >>> .{part} c:$ui-accent" }] if s.inner
	[
		{ title: 'One instance', code: '<' + s.tag + ">\n\tcss >>> .{part} c:$ui-accent" }
		{ title: 'Every instance', code: "import '{s.path}'\n\ntag {mine} < {s.tag}\n\tcss .{part} c:$ui-accent" }
		{ title: 'Your own look (headless)', code: "import '{s.basePath}'\n\ntag {mine} < {s.tag}-base\n\tcss\n\t\td:block\n\t\t.{part} …" }
	]

# A "Styling" panel for a component page: one section per styled tag.
tag style-panel
	prop names = []

	get items do names.flatMap(do stylingOf($1))

	css
		d:flex fld:column g:6 p:5 bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius + 6px) shadow:$ui-card-shadow
		h3 m:0 mb:3 fs:md fw:600 ff:mono
		h4 m:0 mb:1.5 fs:xs fw:600 tt:uppercase ls:0.04em c:$ui-muted
		.block mb:4
		.hint m:0 mb:2 fs:xs c:$ui-muted
		.chips d:flex flw:wrap g:1.5
		.chip d:inline-flex ai:center g:1.5 px:1.5 py:0.5 rd:sm bg:$ui-hover ff:mono fs:xs c:$ui-text td:none
			@hover bg:$ui-border
		.swatch d:inline-block w:2.5 h:2.5 rd:2px bd:1px solid $ui-border
		code ff:mono fs:xs ws:nowrap
		.state ff:mono fs:xs c:$ui-muted
		.zag d:inline-block px:1.5 rd:sm bg:$ui-accent-soft c:$ui-accent-soft-text fs:11px fw:500
		.snippets d:grid gtc:1fr @md:1fr 1fr 1fr g:3
		.snippet d:flex fld:column g:1.5 min-width:0
		pre m:0 p:3 bg:$ui-hover rd:$ui-radius ff:mono fs:xs lh:1.6 tab-size:2 ofx:auto

	<self>
		for s in items
			<section>
				<h3> '<' + s.tag + '>'
				if s.inner
					<p.hint> "Rendered inside {names.map(do '<ui-' + $1 + '>').join(', ')}: reach its parts from there (css >>> .part), or set its tokens."
				
				if s.tokens.length
					<div.block>
						<h4> "Tokens it uses"
						<p.hint> "Set these on the app, a wrapper or the component itself; they reach every part that uses them."
						<div.chips> for name in s.tokens
							<a.chip route-to="/tokens?q={name}">
								<span.swatch style="background:var(--{name})"> if colourLike(name)
								"${name}"
				if s.own.length
					<div.block>
						<h4> "Its own variables"
						<p.hint> "For what no shared token covers; set them like tokens."
						<div.chips> for name in s.own
							<span.chip> "${name}"
				if s.parts.length
					<div.block>
						<h4> "Parts"
						<p.hint> "Each element's class, for css >>> .part (one instance) or a subclass's css (every instance). The states are what its styles are keyed on; restate the ones you change. Zag parts also carry data-part and state attributes ([data-part=trigger][data-state=open])."
						<ui-table size='sm'>
							<table>
								<thead>
									<tr>
										<th> "Part"
										<th> "States"
										<th> ""
								<tbody> for p in s.parts
									<tr>
										<td> <code> ".{p.name}"
										<td.state> p.states.join('  ') or '—'
										<td> <span.zag title='Carries Zag’s data-part and state attributes'> "Zag" if p.zag
				<div.block>
					<h4> "Starter code"
					<div.snippets> for snip in snippets(s)
						<div.snippet>
							<span.hint> snip.title
							<pre> <code> for tok in highlightImba(snip.code)
								<span .tok-{tok.kind or 'plain'}> tok.text
