# Design tokens for the styled components. Override any of them in your app,
# e.g. map onto your own tokens:
#
#   global css @root
#     $ui-accent:$focus $ui-surface:$surface
#
# Dark values apply under `html.dark` or `[data-theme=dark]`.

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
		$ui-accent:#4f46e5
		$ui-accent-text:white
		$ui-accent-soft:#e0e7ff
		$ui-accent-soft-text:#3730a3
		$ui-ring:#6366f1
		$ui-ring-soft:#6366f133
		$ui-danger:#dc2626
		$ui-success:#16a34a
		# Chart series, in order (the first is the accent).
		$ui-chart-1:$ui-accent
		$ui-chart-2:#14b8a6
		$ui-chart-3:#f59e0b
		$ui-chart-4:#f43f5e
		$ui-chart-5:#0ea5e9
		$ui-radius:6px
		$ui-shadow:0 10px 30px -10px rgba(0,0,0,0.25)
		# Cards at rest: a soft lift off the canvas (popups use $ui-shadow).
		$ui-card-shadow:0 1px 2px rgba(16,24,40,0.05), 0 1px 3px rgba(16,24,40,0.06)
		$ui-font:inherit
		# One height for buttons and inputs, so they line up in a row.
		$ui-control-height:2.25rem
		$ui-control-height-sm:2rem
		$ui-control-height-lg:2.75rem
		# ui-app-shell's sidebar, open and as an icon rail.
		$ui-sidebar-width:15rem
		$ui-sidebar-rail-width:3.5rem

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
		$ui-accent:#6366f1
		$ui-accent-soft:#312e81
		$ui-accent-soft-text:#c7d2fe
		$ui-ring:#818cf8
		$ui-ring-soft:#818cf833
		$ui-danger:#f87171
		$ui-success:#4ade80
		$ui-chart-2:#2dd4bf
		$ui-chart-3:#fbbf24
		$ui-chart-4:#fb7185
		$ui-chart-5:#38bdf8
		$ui-shadow:0 10px 30px -10px rgba(0,0,0,0.6)
		# Shadows don't read on dark; borders do the work.
		$ui-card-shadow:none
