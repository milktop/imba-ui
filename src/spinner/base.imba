import { uiLocale } from '../locale.imba'
# Headless spinner for short waits.
#
# - `label`: announced to assistive tech (default 'Loading')
# - `size`: 'sm', 'md' (default) or 'lg'
tag ui-spinner-base
	prop label = null
	prop size = 'md'

	# data-scope/part opt it into the reduced-motion rule in theme.imba.
	<self .{size} role='status' aria-label=(label ?? uiLocale.messages.spinner.label) data-scope='spinner' data-part='root'>
