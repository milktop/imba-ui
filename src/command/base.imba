import * as dialog from '@zag-js/dialog'
import * as listbox from '@zag-js/listbox'
import { Machine, Presence, uid, defined } from '../zag.imba'
import { icons } from '../icons.imba'

# Headless command menu (⌘K): a dialog with a search box over a list of
# commands, filtered as you type.
#
#   <ui-command items=commands @select=run(e.detail)>
#     <ui-button slot='trigger' icon='lucide:search'> 'Search'
#
# ⌘K (Ctrl+K elsewhere) opens and closes it; ↑/↓ move through the results,
# Enter picks one, Escape closes it. The `trigger` slot is optional; bind the
# open state with `bind=` (or `bind:open=`) instead.
#
# - `items`: objects with `label`, plus optional `value`, `group` (a heading
#   the item is listed under), `icon` (Iconify), `description`, `shortcut`
#   text, `keywords` (extra words to match) and `disabled`. An item with
#   `href` goes there when picked.
# - `load`: optional async function(query) returning items, for server search
# - `hotkey`: the key used with ⌘/Ctrl; null turns the shortcut off
# - `navigate`: function(href) for items with `href`, e.g. Inertia's
#   `router.visit`. By default a link is clicked, which Imba's router picks up.
# - `hints`: false hides the keyboard hints along the bottom
#
# Emits `select` with the item's `value` (or the item, if it has none).

# How the shortcut reads on this platform: '⌘K' or 'Ctrl K'.
export def formatHotkey key = 'k'
	let mac = /Mac|iPhone|iPad/.test(globalThis.navigator..platform or '')
	mac ? "⌘{key.toUpperCase!}" : "Ctrl {key.toUpperCase!}"

