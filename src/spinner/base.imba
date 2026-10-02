# Headless spinner for short waits.
#
# - `label`: announced to assistive tech (default 'Loading')
# - `size`: 'sm', 'md' (default) or 'lg'
tag ui-spinner-base
	prop label = 'Loading'
	prop size = 'md'

	# data-scope/part opt it into the reduced-motion rule in theme.imba.
	<self .{size} role='status' aria-label=label data-scope='spinner' data-part='root'>
