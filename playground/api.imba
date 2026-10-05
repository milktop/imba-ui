import { highlightImba } from './demo.imba'

# The components' API, read from their base files: each headless tag's props
# (with defaults), what its doc comment says about them, the events it emits
# and its slots. Nothing to maintain: it follows the source.

const sources = import.meta.glob('../src/*/base.imba', { query: '?raw', import: 'default', eager: true })

# The source of one component, by folder name (e.g. 'date-picker').
export def baseSource name do sources["../src/{name}/base.imba"] or ''

# Every headless tag in a base file, with its API.
export def apiOf source
	let lines = (source or '').split('\n')
	let out = []
	for line, i in lines
		let m = line.match(/^tag (ui-[\w-]+?)-base(?:\s*<\s*([\w-]+))?/)
		continue unless m
		# The top-level comments since the previous tag (the doc comment is
		# usually right above it, but constants can sit in between).
		let doc = []
		let j = i - 1
		while j >= 0 and !lines[j].startsWith('tag ')
			doc.unshift(lines[j].replace(/^# ?/, '')) if lines[j].startsWith('#')
			j--
		# The tag's body: indented lines up to the next top-level one.
		let body = []
		let k = i + 1
		while k < lines.length and (lines[k].startsWith('\t') or !lines[k].trim!)
			body.push(lines[k])
			k++
		out.push
			tag: m[1]
			extends: m[2] and m[2] != 'ui-control' ? m[2].replace(/-base$/, '') : null
			usage: usageOf(doc)
			props: propsOf(body, describe(doc))
			events: unique(Array.from(body.join('\n').matchAll(/emit\('([\w-]+)'/g)).map(do $1[1]))
			slots: unique(Array.from(body.join('\n').matchAll(/<slot(?: name='([\w-]+)')?>/g)).map(do $1[1] or 'default'))
	out

# The doc comment's examples: indented blocks after a blank line, e.g.
#
#   <ui-table columns=columns rows=students>
def usageOf doc
	let blocks = []
	let block = null
	for line, i in doc
		if /^\s{2,}\S/.test(line) and (block or doc[i - 1] === '')
			block ||= blocks[blocks.push([]) - 1]
			block.push(line.replace(/^  /, ''))
		else
			block = null
	blocks.map(do $1.join('\n')).join('\n\n')

def unique list do Array.from(new Set(list))

# What the doc comment's bullets say, by prop name: "- `a`, `b`: text"
# (continued on indented lines) describes a and b.
def describe doc
	let notes = {}
	let current = null
	for line in doc
		# Leading `names` (joined by commas, slashes, "or", "and"), then the text.
		if let m = line.match(/^- ((?:`[\w-]+`[\s,\/]*(?:or |and )?)+)(.*)$/)
			current = { names: Array.from(m[1].matchAll(/`([\w-]+)`/g)).map(do $1[1]), text: m[2].replace(/^:\s*/, '') }
			notes[name] = current for name in current.names
		elif current and /^\s{2,}\S/.test(line)
			current.text += ' ' + line.trim!
		else
			current = null
	notes

def propsOf body, notes
	let props = []
	for line in body
		let m = line.match(/^\tprop (\w+)(?: = (.+))?$/)
		continue unless m
		props.push({ name: m[1], default: m[2] ?? 'null', note: notes[m[1]]..text or '' })
	props

# A "Props" panel for a component page: one table per tag in its base file.
tag api-panel
	prop names = []

	get apis do names.flatMap(do apiOf(baseSource($1)))

	css
		d:flex fld:column g:6 p:5 bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius + 6px) shadow:$ui-card-shadow
		.head d:flex ai:baseline g:2 flw:wrap mb:2
		h3 m:0 fs:md fw:600 ff:mono
		.extends c:$ui-muted fs:xs
		code ff:mono fs:xs
		.default c:$ui-muted
		.note ws:normal min-width:16rem c:$ui-muted
			.code ff:mono fs:xs c:$ui-text px:1 rd:sm bg:$ui-hover
		.chips d:flex ai:center g:1.5 flw:wrap mt:3 fs:xs c:$ui-muted
		.chip px:1.5 py:0.5 rd:sm bg:$ui-hover ff:mono c:$ui-text
		.none m:0 c:$ui-muted fs:sm
		.usage m:0 mb:4 p:4 bg:$ui-hover rd:$ui-radius ff:mono fs:xs lh:1.6 tab-size:2 ofx:auto

	<self>
		for api in apis
			<section>
				<div.head>
					<h3> "<{api.tag}>"
					<span.extends> "extends {api.extends}" if api.extends
				if api.usage
					<pre.usage> <code> for tok in highlightImba(api.usage)
						<span .tok-{tok.kind or 'plain'}> tok.text
				if api.props.length
					<ui-table size='sm'>
						<table>
							<thead>
								<tr>
									<th> "Prop"
									<th> "Default"
									<th> "Notes"
							<tbody> for p in api.props
								<tr>
									<td> <code> p.name
									<td> <code.default> p.default
									# `backticked` words in the notes show as code.
									<td.note> for part, i in p.note.split('`')
										<span .code=(i % 2 == 1)> part
				else
					<p.none> "No props of its own."
				if api.events.length
					<div.chips>
						<span> "Events:"
						for name in api.events
							<span.chip> name
				if api.slots.length
					<div.chips>
						<span> "Slots:"
						for name in api.slots
							<span.chip> name
