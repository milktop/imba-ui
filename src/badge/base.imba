import 'iconify-icon'
# Headless badge: a short label like a status or count.
#
# - `variant`: 'neutral' (default), 'accent', 'success', 'warning', 'danger'
#   or 'outline' (styling hooks)
# - `size`: 'sm' or 'md' (default)
# - `icon`: an Iconify name before the text; `dot`: a coloured dot instead
tag ui-badge-base
	prop variant = 'neutral'
	prop size = 'md'
	prop icon = null
	prop dot = false

	<self .{variant} .{size}>
		if dot
			<span.dot aria-hidden='true'>
		elif icon
			<iconify-icon.icon icon=icon aria-hidden='true'>
		<slot>
