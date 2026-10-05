import * as pagination from '@zag-js/pagination'
import { Machine, uid } from '../zag.imba'
import { icons } from '../icons.imba'

# Headless pagination: previous/next buttons and page numbers, with
# ellipses for long runs.
#
#   <ui-pagination count=students.length pageSize=10 bind=page>
#
# - `count`: the number of items; `pageSize` per page (10)
# - `page`: the current page, from 1; bindable (`bind=` or `bind:page=`)
# - `siblingCount`: pages shown either side of the current one (1)
# - `summary`: shows "Showing 11–20 of 95 items" alongside
# - `noun`: what the items are called in the summary ('items')
# - `firstLast`: buttons for the first and last page, shown when some pages
#   are hidden behind an ellipsis (false to never show them)
# - `label`: the nav's accessible name
#
# Emits `change` with the new page. Slice your rows with `rowsFor(list)`, or
# yourself: list.slice((page - 1) * pageSize, page * pageSize).
tag ui-pagination-base
	prop count = 0
	prop pageSize = 10
	prop page = 1
	prop siblingCount = 1
	prop summary = false
	prop noun = 'items'
	prop firstLast = true
	prop label = 'Pagination'

	zagId = uid('pagination')

	# `bind=` targets `data`, which aliases `page` here.
	get data do page
	set data v do page = v

	get totalPages do Math.max(1, Math.ceil(count / pageSize))
	get from do count ? (data - 1) * pageSize + 1 : 0
	get to do Math.min(data * pageSize, count)

	# The current page's slice of a list.
	def rowsFor list do (list or []).slice((data - 1) * pageSize, data * pageSize)

	def setup
		let initial = data
		machine = new Machine self, pagination.machine, do
			id: zagId
			count: count
			pageSize: pageSize
			siblingCount: siblingCount
			defaultPage: initial
			type: 'button'
			onPageChange: do(details)
				data = details.page
				emit('change', data) if machine.track(data)
		machine.track(initial)

	def mount do machine.start!
	def unmount do machine.stop!

	def render
		machine.watch "{count}|{pageSize}|{siblingCount}"
		# Past the last page (e.g. after filtering), go to the last one.
		data = totalPages if data > totalPages
		machine.syncValue data, do
			machine.connect(pagination).setPage(data)

		let api = machine.connect(pagination)
		# First and last only help when some page numbers are hidden.
		let edges = firstLast and api.pages.some(do $1.type == 'ellipsis')

		<self>
			<nav.root zag=api.getRootProps! aria-label=label>
				if summary
					<span.summary> "Showing {from}–{to} of {count}{noun ? ' ' + noun : ''}"
				<div.pages>
					if edges
						<button.nav-button zag=api.getFirstTriggerProps!> <ui-icon path=icons.firstPage size=16>
					<button.nav-button zag=api.getPrevTriggerProps!> <ui-icon path=icons.left size=16>
					for item, i in api.pages
						if item.type == 'page'
							<button.page zag=api.getItemProps(item)> item.value
						else
							<span.ellipsis zag=api.getEllipsisProps(index: i)> "…"
					<button.nav-button zag=api.getNextTriggerProps!> <ui-icon path=icons.right size=16>
					if edges
						<button.nav-button zag=api.getLastTriggerProps!> <ui-icon path=icons.lastPage size=16>
