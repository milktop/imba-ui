import { highlightWord } from '@zag-js/highlight-word'

# Headless highlight: text with the parts matching a search marked, e.g. in
# search results.
#
#   <ui-highlight text=student.name query=search>
#   <ui-highlight text=note query=search color='yellow'>
#
# - `text`: the text; `query`: what to mark (a string, or several)
# - `ignoreCase` (true), `matchAll` (true: every match, not just the first)
# - `color`: the marks' background: 'accent' (default, the $ui-highlight
#   token), 'yellow', 'amber', 'orange', 'red', 'green', 'teal', 'blue',
#   'purple', 'pink' or 'gray' (tints that keep the text readable, deeper in
#   dark mode), or any CSS colour, used as it is. For every highlight in the
#   app, set $ui-highlight instead.
const named = ['yellow', 'amber', 'orange', 'red', 'green', 'teal', 'blue', 'purple', 'pink', 'gray']

tag ui-highlight-base
	prop text = ''
	prop query = ''
	prop ignoreCase = true
	prop matchAll = true
	prop color = 'accent'

	get chunks
		# An empty query marks nothing.
		let queries = [].concat(query ?? []).filter(do String($1).trim!)
		return [{ text: String(text ?? ''), match: false }] unless queries.length
		highlightWord(text: String(text ?? ''), query: queries, ignoreCase: ignoreCase, matchAll: matchAll)

	def render
		let custom = color !== 'accent' and !named.includes(color)
		custom ? style.setProperty('--ui-highlight', color) : style.removeProperty('--ui-highlight')
		<self data-color=(named.includes(color) ? color : undefined)>
			for chunk in chunks
				if chunk.match
					<mark.mark> chunk.text
				else
					<span> chunk.text
