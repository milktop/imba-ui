# Design tokens for the styled components. Override any of them in your app,
# e.g. map onto your own tokens:
#
#   global css @root
#     $ui-accent:$focus $ui-surface:$surface
#
# Dark values apply under `html.dark` or `[data-theme=dark]`.

import { appendCustomStyle } from 'iconify-icon'

# Icons draw inside iconify-icon's shadow root, out of reach of page CSS, but
# custom properties inherit into it: this rule there gives Lucide-style icons
# (a stroke width of 2 in their markup) the $ui-icon-stroke weight. Icons with
# any other stroke, or none, are left alone.
appendCustomStyle('[stroke-width="2"] { stroke-width: var(--ui-icon-stroke, 2); }')

# Plain rules Imba's CSS can't express: Zag's `hidden` on closed parts beats
# any component display (e.g. d:flex on a dialog panel, which would otherwise
# stay on screen, invisible but clickable); the browser's focus outline only
# shows for keyboard focus, not after a click; selected text takes
# $ui-selection; and animations stop when the system asks for less motion.
if typeof document != 'undefined' and !document.getElementById('ui-base-rules')
	let style = document.createElement('style')
	style.id = 'ui-base-rules'
	style.textContent = [
		'[data-scope][hidden] { display: none !important; }'
		'::selection { background: var(--ui-selection); }'
		'[data-scope]:focus:not(:focus-visible) { outline: none; }'
		'@media (prefers-reduced-motion: reduce) { [data-scope][data-part] { animation: none !important; transition: none !important; } }'
		'@media (prefers-reduced-motion: reduce) { [data-ui-pulse]::after { animation: none !important; } }'
		'@media (prefers-reduced-motion: reduce) { [data-ui-rolling] * { transition: none !important; } }'
	].join('\n')
	document.head.appendChild(style)

