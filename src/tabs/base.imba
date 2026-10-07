import * as zagTabs from '@zag-js/tabs'
import { Machine, uid, defined } from '../zag.imba'
import 'iconify-icon'

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
# - `counts`: where the tabs' counts sit: 'inline' (default, after the
#   label) or 'corner' (top right, like a button's)
tag ui-tabs-base
	prop value = null
	prop variant = 'line'
	prop counts = 'inline'

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

		<self .{variant} .corner-counts=(counts == 'corner') zag=api.getRootProps!>
			<div.list zag=api.getListProps!>
				for tab in tabs
					<button.trigger zag=api.getTriggerProps(value: String(tab.value), disabled: !!tab.disabled)>
						if tab.icon
							<iconify-icon.icon icon=tab.icon aria-hidden='true'>
						<span> tab.label
						if tab.badge != null
							<span.count .dot=(tab.badge === '') .pulse=tab.pulse .{tab.countColor} data-ui-pulse=(tab.pulse or undefined) aria-hidden='true'> tab.badge
							if tab.spoken
								<span.sr-only> ", {tab.spoken}"
				<div.indicator zag=api.getIndicatorProps!>
			<div$panels.panels> <slot>

# One panel of a ui-tabs; `label` (and optional `icon`) make its tab.
#
# - `count`: a small count after the label (hidden at 0 or null); past `max`
#   it shows e.g. "99+"
# - `dot`: a dot there instead, for "something to look at"
# - `pulse`: a ring ripples out from the count or dot (not when the system
#   asks for less motion)
# - `countColor`: 'neutral' (default, quiet), 'accent', 'danger', 'success'
#   or 'warning', for the dot too
# - `countLabel`: what the count is, for assistive tech ("Envois, 2 issues")
tag ui-tab-base
	prop value = null
	prop label = ''
	prop icon = null
	prop disabled = false
	prop count = null
	prop max = 99
	prop dot = false
	prop pulse = false
	prop countColor = 'neutral'
	prop countLabel = ''

	get badge do count > 0 ? (count > max ? "{max}+" : String(count)) : (dot ? '' : null)
	get spoken do count > 0 ? [count, countLabel].filter(Boolean).join(' ') : (dot ? countLabel : '')

	isUiTab = yes

	get tabs
		let node = parentElement
		node = node.parentElement until !node or node.isUiTabs
		node

	def render
		let api = tabs..machine ? tabs.api : null
		<self zag=(api ? api.getContentProps(value: String(value)) : { hidden: true })> <slot>
