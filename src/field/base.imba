import { uid } from '../zag.imba'
import { closestField, fieldIds } from '../control.imba'
import '../input/base.imba'
import '../number-input/base.imba'
import '../textarea/base.imba'
import '../password-input/base.imba'

# Defined in control.imba (which can't import this file without a cycle).
export { closestField, fieldIds }

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
# input (with `formatOptions`, `steppers`), `type='password'` a password
# input with a show/hide button, `type='textarea'` a textarea (with `rows`,
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
	prop formatOptions = null
	prop steppers = yes
	prop rows = 3
	prop maxRows = null
	prop required = false
	prop disabled = false

	# Tags of the default controls; the styled ui-field uses the styled ones.
	inputTag = 'ui-input-base'
	numberTag = 'ui-number-input-base'
	textareaTag = 'ui-textarea-base'
	passwordTag = 'ui-password-input-base'

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
	# click on the label focuses them instead. Checkboxes, switches and radios
	# have their own labels, so the field's must not toggle or pick them.
	get labelTarget
		nativeControl or querySelector('[data-scope] input:not([type=hidden], [type=checkbox], [type=radio], [hidden])')

	def focusControl
		return if $label.htmlFor
		let target = querySelector('[data-scope] :is(button:not([tabindex="-1"]), input[type=checkbox], [role=slider])')
		target ||= querySelector('[data-scope] input[type=radio]:checked') or querySelector('[data-scope] input[type=radio]')
		target..focus!

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
					<{numberTag} name=name placeholder=placeholder icon=icon prefix=prefix suffix=suffix min=min max=max step=step formatOptions=formatOptions steppers=steppers required=required disabled=disabled bind=data>
				elif type == 'password'
					<{passwordTag} name=name placeholder=placeholder autocomplete=(autocomplete or 'current-password') icon=icon required=required disabled=disabled bind=data>
				elif type == 'textarea'
					<{textareaTag} name=name placeholder=placeholder rows=rows maxRows=maxRows attrs=attrs required=required disabled=disabled bind=data>
				else
					<{inputTag} type=type name=name placeholder=placeholder autocomplete=autocomplete icon=icon prefix=prefix suffix=suffix min=min max=max step=step attrs=attrs required=required disabled=disabled bind=data>
		if error
			<p.error id=errorId role='alert'> error
		elif hint
			<p.hint id=hintId> hint
