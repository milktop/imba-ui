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
# shows for keyboard focus, not after a click; and animations stop when the
# system asks for less motion.
if typeof document != 'undefined' and !document.getElementById('ui-base-rules')
	let style = document.createElement('style')
	style.id = 'ui-base-rules'
	style.textContent = [
		'[data-scope][hidden] { display: none !important; }'
		'[data-scope]:focus:not(:focus-visible) { outline: none; }'
		'@media (prefers-reduced-motion: reduce) { [data-scope][data-part] { animation: none !important; transition: none !important; } }'
		'@media (prefers-reduced-motion: reduce) { [data-ui-pulse]::after { animation: none !important; } }'
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
		$ui-hover:#f4f4f5
		# Loading placeholders: visible on the canvas and on cards alike.
		$ui-skeleton:#e4e4e7
		$ui-accent:#2563eb
		$ui-accent-text:white
		$ui-accent-soft:#dbeafe
		$ui-accent-soft-text:#1e40af
		$ui-ring:#3b82f6
		$ui-ring-soft:#3b82f633
		$ui-danger:#dc2626
		$ui-success:#16a34a
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
		$ui-hover:#27272d
		$ui-skeleton:#303036
		$ui-accent:#3b82f6
		$ui-accent-soft:#1e3a8a
		$ui-accent-soft-text:#bfdbfe
		$ui-ring:#60a5fa
		$ui-ring-soft:#60a5fa33
		$ui-danger:#f87171
		$ui-success:#4ade80
		$ui-chart-2:#2dd4bf
		$ui-chart-3:#fbbf24
		$ui-chart-4:#fb7185
		$ui-chart-5:#a78bfa
		$ui-shadow:0 10px 30px -10px rgba(0,0,0,0.6)
		# Shadows don't read on dark; borders do the work.
		$ui-card-shadow:none
