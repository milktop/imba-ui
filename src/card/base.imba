# Headless card: a surface grouping related content.
#
#   <ui-card heading='Next lesson' description='Thursday at 16:00'>
#     <ui-button slot='actions' size='sm'> 'Reschedule'
#     …body…
#     <div slot='footer'> …
#
# - `heading`, `description`: the header, with an `actions` slot beside it
# - default slot: the body; `footer` slot: a footer strip
tag ui-card-base
	prop heading = null
	prop description = null

	<self>
		if heading or description
			<header.header>
				<div.titles>
					<h3.heading> heading if heading
					<p.description> description if description
				<div.actions> <slot name='actions'>
		<div.body> <slot>
		<footer.footer> <slot name='footer'>
