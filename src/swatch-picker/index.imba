import '../theme.imba'
import './base.imba'
import '../popover/index.imba'

tag ui-swatch-picker < ui-swatch-picker-base
	popoverTag = 'ui-popover'

	css
		--size:7
		d:block min-width:0 c:$ui-text ff:$ui-font
		&.sm --size:5.5
		&.lg --size:9
		.label d:block mb:1.5 fs:sm fw:500
		.items d:flex flw:wrap g:1.5
		.item d:inline-flex cursor:pointer
			&[data-disabled] o:0.4 cursor:not-allowed
		# A round swatch; chosen: a ring round it and a tick in it.
		.swatch d:grid place-items:center w:calc(var(--size) * 0.25rem) h:calc(var(--size) * 0.25rem) box-sizing:border-box rd:full bg:var(--swatch) c:white
			shadow:inset 0 0 0 1px color-mix(in srgb, black 12%, transparent) transition:transform 100ms
			.tick d:grid o:0
			&[data-state=checked] shadow:0 0 0 2px $ui-surface, 0 0 0 4px var(--swatch)
			&[data-state=checked] .tick o:1
			&[data-focus-visible] outline:2px solid $ui-ring outline-offset:3px
		.item@hover > .swatch transform:scale(1.08)
		# The colour's name, for assistive tech (and the title on hover).
		.item-text pos:absolute w:1px h:1px of:hidden clip:rect(0 0 0 0) ws:nowrap

		# The popover variant: a field showing the colour, like the inputs.
		.trigger d:flex ai:center g:2 w:100% min-width:0 box-sizing:border-box h:$ui-control-height px:2.5
			bd:1px solid $ui-field-border rd:$ui-radius bg:$ui-field-bg c:$ui-text font:inherit fs:sm ta:left cursor:pointer
			@hover bc:$ui-field-border-hover
			@focus-visible bc:$ui-ring outline:2px solid $ui-ring-soft
			&[aria-expanded=true] bc:$ui-ring outline:2px solid $ui-ring-soft
			&[aria-invalid=true] bc:$ui-danger
			@disabled o:0.5 cursor:not-allowed
		&.sm .trigger h:$ui-control-height-sm fs:sm-
		.chip fls:0 w:4.5 h:4.5 rd:full bg:var(--swatch) shadow:inset 0 0 0 1px color-mix(in srgb, black 12%, transparent)
			&.empty bg:repeating-linear-gradient(-45deg, $ui-border 0 2px, transparent 2px 5px)
		.value flg:1 min-width:0 of:hidden text-overflow:ellipsis ws:nowrap
			&.placeholder c:$ui-muted
		.indicator d:grid fls:0 c:$ui-muted
		# In the popover: as wide as its swatches, a few to a row.
		>>> .content w:auto p:3
		&.popover .items max-width:64 p:1
