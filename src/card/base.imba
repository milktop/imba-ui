import 'iconify-icon'

# Headless card: a surface grouping related content.
#
#   <ui-card heading='Next lesson' description='Thursday at 16:00' icon='lucide:calendar'>
#     <ui-button slot='actions' size='sm'> 'Reschedule'
#     …body…
#     <div slot='footer'> …
#
# - `heading`, `description`: the header, with an `actions` slot beside it;
#   `icon`: an Iconify icon in a tinted tile beside them
# - default slot: the body; `footer` slot: a strip along the bottom, on a
#   faint band
# - `variant`: 'default' (a bordered surface), 'elevated' (lifted, no
#   border), 'outline' (a border, no fill or shadow) or 'subtle' (a tinted
#   fill, for a panel inside a page or another card)
# - `size`: 'sm', 'md' (default) or 'lg': the padding
# - `divided`: a line between the header and the body
# - `href`: the whole card is a link, lifting on hover
# - `flush`: no padding round the body, for content that runs edge to edge
#   (a `flush` ui-table, a list with its own dividers)
tag ui-card-base
	prop heading = null
	prop description = null
	prop icon = null
	prop variant = 'default'
	prop size = 'md'
	prop divided = false
	prop href = null
	prop flush = false

	<self .flush=flush .divided=divided .link=!!href data-variant=variant data-size=size>
		if href
			# A link over the whole card (the card itself is a custom element).
			<a.cover href=href aria-label=(heading or undefined)>
		if heading or description or icon
			<header.header>
				if icon
					<span.icon aria-hidden='true'> <iconify-icon icon=icon>
				<div.titles>
					<h3.heading> heading if heading
					<p.description> description if description
				<div.actions> <slot name='actions'>
		<div.body> <slot>
		<footer.footer> <slot name='footer'>
