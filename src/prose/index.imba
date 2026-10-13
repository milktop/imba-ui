import '../theme.imba'
import './base.imba'

tag ui-prose < ui-prose-base
	css
		d:block c:$ui-text ff:$ui-font fs:sm lh:1.6 overflow-wrap:anywhere
		&.sm fs:sm- lh:1.6
		&.lg fs:md lh:1.6
		.content d:contents

# Its content is slotted or set as HTML, out of reach of the tag's scoped
# styles, so it's styled globally under ui-prose.
global css
	ui-prose
		> *:first-child, > .content > *:first-child mt:0
		> *:last-child, > .content > *:last-child mb:0
		p, ul, ol, blockquote, pre, table, figure m:0 mb:0.75em
		h1 m:1em 0 0.5em fs:1.6em fw:700 lh:1.25
		h2 m:1em 0 0.5em fs:1.3em fw:600 lh:1.3
		h3 m:0.9em 0 0.4em fs:1.1em fw:600 lh:1.3
		h4 m:0.9em 0 0.4em fs:1em fw:600
		ul, ol pl:1.25em
		ul list-style:disc
		ol list-style:decimal
		li > p m:0
		li + li mt:0.25em
		blockquote pl:0.75em bdl:3px solid $ui-border c:$ui-muted
		code py:0.125em px:0.3em rd:4px bg:$ui-hover ff:ui-monospace, monospace fs:0.9em
		pre py:0.75em px:1em rd:$ui-radius bg:$ui-hover ofx:auto fs:0.9em
		pre code p:0 bg:none
		a c:$ui-accent td:underline text-underline-offset:2px
		img d:block max-width:100% h:auto my:0.75em rd:$ui-radius
		hr my:1.5em bd:none bdt:1px solid $ui-border
		strong fw:600
		table w:100% border-collapse:collapse fs:0.95em
		th, td py:0.4em px:0.6em bdb:1px solid $ui-border ta:left
		th fw:600
