import { uid } from '../zag.imba'

# Headless container for ui-field. The styled ui-fields lays them out on a
# 12-column grid, each field spanning its `span`, stacking when narrow.
#
# - `stackBelow`: the width (px) of the grid below which every field goes full
#   width (480 by default; 0 never stacks). Lower it for a form in a popover
#   or sidebar that should keep its columns. Give such a form a width: one
#   sized by its own content narrows once stacked, so it stays stacked
#
# With a `legend` (and optional `description`) or `disabled`, it is a real
# <fieldset>: assistive tech announces it as a named group, and `disabled`
# disables every control inside. Without them it is a plain wrapper (still a
# <fieldset>, with no role, so `disabled` can be toggled without moving the
# fields), so a simple form needs just one.
tag ui-fields-base
	prop legend = null
	prop description = null
	prop disabled = false
	prop stackBelow = 480

	fieldsId = uid('fields')

	get stacked do stackBelow > 0 and #width > 0 and #width < stackBelow

	# Container queries can't take a variable, so the grid is measured; the
	# observer reports before the first paint.
	def mount
		#observer = new ResizeObserver do
			let was = stacked
			#width = $grid.clientWidth
			render! if stacked != was
		#observer.observe($grid)

	def unmount
		#observer..disconnect!

	get grouped do !!(legend or disabled)

	<self>
		<fieldset.group role=(grouped ? undefined : 'presentation') disabled=!!disabled zag={ 'aria-describedby': description ? "{fieldsId}-description" : undefined }>
			if legend
				<legend.legend> legend
			if description
				<p.description id="{fieldsId}-description"> description
			<div$grid.grid .stacked=stacked> <slot>
