import '../theme.imba'
import './base.imba'

# The list's look, shared by both modes.
global css
	[data-ui-select-list]
		# Zag copies the content's z-index onto its positioner.
		# At least as wide as the trigger, wider when the options need it.
		.content min-width:var(--reference-width) w:max-content max-width:min(24rem, var(--available-width, 24rem)) zi:50 fw:400 list-style:none m:0 bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius + 2px) shadow:$ui-shadow p:1 outline:none max-height:min(300px, var(--available-height)) ofy:auto box-sizing:border-box
		.item d:hcs g:2 px:2 py:1.5 rd:sm fs:sm cursor:pointer
			&[data-highlighted] bg:$ui-hover
			&[data-state=checked] fw:500
			&[data-disabled] o:0.4 cursor:not-allowed
		.item-indicator d:none c:$ui-accent
			&[data-state=checked] d:inline-flex
		.empty px:2 py:2 fs:sm c:$ui-muted
		# The create option, in the accent.
		.create d:hcl g:2 px:2 py:1.5 rd:sm fs:sm c:$ui-accent cursor:pointer
			&[data-highlighted] bg:$ui-hover
		# Tags match ui-tags-input: subtle (default), accent or outline.
		.tag d:hcl g:1 h:6.5 px:2.5 box-sizing:border-box rd:calc($ui-radius - 2px) fs:sm- fw:500 lh:1 bd:1px solid transparent bg:$ui-hover c:$ui-text
		&.accent .tag bg:$ui-accent-soft c:$ui-accent-soft-text
		&.outline .tag bg:$ui-surface bc:$ui-border
		.tag-text ws:nowrap of:hidden text-overflow:ellipsis max-width:48

tag ui-list-select < ui-list-select-base
	css
		d:block pos:relative c:$ui-text ff:$ui-font

		.label d:block fs:sm fw:500 mb:1.5
		.control d:hcl pos:relative
		.trigger d:hcs g:2 w:100% min-height:$ui-control-height px:3 bg:$ui-surface bd:1px solid $ui-border rd:$ui-radius fs:sm c:inherit ta:left cursor:pointer box-sizing:border-box
			@focus-visible bc:$ui-ring outline:2px solid $ui-ring-soft
			&[data-disabled] o:0.5 cursor:not-allowed
			&[data-invalid] bc:$ui-danger
		&.sm .trigger min-height:$ui-control-height-sm px:2.5 fs:sm-
		# With tags: the picks as chips in the button, which grows to fit them.
		.tags d:flex flw:wrap g:1 min-width:0 py:1
		.tag h:6 pr:2.5
		.value-text ws:nowrap of:hidden text-overflow:ellipsis
			&.placeholder c:$ui-muted
		.indicator d:inline-flex c:$ui-muted fls:0
			&[data-state=open] rotate:180deg
		.clear pos:absolute r:8 d:grid place-items:center w:6 h:6 bd:none bg:transparent rd:sm c:$ui-muted cursor:pointer
			@hover bg:$ui-hover c:$ui-text
			&[hidden] d:none
		# Quiet: the box and arrow show on hover, focus and while open.
		&.quiet .trigger bc:transparent bg:transparent
		# A faint arrow still says it can be changed.
		&.quiet .indicator o:0.35 transition:opacity 120ms
		&.quiet .trigger[data-disabled] .indicator o:0
		&.quiet .trigger@hover bc:$ui-border
		&.quiet .trigger@hover .indicator o:1
		&.quiet .trigger@focus-visible bg:$ui-surface
		&.quiet .trigger[data-state=open] bc:$ui-ring bg:$ui-surface
		&.quiet .trigger[data-state=open] .indicator o:1
		&.quiet .trigger[data-disabled] o:1 cursor:default bc:transparent


tag ui-search-select < ui-search-select-base
	css
		d:block pos:relative c:$ui-text ff:$ui-font

		.label d:block fs:sm fw:500 mb:1.5
		.control d:flex ai:center g:1 bg:$ui-surface bd:1px solid $ui-border rd:$ui-radius pl:2 pr:1 py:0.5 min-height:$ui-control-height box-sizing:border-box cursor:text
			@focus-within bc:$ui-ring outline:2px solid $ui-ring-soft
			&[data-disabled] o:0.5
			&[data-invalid] bc:$ui-danger
		&.sm .control min-height:$ui-control-height-sm
		.tags d:flex flw:wrap ai:center fl:1 min-width:0 g:1.5 py:0.5
		.input fl:1 min-width:16 bd:none bg:transparent outline:none fs:sm c:inherit p:0 h:6.5
			@placeholder c:$ui-muted
		.tag pl:2.5 pr:1
		.tag-remove d:grid place-items:center w:4.5 h:4.5 p:0 bd:none bg:transparent rd:sm c:inherit o:0.6 cursor:pointer
			@hover o:1 bg:rgba(0,0,0,0.08)
		.clear, .trigger
			d:grid place-items:center fls:0 w:7 h:7 bd:none bg:transparent rd:sm c:$ui-muted cursor:pointer
			@hover bg:$ui-hover c:$ui-text
			&[hidden] d:none
		.trigger[data-state=open] rotate:180deg
		&.quiet .control bc:transparent bg:transparent
		&.quiet .control@hover bc:$ui-border
		&.quiet .control@focus-within bc:$ui-ring bg:$ui-surface
		&.quiet .control[data-disabled] o:1 bc:transparent

tag ui-select < ui-select-base
	listTag = 'ui-list-select'
	searchTag = 'ui-search-select'

	css
		d:inline-block min-width:48
		&.searching min-width:60
