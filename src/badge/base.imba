import 'iconify-icon'
import { uiLocale } from '../locale.imba'

# Headless badge: a short label like a status or count.
#
# - `variant`: 'neutral' (default), 'accent', 'success', 'warning', 'danger'
#   or 'outline' (styling hooks)
# - `size`: 'sm' or 'md' (default)
# - `icon`: an Iconify name before the text
# - `dot`: a coloured dot instead
# - `removable`: an ✕ after the text that emits `remove`, for tags (an
#   applied filter, a record's label)
# - `removeLabel`: the ✕'s accessible name ('Remove …' by default)
tag ui-badge-base
	prop variant = 'neutral'
	prop size = 'md'
	prop icon = null
	prop dot = false
	prop removable = false
	prop removeLabel = null

	def requestRemove e
		e.stopPropagation!
		emit('remove')

	<self .{variant} .{size}>
		if dot
			<span.dot aria-hidden='true'>
		elif icon
			<iconify-icon.icon icon=icon aria-hidden='true'>
		<slot>
		if removable
			<button.remove type='button' aria-label=(removeLabel or uiLocale.messages.common.remove(textContent.trim!)) @click=requestRemove>
				<iconify-icon icon='lucide:x' aria-hidden='true'>