global css
	@root
		$ui-text:#18181b
		$ui-muted:#71717a
		$ui-surface:white
		# ui-app-shell's layers, one cool-neutral family: the canvas behind the
		# content (cards and tables on $ui-surface stand out from it), the inset
		# layout's sidebar a lighter shade of it, and the frame round the panel.
		$ui-canvas:#f2f4f7
		$ui-sidebar-bg:#f8f9fb
		$ui-frame:white
		$ui-border:#e4e4e7
		# Form controls (inputs, selects, checkboxes, …): their fill and border, and
		# the border on hover. Light, they match cards; dark, they sit a step below
		# the card with a stronger edge, so they read as places to type.
		$ui-field-bg:$ui-surface
		$ui-field-border:$ui-border
		$ui-field-border-hover:#d4d4d8
		# Text inputs the browser autofilled: a faint accent tint in place of its
		# own colour ($ui-field-bg hides it).
		$ui-field-autofill-bg:color-mix(in srgb, $ui-accent 8%, $ui-field-bg)
		$ui-hover:#f4f4f5
		# Loading placeholders: visible on the canvas and on cards alike.
		$ui-skeleton:#e4e4e7
		# The accent as an 11-step scale (Tailwind's blue until `appearance`, or
		# your own CSS, sets another); the accent tokens below are steps of it,
		# so setting the scale recolours them all, in light and dark.
		# $ui-accent-500-text is the text that reads on the 500 (dark mode's
		# accent): white, or the 950 for light accents like teal.
		$ui-accent-50:#eff6ff
		$ui-accent-100:#dbeafe
		$ui-accent-200:#bfdbfe
		$ui-accent-300:#93c5fd
		$ui-accent-400:#60a5fa
		$ui-accent-500:#3b82f6
		$ui-accent-600:#2563eb
		$ui-accent-700:#1d4ed8
		$ui-accent-800:#1e40af
		$ui-accent-900:#1e3a8a
		$ui-accent-950:#172554
		$ui-accent-500-text:white
		$ui-accent:$ui-accent-600
		$ui-accent-text:white
		$ui-accent-soft:$ui-accent-100
		$ui-accent-soft-text:$ui-accent-800
		# Selected text, and ui-highlight's marks.
		$ui-selection:color-mix(in srgb, $ui-accent 24%, transparent)
		$ui-highlight:color-mix(in srgb, $ui-accent 22%, transparent)
		$ui-ring:$ui-accent-500
		$ui-ring-soft:color-mix(in srgb, $ui-accent-500 20%, transparent)
		$ui-danger:#dc2626
		$ui-success:#16a34a
		$ui-warning:#d97706
		# Chart series, in order (the first is the accent).
		$ui-chart-1:$ui-accent
		$ui-chart-2:#14b8a6
		$ui-chart-3:#f59e0b
		$ui-chart-4:#f43f5e
		$ui-chart-5:#8b5cf6
		$ui-radius:6px
		$ui-shadow:0 10px 30px -10px rgba(0,0,0,0.25)
		# Cards at rest: a soft lift off the canvas (popups use $ui-shadow).
		$ui-card-shadow:0 1px 2px rgba(16,24,40,0.04)
		$ui-font:inherit
		# One height for buttons and inputs, so they line up in a row.
		$ui-control-height:2.25rem
		$ui-control-height-sm:2rem
		$ui-control-height-lg:2.75rem
		# Stroke icons' line weight (Lucide's own is 2, in a 24-unit grid).
		$ui-icon-stroke:2
		# ui-app-shell's sidebar, open and as an icon rail.
		$ui-sidebar-width:15rem
		$ui-sidebar-rail-width:3.5rem
		# Its nav items (and group toggles): size, shape and resting text.
		$ui-sidebar-item-height:2.125rem
		$ui-sidebar-item-padding:0 0.5rem 0 0.75rem
		$ui-sidebar-item-radius:$ui-radius
		$ui-sidebar-item-text:$ui-muted
		# The sidebar itself (outside the inset layout, which uses $ui-sidebar-bg),
		# its section headings and its own icon buttons (collapse, expand). With
		# the item tokens, enough for a coloured sidebar:
		#   ui-sidebar $ui-sidebar-surface:teal $ui-sidebar-item-text:white …
		$ui-sidebar-surface:$ui-surface
		# Its text outside the nav items (the logo, ui-sidebar-user), muted text,
		# and its edge and dividers: for a coloured sidebar.
		$ui-sidebar-text:$ui-text
		$ui-sidebar-muted:$ui-muted
		$ui-sidebar-border:$ui-border
		$ui-sidebar-heading:$ui-muted
		$ui-sidebar-icon:$ui-muted
		$ui-sidebar-hover-text:$ui-text
		# Its nav items: hovered, and the current page (aria-current). The inset
		# layout, on a grey sidebar, uses the -inset ones (white items).
		$ui-sidebar-hover:$ui-hover
		$ui-sidebar-active:$ui-hover
		$ui-sidebar-active-text:$ui-text
		$ui-sidebar-active-weight:500
		$ui-sidebar-active-shadow:none
		$ui-sidebar-inset-hover:color-mix(in srgb, $ui-surface 75%, transparent)
		$ui-sidebar-inset-active:$ui-surface
		$ui-sidebar-inset-active-shadow:0 1px 2px rgba(0,0,0,0.06)

	html.dark, [data-theme=dark]
		$ui-text:#fafafa
		$ui-muted:#a1a1aa
		# Depth runs the other way in the dark: the frame and sidebar darkest,
		# the canvas a step up, cards and popups a step up again.
		$ui-surface:#1c1c21
		$ui-canvas:#141418
		$ui-sidebar-bg:#0c0c0e
		$ui-frame:#0c0c0e
		$ui-border:#2b2b31
		$ui-field-bg:#17171b
		$ui-field-border:#3a3a42
		$ui-field-border-hover:#4a4a53
		$ui-hover:#27272d
		$ui-skeleton:#303036
		$ui-accent:$ui-accent-500
		$ui-accent-text:$ui-accent-500-text
		$ui-accent-soft:$ui-accent-900
		$ui-accent-soft-text:$ui-accent-200
		$ui-selection:color-mix(in srgb, $ui-accent 40%, transparent)
		$ui-highlight:color-mix(in srgb, $ui-accent 35%, transparent)
		$ui-ring:$ui-accent-400
		$ui-ring-soft:color-mix(in srgb, $ui-accent-400 20%, transparent)
		$ui-danger:#f87171
		$ui-success:#4ade80
		$ui-warning:#fbbf24
		$ui-chart-2:#2dd4bf
		$ui-chart-3:#fbbf24
		$ui-chart-4:#fb7185
		$ui-chart-5:#a78bfa
		$ui-shadow:0 10px 30px -10px rgba(0,0,0,0.6)
		# Shadows don't read on dark; borders do the work.
		$ui-card-shadow:none