tag ui-command-base
	prop open = false
	prop items = []
	prop label = 'Command menu'
	prop placeholder = 'Type a command or search…'
	prop emptyText = 'No results'
	prop loadingText = 'Searching…'
	prop hotkey = 'k'
	prop load = null
	prop debounce = 200
	prop navigate = null
	prop hints = true

	zagId = uid('command')
	presence = new Presence(self)
	query = ''
	loading = no
	#groups = []
	#results = []
	#sourceItems = null
	#ticket = 0

	# `bind=` targets `data`, which aliases `open` here.
	get data do open
	set data v do open = v

	get trigger do $triggerSlot..firstElementChild
	# The shortcut as it reads here ('⌘K'), for a trigger's hint.
	get hotkeyText do hotkey ? formatHotkey(hotkey) : null

	# Zag's key for an item.
	def keyOf item do String(item.value ?? item.href ?? item.label)

	# Every word typed must appear in the label, description, group or keywords.
	def matches item, words
		let text = [item.label, item.description, item.group, ...(item.keywords or [])].join(' ').toLowerCase!
		words.every(do text.includes($1))

	# Results in group order (by first appearance), so the list reads and the
	# arrow keys move the same way.
	def setResults list
		let names = []
		for item in list
			names.push(item.group or '') unless names.includes(item.group or '')
		#groups = names.map do(name) { name: name, items: list.filter(do ($1.group or '') == name) }
		#results = #groups.flatMap(do $1.items)
		#collection = listbox.collection
			items: #results
			itemToString: do(item) item.label
			itemToValue: do(item) keyOf(item)
			isItemDisabled: do(item) !!item.disabled

	def filterLocal text
		let words = text.trim!.toLowerCase!.split(/\s+/).filter(Boolean)
		setResults(words.length ? items.filter(do matches($1, words)) : items)

	def search text
		unless load
			filterLocal(text)
			return listMachine.refresh!
		let ticket = ++#ticket
		loading = yes
		render!
		clearTimeout(#timer)
		#timer = setTimeout(&, debounce) do
			let list = await load(text)
			return unless ticket == #ticket
			loading = no
			setResults(list or [])
			listMachine.refresh!

	def setup
		#sourceItems = items
		setResults(items)
		let initial = !!data
		machine = new Machine self, dialog.machine, do defined({
			id: zagId
			defaultOpen: initial
			initialFocusEl: do $input
			onOpenChange: do(details)
				data = details.open
				reset! if details.open
				emit('openchange', data) if machine.track(data)
		})
		machine.track(initial)
		# The value stays empty, so picking the same command again still counts.
		listMachine = new Machine self, listbox.machine, do
			id: "{zagId}-list"
			collection: #collection
			loopFocus: yes
			value: []
			onSelect: do(details) choose(details.value)

	def mount
		machine.start!
		listMachine.start!
		#onKey = do(e)
			return unless hotkey and (e.metaKey or e.ctrlKey) and e.key.toLowerCase! == hotkey
			e.preventDefault!
			let api = machine.connect(dialog)
			api.setOpen(!api.open)
		globalThis.addEventListener('keydown', #onKey)

	def unmount
		globalThis.removeEventListener('keydown', #onKey)
		machine.stop!
		listMachine.stop!

	# Each time it opens: an empty search over all the commands.
	def reset
		query = ''
		$input.value = '' if $input
		search('')

	# Highlights the first result once the input has focus, so Enter picks it.
	def highlightFirst
		globalThis.setTimeout(&, 0) do
			let api = listMachine.connect(listbox)
			api.highlightFirst! unless api.highlightedValue

	def choose key
		let item = #results.find(do keyOf($1) == key)
		return unless item
		machine.connect(dialog).setOpen(false)
		emit('select', item.value === undefined ? item : item.value)
		go(item.href) if item.href

	def go href
		return navigate(href) if navigate
		let link = globalThis.document.createElement('a')
		link.href = href
		globalThis.document.body.appendChild(link)
		link.click!
		link.remove!

	# Applied in render as well, since Machine re-renders without Imba's
	# `rendered` hook; the trigger only exists after the first render.
	def rendered
		trigger.zag = machine.connect(dialog).getTriggerProps! if trigger

	def render
		# New items from the parent replace the list (keeping the search).
		if items !== #sourceItems and !load
			#sourceItems = items
			filterLocal(query)
			listMachine.refresh!

		machine.syncValue !!data, do
			machine.connect(dialog).setOpen(!!data)

		let api = machine.connect(dialog)
		let list = listMachine.connect(listbox)
		trigger.zag = api.getTriggerProps! if trigger
		presence.update(api.open)

		<self>
			<span$triggerSlot.trigger-slot> <slot name='trigger'>
			<global>
				<div.backdrop zag=presence.keep(api.getBackdropProps!)>
				<div.positioner zag=api.getPositionerProps!>
					<div.content zag=presence.keep(api.getContentProps!) @animationend=presence.done!>
						<h2.sr-only zag=api.getTitleProps!> label
						<div.root zag=list.getRootProps!>
							<span.sr-only zag=list.getLabelProps!> label
							<div.search>
								<ui-icon.search-icon path=icons.search size=16>
								<input$input.input type='text' zag=list.getInputProps(autoHighlight: yes) placeholder=placeholder @input=search(e.target.value) @focus=highlightFirst @change.stop>
								<kbd.key.esc> "Esc"
							<div.list zag=list.getContentProps!>
								# Earlier results stay while a search runs.
								if loading and #results.length == 0
									<div.status> loadingText
								elif #results.length == 0
									<div.status> emptyText
								else
									for group, i in #groups
										<div.group zag=list.getItemGroupProps(id: "g{i}")>
											if group.name
												<div.group-label zag=list.getItemGroupLabelProps(htmlFor: "g{i}")> group.name
											for item in group.items
												<div.item zag=list.getItemProps(item: item, highlightOnHover: yes)>
													<iconify-icon.icon icon=item.icon aria-hidden='true'> if item.icon
													<span.text>
														<span.label> item.label
														<span.description> item.description if item.description
													<kbd.shortcut> item.shortcut if item.shortcut
							if hints
								<div.hints aria-hidden='true'>
									<span>
										<kbd.key> "↑"
										<kbd.key> "↓"
										" to navigate"
									<span>
										<kbd.key> "↵"
										" to select"
