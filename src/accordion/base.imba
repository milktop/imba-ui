import * as zagAccordion from '@zag-js/accordion'
import { Machine, uid, defined } from '../zag.imba'
import { icons } from '../icons.imba'

# Headless accordion: <ui-accordion-item> children, each with a heading that
# expands its content.
#
#   <ui-accordion bind=open>
#     <ui-accordion-item value='pricing' heading='How much are lessons?'> …
#
# Arrow keys move between headings, Home/End jump to the ends.
#
# - `multiple`: several items open at once; the value is then an array
# - `collapsible`: the open item can be closed again (default yes)
#
# The value is the open item's own value (or null), or an array with
# `multiple`; `change` is emitted with it.
tag ui-accordion-base
	prop value = null
	prop multiple = false
	prop collapsible = true

	isUiAccordion = yes
	zagId = uid('accordion')
	items = []

	# `bind=` targets `data` and `bind:value=` targets `value`. Either way Imba
	# replaces that property with one reading and writing the bound model, so
	# `data` aliases `value` here and the component goes through `data`.
	get data do value
	set data v do value = v

	get api do machine.connect(zagAccordion)

	def keys value do [].concat(value ?? []).map(do String($1))
	def itemFor key do items.find(do String($1.value) == key)

	def setup
		let initial = keys(data)
		machine = new Machine self, zagAccordion.machine, do defined({
			id: zagId
			multiple: multiple
			collapsible: multiple or collapsible
			defaultValue: initial
			onValueChange: do(details)
				let values = details.value.map(do itemFor($1)..value ?? $1)
				data = multiple ? values : (values[0] ?? null)
				emit('change', data) if machine.track(data)
		})
		machine.track(data)

	def mount do machine.start!
	def unmount do machine.stop!

	# The items are the slotted children, known after the first render.
	def rendered
		let found = Array.from(children).filter(do $1.isUiAccordionItem)
		return if found.length == items.length and found.every(do(t, i) t == items[i])
		items = found
		render!

	def render
		machine.syncValue data, do
			machine.connect(zagAccordion).setValue(keys(data))

		let api = machine.connect(zagAccordion)
		item.render! for item in items

		<self zag=api.getRootProps!> <slot>

# One item of a ui-accordion: a heading button and the content it expands.
tag ui-accordion-item-base
	prop value = null
	prop heading = ''
	prop disabled = false

	isUiAccordionItem = yes

	get accordion
		let node = parentElement
		node = node.parentElement until !node or node.isUiAccordion
		node

	def render
		let api = accordion..machine ? accordion.api : null
		let props = { value: String(value), disabled: !!disabled }

		<self zag=(api ? api.getItemProps(props) : {})>
			<h3.heading>
				<button.trigger zag=(api ? api.getItemTriggerProps(props) : {})>
					<span.heading-text> heading
					<span.indicator zag=(api ? api.getItemIndicatorProps(props) : {})> <ui-icon path=icons.down>
			<div.content zag=(api ? api.getItemContentProps(props) : { hidden: true })>
				<div.inner> <slot>
