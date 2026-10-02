# Headless button. Extending `button` makes the element a real <button>, so
# aria-label, type, disabled, form attributes and events work natively, and
# tooltips and popovers can use it as their trigger.
#
# - `variant`: 'default', 'primary', 'danger' or 'ghost' (styling hooks)
# - `size`: 'sm', 'md' (matching the inputs' height) or 'lg'
# - `icon`, `iconEnd`: Iconify names; with no text it is an icon button, so
#   give it an aria-label
# - `loading`: shows a spinner in place of the icon, sets aria-busy and
#   disables it
# - `block`: full width
#
# `type` defaults to 'button' rather than the native 'submit'; pass
# type='submit' for form buttons.
tag ui-button-base < button
	prop variant = 'default'
	prop size = 'md'
	prop icon = null
	prop iconEnd = null
	prop loading = false
	prop block = false
	# What the caller asked for, kept apart from the native property (a `prop`
	# would just assign that), so loading can disable the button and undo it;
	# the attribute does the disabling.
	get disabled do !!#disabled
	set disabled v do #disabled = v

	def setup
		setAttribute('type', 'button') unless hasAttribute('type')

	# An icon-only button is square; text is whatever ends up in the slot.
	def rendered
		classList.toggle('icon-only', !textContent.trim!)

	def render
		toggleAttribute('disabled', !!(disabled or loading))

		<self .{variant} .{size} .block=block .loading=loading zag={ 'aria-busy': loading ? 'true' : undefined }>
			if loading
				<span.spinner aria-hidden='true'>
			elif icon
				<iconify-icon.icon icon=icon aria-hidden='true'>
			<slot>
			if iconEnd
				<iconify-icon.icon icon=iconEnd aria-hidden='true'>
