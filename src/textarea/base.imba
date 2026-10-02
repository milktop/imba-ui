# Headless textarea that grows with its content, from `rows` lines up to
# `maxRows` (then it scrolls). Set `autogrow` to false for a fixed height
# the user can resize.
#
# - `attrs`: any other attributes for the textarea, e.g. { maxlength: 500 }
#
# Works with `bind=`, `bind:value=` or `value` + `@change` like the other
# components; `change` emits the value on commit, native `input` events bubble.
tag ui-textarea-base
	prop value = null
	prop name = ''
	prop placeholder = ''
	prop rows = 3
	prop maxRows = null
	prop autogrow = yes
	prop attrs = null
	prop required = false
	prop disabled = false

	# `bind=` targets `data` and `bind:value=` targets `value`. Either way Imba
	# replaces that property with one reading and writing the bound model, so
	# `data` aliases `value` here and the textarea goes through `data`.
	get data do value
	set data v do value = v

	# Plain attributes go through Zag's spread, which drops undefined ones.
	get textareaAttrs
		let out = { name, placeholder }
		for own key, val of out
			out[key] = undefined if val == null or val === ''
		Object.assign(out, attrs)

	# Fit the height to the content: `auto` resets it to `rows` lines, then it
	# grows to the scroll height, capped at `maxRows` lines.
	def resize
		let el = $textarea
		return unless el and autogrow
		el.style.height = 'auto'
		let height = el.scrollHeight
		if maxRows
			let style = globalThis.getComputedStyle(el)
			let pad = parseFloat(style.paddingTop) + parseFloat(style.paddingBottom)
			let max = parseFloat(style.lineHeight) * maxRows + pad
			el.style.overflowY = height > max ? 'auto' : 'hidden'
			height = Math.min(height, max)
		el.style.height = "{height}px"

	def rendered do resize!

	<self>
		<textarea$textarea.textarea .autogrow=autogrow zag=textareaAttrs rows=rows required=required disabled=disabled bind=data @input=resize @change.stop=emit('change', data)>
