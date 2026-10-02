import * as zagTabs from '@zag-js/tabs'
import { Machine, uid, defined } from '../zag.imba'

# Headless tabs: <ui-tab> children are the panels, and the tab list is built
# from their labels.
#
#   <ui-tabs bind=tab>
#     <ui-tab value='lessons' label='Lessons' icon='lucide:calendar'> …
#     <ui-tab value='invoices' label='Invoices'> …
#
# Arrow keys move between tabs (selecting as they go), Home/End jump to the
# ends. With no value, the first enabled tab is selected. Emits `change`
# with the tab's own value.
#
# - `variant`: 'line' (default, an underline) or 'pills' (styling hooks)
tag ui-tabs-base
	prop value = null
	prop variant = 'line'

	isUiTabs = yes
	zagId = uid('tabs')
	tabs = []

	# `bind=` targets `data` and `bind:value=` targets `value`. Either way Imba
	# replaces that property with one reading and writing the bound model, so
	# `data` aliases `value` here and the component goes through `data`.
	get data do value
	set data v do value = v

	get api do machine.connect(zagTabs)

	def tabFor key do tabs.find(do String($1.value) == key)

	def setup
		let initial = data == null ? null : String(data)
		machine = new Machine self, zagTabs.machine, do defined({
			id: zagId
			defaultValue: initial
			onValueChange: do(details)
				data = tabFor(details.value)..value ?? null
				emit('change', data) if machine.track(data)
		})
		machine.track(data)

	def mount do machine.start!
	def unmount do machine.stop!

	# The tabs are the slotted children, known after the first render; render
	# again when they change, and select the first enabled one if none is.
	def rendered
		let found = Array.from($panels..children or []).filter(do $1.isUiTab)
		return if found.length == tabs.length and found.every(do(t, i) t == tabs[i])
		tabs = found
		# Render's syncValue pushes it into Zag without emitting `change`.
		if data == null and let first = tabs.find(do !$1.disabled)
			data = first.value
		render!

	def render
		machine.syncValue data, do
			machine.connect(zagTabs).setValue(data == null ? null : String(data))

		let api = machine.connect(zagTabs)
		tab.render! for tab in tabs

		<self .{variant} zag=api.getRootProps!>
			<div.list zag=api.getListProps!>
				for tab in tabs
					<button.trigger zag=api.getTriggerProps(value: String(tab.value), disabled: !!tab.disabled)>
						if tab.icon
							<iconify-icon.icon icon=tab.icon aria-hidden='true'>
						<span> tab.label
				<div.indicator zag=api.getIndicatorProps!>
			<div$panels.panels> <slot>

# One panel of a ui-tabs; `label` (and optional `icon`) make its tab.
tag ui-tab-base
	prop value = null
	prop label = ''
	prop icon = null
	prop disabled = false

	isUiTab = yes

	get tabs
		let node = parentElement
		node = node.parentElement until !node or node.isUiTabs
		node

	def render
		let api = tabs..machine ? tabs.api : null
		<self zag=(api ? api.getContentProps(value: String(value)) : { hidden: true })> <slot>
