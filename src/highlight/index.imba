import '../theme.imba'
import './base.imba'

tag ui-highlight < ui-highlight-base
	css
		d:inline
		.mark py:0 px:0.0625em rd:2px bg:$ui-highlight c:inherit fw:600
		# Named colours: a see-through tint, so the text keeps its own colour.
		&[data-color] .mark bg:color-mix(in srgb, var(--highlight-color) 32%, transparent)
		&[data-color=yellow] --highlight-color:#facc15
		&[data-color=amber] --highlight-color:#f59e0b
		&[data-color=orange] --highlight-color:#f97316
		&[data-color=red] --highlight-color:#ef4444
		&[data-color=green] --highlight-color:#22c55e
		&[data-color=teal] --highlight-color:#14b8a6
		&[data-color=blue] --highlight-color:#3b82f6
		&[data-color=purple] --highlight-color:#a855f7
		&[data-color=pink] --highlight-color:#ec4899
		&[data-color=gray] --highlight-color:#71717a
		html.dark &[data-color] .mark, [data-theme=dark] &[data-color] .mark bg:color-mix(in srgb, var(--highlight-color) 42%, transparent)
