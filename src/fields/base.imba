import { uid } from '../zag.imba'

# Headless container for ui-field. The styled ui-fields lays them out on a
# 12-column grid, each field spanning its `span`, stacking when narrow.
#
# With a `legend` (and optional `description`) or `disabled`, it is a real
# <fieldset>: assistive tech announces it as a named group, and `disabled`
# disables every control inside. Without them it is a plain wrapper, so a
# simple form needs just one.
tag ui-fields-base
	prop legend = null
	prop description = null
	prop disabled = false

	fieldsId = uid('fields')

	get grouped do !!(legend or disabled)

	<self>
		<{grouped ? 'fieldset' : 'div'}.group disabled=(grouped and disabled) zag={ 'aria-describedby': description ? "{fieldsId}-description" : undefined }>
			if legend
				<legend.legend> legend
			if description
				<p.description id="{fieldsId}-description"> description
			<div.grid> <slot>
