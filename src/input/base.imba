import '../control.imba'

# Headless text input: a box holding a native <input>, with optional content
# before and after it.
#
# - `icon`: an Iconify name (e.g. 'lucide:mail') shown before the input; the
#   app must import 'iconify-icon' for it to render
# - `prefix` / `suffix`: text before or after the input (e.g. '£', 'kg')
# - `prefix` / `suffix` slots replace those for anything else, like buttons
# - `min`, `max`, `step`: as on a native input
# - `attrs`: any other attributes for the input, e.g. { inputmode: 'numeric' }
# - default slot: replaces the <input> (e.g. with a <textarea>)
#
# Works with `bind=`, `bind:value=` or `value` + `@change` like the other
# components; `change` emits the value on commit, native `input` events bubble.
tag ui-input-base < ui-control
	prop value = null
	prop type = 'text'
	prop name = ''
	prop placeholder = ''
	# Imba passes `autocomplete` (like inputmode, autofocus, spellcheck) through
	# set$, which only assigns a property that has a setter; a `prop` has none.
	get autocomplete do #autocomplete ?? ''
	set autocomplete v do #autocomplete = v
	prop icon = null
	prop suffix = null
	prop min = null
	prop max = null
	prop step = null
	prop attrs = null
	prop required = false
	prop disabled = false

	# `prefix` is a read-only DOM property (a namespace prefix), so a `prop`
	# can't assign it; an accessor of our own can.
	get prefix do #prefix
	set prefix v do #prefix = v

	# Plain attributes go through Zag's spread, which drops undefined ones, so
	# unset props don't leave empty attributes behind.
	get inputAttrs
		let out = { name, placeholder, autocomplete, min, max, step }
		for own key, val of out
			out[key] = undefined if val == null or val === ''
		Object.assign(out, attrs)

	<self>
		<slot name='prefix'>
			if icon
				<span.affix.start> <iconify-icon icon=icon>
			if prefix
				<span.affix.start> prefix
		<slot>
			<input.input zag=inputAttrs type=type required=required disabled=disabled bind=data @change.stop=emit('change', data)>
		<slot name='suffix'>
			if suffix
				<span.affix> suffix
