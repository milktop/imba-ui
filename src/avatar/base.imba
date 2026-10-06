import * as zagAvatar from '@zag-js/avatar'
import { Machine, uid } from '../zag.imba'
import { icons } from '../icons.imba'
import '../tooltip/base.imba'

# Headless avatar: an image, or initials while it loads and if it fails.
#
# - `src`: the image URL
# - `name`: used for the alt text and the initials ("Ada Lovelace" → AL);
#   without one the fallback is a person icon
# - `letters`: how many initials to show, 2 (default) or 1 ("Ada Lovelace" → A)
# - `size`: 'sm', 'md' (default), 'lg' or 'xl', or a number in Imba's
#   spacing units (`size=8` is 32px, like `w:8`); the initials scale with it
# - `square`: rounded square instead of a circle
# - `color`: 'accent' (default), 'gray', 'red', 'orange', 'amber', 'green',
#   'teal', 'blue', 'purple' or 'pink'; 'auto' picks one from the name, so the
#   same person always gets the same colour
# - `tooltip`: shows the name in a tooltip on hover (handy in a stack);
#   `tooltip='…'` shows that text instead. Avatars can't take focus, so it's
#   mouse-only; screen readers already get the name
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
	prop tooltip = null

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

	get tooltipText
		return null if !tooltip and tooltip !== ''
		# A bare `tooltip` attribute arrives as its own name.
		[true, '', 'tooltip'].includes(tooltip) ? name : String(tooltip)

	# A number (or numeric string) is a custom size; the styled tag reads it
	# from --avatar-size.
	get customSize
		let n = Number(size)
		size !== null and size !== '' and Number.isFinite(n) ? n : null

	def setup
		machine = new Machine self, zagAvatar.machine, do
			id: zagId

	def mount do machine.start!
	def unmount do machine.stop!

	def render
		let api = machine.connect(zagAvatar)

		let custom = customSize
		if custom !== null
			style.setProperty('--avatar-size', "{custom * 0.25}rem")
		else
			style.removeProperty('--avatar-size')

		<self .{custom !== null ? 'custom' : size} .square=square data-color=tone zag=api.getRootProps!>
			if src
				<img.image zag=api.getImageProps! src=src alt=(name or '')>
			<span.fallback zag=api.getFallbackProps! aria-hidden=(name ? undefined : 'true')>
				if initials
					initials
				else
					<svg.person viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width=2 stroke-linecap='round' stroke-linejoin='round'>
						<path d=icons.user>
			# The tooltip's trigger is a layer over the whole avatar, since the
			# avatar itself carries Zag's root props.
			if tooltipText
				<ui-tooltip content=tooltipText>
					<span.tooltip-target>
