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
		# Behind the content (ui-app-shell's main area), so cards and tables on
		# $ui-surface stand out from it.
		$ui-canvas:#f6f7f9
		$ui-border:#e4e4e7
		$ui-hover:#f4f4f5
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
		$ui-surface:#18181b
		$ui-canvas:#0f0f11
		$ui-border:#27272a
		$ui-hover:#27272a
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
