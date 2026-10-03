import '../theme.imba'
import './base.imba'

global css
	@keyframes ui-sheet-fade-in
		from opacity:0
	@keyframes ui-sheet-fade-out
		to opacity:0
	@keyframes ui-sheet-in
		from transform:var(--sheet-from)
	@keyframes ui-sheet-out
		to transform:var(--sheet-from)

tag ui-sheet < ui-sheet-base
	css
		# The wrappers stay out of layout; the trigger sits where it was written.
		d:contents
		.trigger-slot d:contents

		.backdrop inset:0 pos:fixed zi:100 bg:rgba(0,0,0,0.45)
			&[data-state=open] animation:ui-sheet-fade-in 200ms ease-out
			&[data-state=closed] animation:ui-sheet-fade-out 160ms ease-in forwards
		# Covers the screen and lines the panel up against one edge; clicks pass
		# through to the backdrop, which closes it.
		.positioner inset:0 pos:fixed zi:100 d:flex pointer-events:none
			&[data-side=right] jc:flex-end
			&[data-side=top] ai:flex-start
			&[data-side=bottom] ai:flex-end
		.content pos:relative d:flex fld:column box-sizing:border-box bg:$ui-surface c:$ui-text ff:$ui-font fs:sm shadow:$ui-shadow outline:none pointer-events:auto
			&[data-state=open] animation:ui-sheet-in 240ms cubic-bezier(0.32, 0.72, 0, 1)
			&[data-state=closed] animation:ui-sheet-out 180ms ease-in forwards
			# Left and right: full height, a width by size.
			&[data-side=right], &[data-side=left] h:100dvh w:28rem max-width:calc(100vw - 2.5rem)
			&[data-side=right] bdl:1px solid $ui-border --sheet-from:translateX(100%)
			&[data-side=left] bdr:1px solid $ui-border --sheet-from:translateX(-100%)
			&[data-side=right].sm, &[data-side=left].sm w:20rem
			&[data-side=right].lg, &[data-side=left].lg w:40rem
			# Top and bottom: full width, a height that fits its content up to a limit.
			&[data-side=top], &[data-side=bottom] w:100% max-height:70dvh
			&[data-side=top] bdb:1px solid $ui-border rdb:calc($ui-radius + 6px) --sheet-from:translateY(-100%)
			&[data-side=bottom] bdt:1px solid $ui-border rdt:calc($ui-radius + 6px) --sheet-from:translateY(100%)
			&[data-side=top].sm, &[data-side=bottom].sm max-height:40dvh
			&[data-side=top].lg, &[data-side=bottom].lg max-height:90dvh
		.header px:6 pt:6 pr:12 fls:0
		.heading m:0 fs:lg fw:600
		.description m:0 mt:1.5 c:$ui-muted
		# The body scrolls; the header and footer stay put.
		.body flg:1 min-height:0 px:6 py:4 ofy:auto
		.header + .body pt:4
		# Without a header, keep clear of the close button.
		.close + .body pr:14
		.footer d:flex jc:flex-end g:2 flw:wrap px:6 py:4 fls:0 bdt:1px solid $ui-border
			&:not(:has(*)) d:none
		.footer >>> div[slot=footer] d:contents
		.close pos:absolute t:4 r:4 d:grid place-items:center w:8 h:8 bd:none bg:transparent rd:md c:$ui-muted cursor:pointer
			@hover bg:$ui-hover c:$ui-text
			@focus-visible outline:2px solid $ui-ring-soft
