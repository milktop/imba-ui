# Design tokens for the styled components. Override any of them in your app,
# e.g. map onto your own tokens:
#
#   global css @root
#     $ui-accent:$focus $ui-surface:$surface
#
# Dark values apply under `html.dark` or `[data-theme=dark]`.

# Imba's CSS has no reduced-motion modifier, so one plain rule turns the
# components' animations off when the system asks for less motion.
if typeof document != 'undefined' and !document.getElementById('ui-reduced-motion')
	let style = document.createElement('style')
	style.id = 'ui-reduced-motion'
	style.textContent = '@media (prefers-reduced-motion: reduce) { [data-scope][data-part] { animation: none !important; transition: none !important; } }'
	document.head.appendChild(style)

global css
	@root
		$ui-text:#18181b
		$ui-muted:#71717a
		$ui-surface:white
		$ui-border:#e4e4e7
		$ui-hover:#f4f4f5
		$ui-accent:#4f46e5
		$ui-accent-text:white
		$ui-accent-soft:#e0e7ff
		$ui-accent-soft-text:#3730a3
		$ui-ring:#6366f1
		$ui-ring-soft:#6366f133
		$ui-danger:#dc2626
		$ui-radius:6px
		$ui-shadow:0 10px 30px -10px rgba(0,0,0,0.25)
		$ui-font:inherit
		# One height for buttons and inputs, so they line up in a row.
		$ui-control-height:2.25rem
		$ui-control-height-sm:2rem
		$ui-control-height-lg:2.75rem

	html.dark, [data-theme=dark]
		$ui-text:#fafafa
		$ui-muted:#a1a1aa
		$ui-surface:#18181b
		$ui-border:#27272a
		$ui-hover:#27272a
		$ui-accent:#6366f1
		$ui-accent-soft:#312e81
		$ui-accent-soft-text:#c7d2fe
		$ui-ring:#818cf8
		$ui-ring-soft:#818cf833
		$ui-danger:#f87171
		$ui-shadow:0 10px 30px -10px rgba(0,0,0,0.6)
