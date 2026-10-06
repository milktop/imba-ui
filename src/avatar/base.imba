import * as zagAvatar from '@zag-js/avatar'
import { Machine, uid } from '../zag.imba'
import { icons } from '../icons.imba'

# Headless avatar: an image, or initials while it loads and if it fails.
#
# - `src`: the image URL
# - `name`: used for the alt text and the initials ("Ada Lovelace" → AL);
#   without one the fallback is a person icon
# - `letters`: how many initials to show, 2 (default) or 1 ("Ada Lovelace" → A)
# - `size`: 'sm', 'md' (default), 'lg' or 'xl'
# - `square`: rounded square instead of a circle
# - `color`: 'accent' (default), 'gray', 'red', 'orange', 'amber', 'green',
#   'teal', 'blue', 'purple' or 'pink'; 'auto' picks one from the name, so the
#   same person always gets the same colour
#
#   <ui-avatar name='Ada Lovelace' color='pink'>
#   <ui-avatar name='Ada Lovelace' color='auto'>

const autoColors = ['red', 'orange', 'amber', 'green', 'teal', 'blue', 'purple', 'pink']

tag ui-avatar-base
	prop src = null
	prop name = null
	prop letters = 2
	prop size = 'md'
	prop square = false
	prop color = 'accent'

	zagId = uid('avatar')

	get initials
		let words = String(name or '').trim!.split(/\s+/).filter(Boolean)
		return '' unless words.length
		return words[0][0].toUpperCase! if Number(letters) === 1
		(words.length == 1 ? words[0].slice(0, 2) : words[0][0] + words[words.length - 1][0]).toUpperCase!

	get tone
		return color unless color === 'auto'
		let key = String(name or '').trim!
		return 'accent' unless key
		let hash = 2166136261 # FNV-1a, which spreads similar names well
		for ch in key
			hash = Math.imul(hash ^ ch.charCodeAt(0), 16777619) >>> 0
		autoColors[hash % autoColors.length]

	def setup
		machine = new Machine self, zagAvatar.machine, do
			id: zagId

	def mount do machine.start!
	def unmount do machine.stop!

	def render
		let api = machine.connect(zagAvatar)

		<self .{size} .square=square data-color=(tone === 'accent' ? undefined : tone) zag=api.getRootProps!>
			if src
				<img.image zag=api.getImageProps! src=src alt=(name or '')>
			<span.fallback zag=api.getFallbackProps! aria-hidden=(name ? undefined : 'true')>
				if initials
					initials
				else
					<svg.person viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width=2 stroke-linecap='round' stroke-linejoin='round'>
						<path d=icons.user>
