import '../theme.imba'
import './base.imba'

tag ui-card < ui-card-base
	css
		d:flex fld:column pos:relative w:100% box-sizing:border-box min-width:0 bg:$ui-surface c:$ui-text bd:1px solid $ui-border rd:calc($ui-radius + 4px) shadow:$ui-card-shadow ff:$ui-font fs:sm
		$card-pad:1.25rem
		&[data-size=sm] $card-pad:0.875rem
		&[data-size=lg] $card-pad:1.75rem
		# Lifted off the page: a soft shadow does the border's work.
		&[data-variant=elevated] bc:transparent shadow:0 1px 2px rgba(16,24,40,0.05), 0 4px 12px -2px rgba(16,24,40,0.08)
		&[data-variant=outline] bg:transparent shadow:none
		# A tinted fill, for a panel inside a page or another card.
		&[data-variant=subtle] bg:color-mix(in srgb, $ui-hover 70%, $ui-surface) bc:transparent shadow:none
		html.dark &[data-variant=elevated], [data-theme=dark] &[data-variant=elevated] bc:$ui-border shadow:0 8px 24px -8px rgba(0,0,0,0.6)

		# A link: the cover takes the click; the card lifts on hover.
		.cover pos:absolute inset:0 zi:1 rd:inherit
			@focus-visible outline:2px solid $ui-ring outline-offset:2px
		&.link cursor:pointer transition:border-color 150ms, box-shadow 150ms, translate 150ms
			@hover bc:color-mix(in srgb, $ui-muted 50%, $ui-border) translate:0 -1px shadow:0 2px 4px rgba(16,24,40,0.06), 0 8px 20px -6px rgba(16,24,40,0.12)

		.header d:flex ai:flex-start g:3 px:$card-pad pt:$card-pad
		.icon d:grid place-items:center w:9 h:9 fls:0 mt:-0.5 rd:$ui-radius bg:$ui-accent-soft c:$ui-accent-soft-text fs:18px
		.titles fl:1 min-width:0
		.heading m:0 fs:md fw:600 lh:1.35
		.description m:0 mt:1 c:$ui-muted
		.actions d:flex g:2 fls:0
			&:not(:has(*)) d:none
		# No empty check here: a body of plain text has no child elements.
		.body p:$card-pad flg:1
		.header + .body pt:calc($card-pad * 0.8)
		&.divided .header pb:calc($card-pad * 0.8) bdb:1px solid $ui-border
		&.flush of:hidden
			.body p:0
			.header pb:calc($card-pad * 0.8) bdb:1px solid $ui-border
			.header + .body pt:0
		# The footer on a faint band, so actions read as the card's own.
		.footer d:flex ai:center jc:flex-end g:2 px:$card-pad py:calc($card-pad * 0.6) bdt:1px solid $ui-border bg:color-mix(in srgb, $ui-hover 55%, $ui-surface) rd:0 0 calc($ui-radius + 3px) calc($ui-radius + 3px)
			&:not(:has(*)) d:none
		&[data-variant=outline] .footer, &[data-variant=subtle] .footer bg:transparent
		# Slotted wrapper <div>s step aside, so their buttons are laid out here
		# (a button slotted directly keeps its own box).
		.actions >>> div[slot=actions], .footer >>> div[slot=footer] d:contents
