import source from './theming.imba?raw'
import { highlightImba } from '../demo.imba'

const fonts = [
	{ value: 'inherit', label: 'Inherit' }
	{ value: 'Georgia, serif', label: 'Serif' }
	{ value: 'ui-monospace, monospace', label: 'Mono' }
]
const radii = [{ value: '2px', label: 'Sharp' }, { value: '6px', label: 'Default' }, { value: '12px', label: 'Round' }]
const strokes = [{ value: '1.5', label: 'Light' }, { value: '2', label: 'Default' }, { value: '2.5', label: 'Bold' }]

# Every instance, restyled: a subclass with its own css. Its rules match the
# markup it inherits, and rank alongside the library's (it's how ui-input
# itself styles ui-input-base). Import what it extends first, so the tag is
# defined when yours is:
#
#   import '@milktop/imba-ui/input'    # or the whole library: '@milktop/imba-ui'
tag pill-input < ui-input
	css rd:full px:4 bg:$ui-hover bc:transparent
		@focus-within bg:$ui-field-bg

# Your own look: the headless tag (behaviour, markup, Zag's states), styled
# from scratch. Import the headless tag (it brings no styles):
#
#   import '@milktop/imba-ui/switch/base'
tag square-switch < ui-switch-base
	css d:inline-flex
		.root d:inline-flex ai:center g:2 cursor:pointer fs:sm
		.control d:inline-flex w:10 h:5 p:0.5 box-sizing:border-box bd:2px solid $ui-text rd:0
			&[data-state=checked] bg:$ui-text
			&[data-focus-visible] outline:2px solid $ui-ring-soft outline-offset:2px
		.thumb w:3 h:3 bg:$ui-text transition:transform 120ms
			&[data-state=checked] bg:$ui-surface transform:translateX(1.25rem)
		.visually-hidden pos:absolute w:1px h:1px of:hidden clip:rect(0 0 0 0)

tag page-theming
	accent = '#e11d48'
	radius = '12px'
	font = 'inherit'
	stroke = '2'
	copied = no
	agree = yes
	when = '2026-10-14'

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
		.panel d:flex fld:column g:3 w:100% box-sizing:border-box p:4 bd:1px solid $ui-border rd:calc($ui-radius + 2px)
		.panel h4 m:0 fs:sm fw:600
		.wins w:100%
		code ff:mono fs:xs

	<self>
		<demo-page source=source heading='Theming' intro="Ways to change how the components look, from the broadest to the narrowest. Start with tokens (the $ui-* variables; Tokens lists them all): they reach every component at once. Reach for a component's parts only for what tokens don't cover.">
			<demo-section heading='The whole app'>
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
					<p.note> "Set tokens in your app's root CSS. Colours need their dark values too: the library's own, under html.dark, are more specific than @root (radius, font and sizes aren't redefined for dark mode). Import the components before your own styles, so yours come later. The Appearance panel (top right) does this for the whole playground."
					<div.snippet>
						<pre> <code> for tok in highlightImba(snippet)
							<span .tok-{tok.kind or 'plain'}> tok.text
						<ui-button.copy size='sm' @click=copy> copied ? "Copied" : "Copy"

			<demo-section heading='Part of a page'>
				<div.panel [$ui-accent:#059669 $ui-accent-soft:#d1fae5 $ui-accent-soft-text:#065f46 $ui-ring:#059669 $ui-ring-soft:#05966940 $ui-radius:4px $ui-control-height:2rem]>
					<h4> "Billing (green, square and dense)"
					<div.row>
						<ui-button variant='primary'> "Pay invoice"
						<ui-button variant='soft'> "Download"
						<ui-badge variant='accent'> "Paid"
						<ui-switch label='Autopay' checked=agree>
					<ui-input placeholder='Card holder'>
				<div.out>
					<p.note> "Tokens set on any element apply to everything inside it: here inline with [ ], or in a css block (css .billing $ui-accent:#059669 …). A token derived with color-mix at @root is worked out there, so set the derived ones too wherever you scope the accent."

			<demo-section heading='One component'>
				<div.row>
					<ui-button variant='primary' [$ui-accent:#7c3aed]> "Purple, just this one"
					<ui-input placeholder='Wider, rounder' [w:72 $ui-radius:9999px]>
					<ui-badge variant='accent' [rd:sm px:3 tt:uppercase ls:0.05em]> "Square badge"
				<div.out>
					<p.note> "[ ] on a component styles that one element: tokens (which reach its parts) or its own properties (width, margins, shape). Inline styles outrank the component's own."

			<demo-section heading="A component's parts">
				<ui-date-picker bind=when>
					css >>> .control rd:full px:3
						>>> .trigger c:$ui-accent
						>>> .clear d:none
				<div.out>
					<p.note> "A css block inside one instance reaches its parts with >>>, and outranks the library's styles. Each component's Props panel lists its parts (the class on each element); Zag's parts also carry data-part and state attributes ([data-state=open]). A part's own states (hover, focus) are rules too, so restate the ones you change."

			<demo-section heading='Every instance of a component' uses='pill-input'>
				<div.row>
					<pill-input icon='lucide:search' placeholder='Search'>
					<pill-input icon='lucide:mail' placeholder='Email'>
				<div.out>
					<p.note> "For a look you want everywhere, subclass the styled tag (import it first) and use yours. Its css applies to the markup it inherits, as the library's own does. (global css can't do this: the library's rules rank above a selector like ui-input .affix.)"

			<demo-section heading="A component's own variables">
				<div.row>
					<ui-button icon='lucide:inbox' count=12 [--ui-button-count-bg:#0f172a --ui-button-count-text:#fde047]> "Inbox"
					<ui-avatar-group items=['Ada Lovelace', 'Alan Turing', 'Grace Hopper'] [$ui-avatar-ring:$ui-accent-soft]>
				<div.out>
					<p.note> "Some components read variables of their own, for things no shared token covers: ui-button's --ui-button-count-bg and --ui-button-count-text, ui-avatar-group's $ui-avatar-ring. Their docs (the Props panel) name them. Set them like tokens: on the component or any element around it."

			<demo-section heading='Your own look' uses='square-switch'>
				<div.row>
					<square-switch label='Square switch' checked=agree>
				<div.out>
					<p.note> "Every component has a headless tag (ui-switch-base, imported from '@milktop/imba-ui/switch/base'): its behaviour, markup and Zag's states, with no styles. Subclass it to style it from scratch."

			<demo-section heading='Which wins' bare>
				<ui-table.wins>
					<table>
						<thead>
							<tr>
								<th> "Where"
								<th> "How"
								<th> "Reaches"
						<tbody>
							<tr>
								<td> "The whole app"
								<td> <code> "global css @root $ui-accent:…"
								<td> "Every component, through tokens"
							<tr>
								<td> "Part of a page"
								<td> <code> "<div [$ui-accent:…]>"
								<td> "Everything inside it; overrides @root"
							<tr>
								<td> "One component"
								<td> <code> "<ui-button [$ui-accent:… w:40]>"
								<td> "That element, and its parts through tokens"
							<tr>
								<td> "Its parts"
								<td> <code> "css >>> .trigger c:…"
								<td> "The parts of that instance; outranks the library"
							<tr>
								<td> "Every instance"
								<td> <code> "tag my-input < ui-input"
								<td> "Its parts, wherever you use yours"
							<tr>
								<td> "Your own look"
								<td> <code> "tag my-switch < ui-switch-base"
								<td> "Everything: no styles to fight"
