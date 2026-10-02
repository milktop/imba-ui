# Headless skeleton: a placeholder shape while content loads.
#
# - `lines`: that many text-like lines (the last one shorter)
# - `circle`: a circle, e.g. for an avatar
# - `width`, `height`: any CSS length (defaults fit a line of text)
#
# It is hidden from assistive tech; announce loading elsewhere (aria-busy on
# the region, or a spinner's label).
tag ui-skeleton-base
	prop lines = 0
	prop circle = false
	prop width = null
	prop height = null

	# data-scope/part opt it into the reduced-motion rule in theme.imba.
	<self .circle=circle .text=(lines > 0) aria-hidden='true' data-scope='skeleton' data-part='root' [w:{width or 'auto'} h:{height or 'auto'}]>
		if lines > 0
			for i in [0 ... lines]
				<span.line .last=(i == lines - 1 and lines > 1)>
