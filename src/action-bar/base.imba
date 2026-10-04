import { Presence } from '../zag.imba'
import { icons } from '../icons.imba'

# Headless action bar: a small toolbar floating at the bottom of the screen
# while something is selected, e.g. table rows.
#
#   <ui-action-bar open=(picked.length > 0) @close=(picked = [])>
#     <span slot='selection'> "{picked.length} selected"
#     <ui-button size='sm'> 'Message'
#     <ui-button size='sm' variant='danger'> 'Archive'
#
# It isn't modal: the page stays usable (keep ticking rows) and focus isn't
# moved. It's rendered at the end of <body>, a `toolbar` for assistive tech.
#
# - `open`: shows it; bindable (`bind=` or `bind:open=`)
# - `selection` slot: the count or summary on the left
# - `closable`: false hides the close button; it (and Escape inside the bar)
#   closes it and emits `close`, where you'd clear the selection
# - `label`: the toolbar's accessible name
tag ui-action-bar-base
	prop open = false
	prop closable = true
	prop label = 'Selection actions'

	presence = new Presence(self, 200)

	# `bind=` targets `data`, which aliases `open` here.
	get data do open
	set data v do open = v

	def close
		data = no
		emit('close')

	def render
		presence.update(!!data)

		<self>
			<global>
				<div.positioner>
					<div.content role='toolbar' aria-label=label zag=presence.keep(hidden: !data, 'data-state': data ? 'open' : 'closed') @animationend=presence.done! @keydown.esc=close>
						<div.selection> <slot name='selection'>
						<span.separator aria-hidden='true'>
						<div.actions> <slot>
						if closable
							<button.close type='button' aria-label='Close' @click=close> <ui-icon path=icons.x size=14>
