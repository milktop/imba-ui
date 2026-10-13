import * as tree from '@zag-js/tree-view'
import { Machine, uid, defined } from '../zag.imba'
import { icons } from '../icons.imba'
import 'iconify-icon'
import { uiLocale } from '../locale.imba'

# Headless tree view: nested items that open and close, e.g. folders,
# categories or a clinic's sites and rooms. Arrow keys move through it (←→
# close and open), typing jumps, Enter selects.
#
#   <ui-tree-view items=folders @select=open(e.detail)>
#   <ui-tree-view items=permissions checkable bind:checked=granted>
#
# - `items`: `{ value, label, icon, children, disabled }`; a node with
#   `children` is a branch (an empty array still opens and closes). Branches
#   without an icon get a folder.
# - `value`: the selected values (what `bind=` targets); `selectionMode`:
#   'single' (default) or 'multiple'
# - `expanded`: the open branches' values
# - `checkable`: a checkbox on each (ticking a branch ticks its children);
#   `checked`: the ticked values
# - `label`: the tree's name, shown above it and for assistive tech
#
# Emits `change` (the selected values), `select` (an item, not a branch, was
# chosen: its node), `expandedchange` and `checkedchange`.
tag ui-tree-view-base
	prop items = []
	prop value = []
	prop expanded = []
	prop checked = []
	prop selectionMode = 'single'
	prop checkable = false
	prop label = null

	zagId = uid('tree')
	isUiTree = yes

	# `bind=` targets `data`, which aliases `value` here.
	get data do value
	set data v do value = v

	get collection
		unless #items === items
			#items = items
			#collection = tree.collection
				nodeToValue: do(node) node.value
				nodeToString: do(node) String(node.label ?? node.value)
				isNodeDisabled: do(node) !!node.disabled
				rootNode: { value: '__root__', label: '', children: items or [] }
			machine..refresh!
		#collection

	def setup
		let initial = [].concat(data ?? [])
		machine = new Machine self, tree.machine, do defined({
			id: zagId
			translations: uiLocale.zag('treeView')
			collection: collection
			selectionMode: selectionMode
			defaultSelectedValue: initial
			defaultExpandedValue: [].concat(expanded ?? [])
			defaultCheckedValue: [].concat(checked ?? [])
			onSelectionChange: do(details)
				data = details.selectedValue
				# Not for the echo of a value set from outside.
				return unless machine.track(data)
				emit('change', data)
				# A single item chosen (not a branch): the focused one, or the last.
				let nodes = details.selectedNodes
				let node = nodes.find(do $1.value == details.focusedValue) or nodes[nodes.length - 1]
				emit('select', node) if node and !node.children
			onExpandedChange: do(details)
				expanded = details.expandedValue
				#expandedKey = String(expanded)
				emit('expandedchange', expanded)
			onCheckedChange: do(details)
				checked = details.checkedValue
				#checkedKey = String(checked)
				emit('checkedchange', checked)
		})
		machine.track(initial)
		#expandedKey = String(expanded ?? [])
		#checkedKey = String(checked ?? [])

	def mount do machine.start!
	def unmount do machine.stop!

	def render
		collection

		machine.syncValue data, do machine.connect(tree).setSelectedValue([].concat(data ?? []))
		# Open branches and ticks set from outside.
		if String(expanded ?? []) != #expandedKey
			#expandedKey = String(expanded ?? [])
			globalThis.queueMicrotask do machine.connect(tree).setExpandedValue([].concat(expanded ?? []))
		if String(checked ?? []) != #checkedKey
			#checkedKey = String(checked ?? [])
			globalThis.queueMicrotask do machine.connect(tree).setChecked([].concat(checked ?? []))

		api = machine.connect(tree)

		<self zag=api.getRootProps!>
			if label
				<span.label zag=api.getLabelProps!> label
			<div.tree zag=api.getTreeProps!>
				for node, i in (items or [])
					<ui-tree-view-node key=node.value node=node indexPath=[i] owner=self>

# One node of a ui-tree-view, and its children: rendered through the tree's
# Zag api, and styled by the tree (a child tag doesn't get its scope).
tag ui-tree-view-node
	prop node
	prop indexPath
	prop owner

	def render
		let api = owner.api
		let props = { node, indexPath }
		let state = api.getNodeState(props)
		let branch = !!node.children

		<self[d:contents]>
			if branch
				<div.branch zag=api.getBranchProps(props)>
					<div.branch-control zag=api.getBranchControlProps(props)>
						<span.branch-indicator zag=api.getBranchIndicatorProps(props)>
							<ui-icon path=icons.right size=14>
						if owner.checkable
							<span.checkbox zag=api.getNodeCheckboxProps(props)>
								<ui-icon path=(state.checked == 'indeterminate' ? icons.minus : icons.check) size=11> if state.checked
						<iconify-icon.icon icon=(node.icon or (state.expanded ? 'lucide:folder-open' : 'lucide:folder')) aria-hidden='true'>
						<span.branch-text zag=api.getBranchTextProps(props)> node.label
					<div.branch-content zag=api.getBranchContentProps(props)>
						<div.indent-guide zag=api.getBranchIndentGuideProps(props)>
						for child, i in node.children
							<ui-tree-view-node key=child.value node=child indexPath=[...indexPath, i] owner=owner>
			else
				<div.item zag=api.getItemProps(props)>
					if owner.checkable
						<span.checkbox zag=api.getNodeCheckboxProps(props)>
							<ui-icon path=(state.checked == 'indeterminate' ? icons.minus : icons.check) size=11> if state.checked
					<iconify-icon.icon icon=node.icon aria-hidden='true'> if node.icon
					<span.item-text zag=api.getItemTextProps(props)> node.label
