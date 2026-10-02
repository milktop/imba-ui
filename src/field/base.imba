import { uid } from '../zag.imba'
import '../input/base.imba'
import '../number-input/base.imba'
import '../textarea/base.imba'

# Finds the ui-field (or subclass) a control sits in.
export def closestField el
	let node = el.parentElement
	node = node.parentElement until !node or node.isUiField
	node

# Zag ids for a component's label. Zag keeps `ids` from when the machine is
# created, before the component may be in a field, so the id is looked up on use.
export def fieldIds owner
	Object.defineProperty({}, 'label', enumerable: yes, get: do closestField(owner)..labelledBy)

# Headless form field: a label, hint and error around one control, wired up
# for assistive tech.
#
# - Components (ui-select etc.) find the field themselves: they skip their own
#   label, point aria-labelledby/-describedby at the field's, and go `invalid`
#   while there is an error.
# - A plain <input>, <select> or <textarea> gets an id, the label's `for`,
#   aria-describedby and aria-invalid.
# - `span`: columns (of 12) to take inside ui-fields.
#
# Without children it renders an input, passing on `type`, `name`,
# `placeholder`, `autocomplete`, `icon`, `prefix`, `suffix`, `min`, `max`,
# `step`, `attrs`, `required` and `disabled`. `type='number'` renders a number
# input (with `formatOptions`), `type='textarea'` a textarea (with `rows`,
# `maxRows`). Each gets the field's value: `bind=`, `bind:value=` or `value` +
# `@change`.
tag ui-field-base
	prop label = null
	prop hint = null
	prop error = null
	prop span = 12

	prop value = null
	prop type = 'text'
	prop name = ''
	prop placeholder = ''
	prop autocomplete = ''
	prop icon = null
	prop suffix = null
	prop min = null
	prop max = null
	prop step = null
	prop attrs = null
	prop formatOptions = null
	prop rows = 3
	prop maxRows = null
	prop required = false
	prop disabled = false

	# Tags of the default controls; the styled ui-field uses the styled ones.
	inputTag = 'ui-input-base'
	numberTag = 'ui-number-input-base'
	textareaTag = 'ui-textarea-base'

	# As in the inputs: `bind=` replaces `data`, which otherwise aliases `value`.
	get data do value
	set data v do value = v

	# `prefix` is a read-only DOM property (a namespace prefix), so a `prop`
	# can't assign it; an accessor of our own can.
	get prefix do #prefix
	set prefix v do #prefix = v

	isUiField = yes
	fieldId = uid('field')

	get labelId do "{fieldId}-label"
	get hintId do "{fieldId}-hint"
	get errorId do "{fieldId}-error"
	get invalid do !!error
	get labelledBy do label ? labelId : null
	# An error replaces the hint while there is one.
	get describedBy do error ? errorId : (hint ? hintId : null)

	# What changes a component's Zag props; components refresh when it does.
	get stateKey do "{labelledBy}|{invalid}"

	# Props for a component's focusable control. Zag's spread removes undefined.
	def describe props
		Object.assign({}, props, 'aria-describedby': describedBy ?? undefined)

	# The first native form control that isn't part of a component.
	get nativeControl
		for el in querySelectorAll('input, select, textarea')
			return el unless el.closest('[data-scope]')
		null

	# The label points `for` at a native control or a component's text input.
	# Components without one (ui-select's button) use aria-labelledby, and a
	# click on the label focuses them instead.
	get labelTarget
		nativeControl or querySelector('[data-scope] input:not([type=hidden])')

	def focusControl
		return if $label.htmlFor
		querySelector('[data-scope] button:not([tabindex="-1"])')..focus!

	def rendered
		let control = nativeControl
		if control
			control.id ||= "{fieldId}-control"
			for own name, value of { 'aria-describedby': describedBy, 'aria-invalid': invalid ? 'true' : null }
				value ? control.setAttribute(name, value) : control.removeAttribute(name)
		$label.htmlFor = labelTarget..id or '' if $label

	<self .invalid=invalid [--span:{span}]>
		if label
			<label$label.label id=labelId @click=focusControl>
				label
				<span.required aria-hidden='true'> ' *' if required
		<slot>
			# One wrapper element: Imba miscompiles a slot fallback that is an if/else.
			<div.default-control [d:contents]>
				if type == 'number'
					<{numberTag} name=name placeholder=placeholder icon=icon prefix=prefix suffix=suffix min=min max=max step=step formatOptions=formatOptions required=required disabled=disabled bind=data>
				elif type == 'textarea'
					<{textareaTag} name=name placeholder=placeholder rows=rows maxRows=maxRows attrs=attrs required=required disabled=disabled bind=data>
				else
					<{inputTag} type=type name=name placeholder=placeholder autocomplete=autocomplete icon=icon prefix=prefix suffix=suffix min=min max=max step=step attrs=attrs required=required disabled=disabled bind=data>
		if error
			<p.error id=errorId role='alert'> error
		elif hint
			<p.hint id=hintId> hint
