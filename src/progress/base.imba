import * as zagProgress from '@zag-js/progress'
import { Machine, uid, defined } from '../zag.imba'

# Headless progress indicator, as a bar or a circle.
#
# - `value`: from `min` to `max` (default 0 to 100); null means indeterminate,
#   for work of unknown length
# - `label`, `showValue`: a label and the formatted value (a percentage by
#   default; see `formatOptions`, `locale`)
# - `variant`: 'linear' (default) or 'circle'; `size` and `thickness` set the
#   circle's diameter and stroke in px
tag ui-progress-base
	prop value = null
	prop min = 0
	prop max = 100
	prop label = null
	prop showValue = false
	prop variant = 'linear'
	prop size = 48
	prop thickness = 5
	prop formatOptions = null
	prop locale = 'en-GB'

	zagId = uid('progress')

	def setup
		# `value` is added after defined(), which drops nulls: Zag treats a missing
		# value as the midpoint, and null as indeterminate.
		machine = new Machine self, zagProgress.machine, do Object.assign(defined({
			id: zagId
			min: min
			max: max
			formatOptions: formatOptions
			locale: locale
		}), { value: value ?? null })

	def mount do machine.start!
	def unmount do machine.stop!

	def render
		# Display only: a new value just refreshes the machine.
		machine.watch "{value}|{min}|{max}"
		let api = machine.connect(zagProgress)

		<self .{variant} zag=api.getRootProps!>
			if label or (showValue and variant == 'linear')
				<div.header>
					<span.label zag=api.getLabelProps!> label if label
					<span.value zag=api.getValueTextProps!> api.valueAsString if showValue and variant == 'linear'
			if variant == 'circle'
				<div.circle-wrap [--size:{size}px --thickness:{thickness}px]>
					<svg.circle zag=api.getCircleProps!>
						<circle.circle-track zag=api.getCircleTrackProps!>
						<circle.circle-range zag=api.getCircleRangeProps!>
					<span.circle-value zag=api.getValueTextProps!> api.valueAsString if showValue
			else
				<div.track zag=api.getTrackProps!>
					<div.range zag=api.getRangeProps!>
