# Light, dark or system colour scheme for the whole page:
#
#   import { colorScheme } from '@milktop/imba-ui/color-scheme'
#   colorScheme.value = 'dark'           # 'light', 'dark' or 'system'
#   colorScheme.dark                     # what's showing: true or false
#
# Tags just read it in render: changes re-render the page (imba.commit), also
# when the OS or another tab changes it. `listen` is for code that doesn't
# render, like setting tokens of your own:
#
#   let stop = colorScheme.listen do(scheme, dark) …
#
# It puts `dark` on <html> (the theme's dark tokens apply under it) and sets
# `color-scheme` there for native controls and scrollbars. 'system' follows
# the OS setting live. The choice is saved in localStorage (`storageKey`) and
# kept in step across tabs. Importing it applies the saved choice straight
# away; to avoid a flash of light before your bundle loads, see the readme.
const schemes = ['light', 'dark', 'system']

class ColorScheme
	#key = 'ui-color-scheme'
	#value = 'system'
	#listeners = new Set

	constructor
		return unless globalThis.document
		#media = globalThis.matchMedia('(prefers-color-scheme: dark)')
		#media.addEventListener('change', do apply! if #value == 'system')
		globalThis.addEventListener('storage', do(e)
			if e.key == #key
				#value = parse(e.newValue)
				apply!
		)
		#value = load!
		apply!

	get storageKey do #key
	# Set it before the page reads a value (it reloads the saved choice).
	set storageKey key
		#key = key
		if #media
			#value = load!
			apply!

	get value do #value
	set value scheme
		scheme = parse(scheme)
		return if scheme == #value
		#value = scheme
		try globalThis.localStorage.setItem(#key, scheme)
		apply!

	get dark do #value == 'dark' or (#value == 'system' and !!#media..matches)

	# Calls `fn(scheme, dark)` on every change; returns a function that stops it.
	def listen fn
		#listeners.add(fn)
		let stop = do #listeners.delete(fn)
		stop

	def parse scheme do schemes.includes(scheme) ? scheme : 'system'

	def load
		let saved = null
		try saved = globalThis.localStorage.getItem(#key)
		parse(saved)

	def apply
		return unless #media
		let root = document.documentElement
		let dark = self.dark
		root.classList.toggle('dark', dark)
		root.style.colorScheme = dark ? 'dark' : 'light'
		fn(#value, dark) for fn of #listeners
		imba.commit!

export const colorScheme = new ColorScheme
