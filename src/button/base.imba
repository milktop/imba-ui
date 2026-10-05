import 'iconify-icon'
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
# - `round`: fully rounded: a circle for icon buttons, a pill with text
# - `count`: a badge on the top-right corner (hidden at 0 or null); past `max`
#   it shows e.g. "99+"
# - `dot`: a small dot there instead, for "something new"
# - `pulse`: a ring ripples out from the badge or dot, to draw the eye (not
#   when the system asks for less motion)
# - `countColor`: 'danger' (default), 'accent', 'success', 'warning' or
#   'neutral', for the dot too; or set `--ui-button-count-bg` and `--ui-button-count-text` in
#   CSS for any other
# - `countLabel`: what the count is, for assistive tech ('new': "Inbox, 3
#   new"); added to the button's aria-label, or read after its text
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
	prop round = false
	prop count = null
	prop max = 99
	prop dot = false
	prop pulse = false
	prop countColor = 'danger'
	prop countLabel = 'new'
	# What the caller asked for, kept apart from the native property (a `prop`
	# would just assign that), so loading can disable the button and undo it;
	# the attribute does the disabling.
	get disabled do !!#disabled
	set disabled v do #disabled = v

	def setup
		setAttribute('type', 'button') unless hasAttribute('type')

	get badge do count > 0 ? (count > max ? "{max}+" : String(count)) : (dot ? '' : null)
	get spoken do count > 0 ? "{count} {countLabel}" : (dot ? countLabel : '')

	# An icon-only button is square; text is whatever ends up in the slot (the
	# badge's own text aside).
	def rendered
		let text = Array.from(childNodes).some do(node)
			node.nodeType == 3 ? !!node.textContent.trim! : (node.nodeType == 1 and !node.classList.contains('badge') and !node.classList.contains('spoken') and !!node.textContent.trim!)
		classList.toggle('icon-only', !text)

	# An aria-label hides the button's text from assistive tech, so the count
	# joins the label itself; the caller's own label is kept apart from ours.
	def labelCount
		let label = getAttribute('aria-label')
		#ownLabel = label if label !== #wroteLabel
		return unless #ownLabel
		#wroteLabel = spoken ? "{#ownLabel}, {spoken}" : #ownLabel
		setAttribute('aria-label', #wroteLabel) if label !== #wroteLabel

	def render
		toggleAttribute('disabled', !!(disabled or loading))
		labelCount!

		<self .{variant} .{size} .block=block .round=round .loading=loading zag={ 'aria-busy': loading ? 'true' : undefined }>
			if loading
				<span.spinner aria-hidden='true'>
			elif icon
				<iconify-icon.icon icon=icon aria-hidden='true'>
			<slot>
			if iconEnd
				<iconify-icon.icon icon=iconEnd aria-hidden='true'>
			if badge != null
				<span.badge .dot=(badge === '') .pulse=pulse .{countColor} data-ui-pulse=(pulse or undefined) aria-hidden='true'> badge
				<span.spoken [pos:absolute w:1px h:1px of:hidden clip:rect(0 0 0 0) ws:nowrap]> ", {spoken}" unless #ownLabel
