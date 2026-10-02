# Headless text input: a box holding a native <input>, with optional content
# before and after it.
#
# - `icon`: an Iconify name (e.g. 'lucide:mail') shown before the input; the
#   app must import 'iconify-icon' for it to render
# - `prefix` / `suffix`: text before or after the input (e.g. '£', 'kg')
# - `prefix` / `suffix` slots replace those for anything else, like buttons
# - default slot: replaces the <input> (e.g. with a <textarea>)
#
# Works with `bind=`, `bind:value=` or `value` + `@change` like the other
# components; `change` emits the value on commit, native `input` events bubble.
tag ui-input-base
	prop value = null
	prop type = 'text'
	prop name = ''
	prop placeholder = ''
	prop autocomplete = ''
	prop icon = null
	prop suffix = null
	prop required = false
	prop disabled = false

	# `bind=` targets `data` and `bind:value=` targets `value`. Either way Imba
	# replaces that property with one reading and writing the bound model, so
	# `data` aliases `value` here and the input goes through `data`.
	get data do value
	set data v do value = v

	# `prefix` is a read-only DOM property (a namespace prefix), so a `prop`
	# can't assign it; an accessor of our own can.
	get prefix do #prefix
	set prefix v do #prefix = v

	<self>
		<slot name='prefix'>
			if icon
				<span.affix.icon> <iconify-icon icon=icon>
			if prefix
				<span.affix> prefix
		<slot>
			<input.input type=type name=name placeholder=placeholder autocomplete=autocomplete required=required disabled=disabled bind=data @change.stop=emit('change', data)>
		<slot name='suffix'>
			if suffix
				<span.affix> suffix
