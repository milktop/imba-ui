# Headless prose: styles rich text (headings, lists, quotes, links, code,
# images and tables), e.g. the HTML a ui-editor saved, shown on a page. Its
# look matches the editor's, so what was written reads the same.
#
#   <ui-prose html=lesson.notes>
#   <ui-prose size='sm'>
#   	<h2> "Homework"
#   	<p> "Worksheet 4…"
#
# - `html`: an HTML string to show (only from a source you trust, such as
#   your own editor's output saved by your app); or give it children
# - `size`: 'sm' (13px), 'md' (14px, default) or 'lg' (16px)
tag ui-prose-base
	prop html = null
	prop size = 'md'

	<self .{size}>
		if html != null
			<div.content innerHTML=html>
		else
			<slot>
