import '../control.imba'
import '../input/base.imba'

# Headless time input: a time of day, typed or picked with the browser's own
# time control (a wheel on phones), as 'HH:mm'. Inside a ui-field it takes
# the field's label, hint and error. (For booking from free slots, show the
# slots instead: a free time picked here can clash.)
#
#   <ui-time-input bind=starts step=15 min='08:00' max='18:00'>
#
# - `value`: 'HH:mm', or null
# - `step`: minutes between times (1); the arrow keys move by it
# - `min`, `max`: 'HH:mm'
# - `icon`: an Iconify name before it ('lucide:clock'; null for none)
# - `name`, `required`, `disabled`, `size`, `quiet`: as on ui-input
#
# Emits `change` with the time, or null when it's cleared.
tag ui-time-input-base < ui-control
	prop value = null
	prop step = 1
	prop min = null
	prop max = null
	prop icon = 'lucide:clock'
	prop name = ''
	prop required = false
	prop disabled = false
	prop size = 'md'
	prop quiet = false

	# The input inside; the styled tag uses ui-input.
	inputTag = 'ui-input-base'

	# The icon opens the browser's picker (whose own indicator the styled tag
	# hides, so there's one clock, not two).
	def openPicker e
		return unless icon and e.target.closest('.affix')
		try querySelector('input').showPicker!

	def change e
		data = e.detail or null
		emit('change', data)

	<self .has-icon=!!icon @click=openPicker>
		<{inputTag} type='time' value=(data ?? '') icon=icon min=min max=max step=(Number(step) * 60) name=name required=required disabled=disabled size=size quiet=quiet @change.stop=change>
