import '../theme.imba'
import './base.imba'
import '../checkbox/index.imba'

tag ui-checkbox-group < ui-checkbox-group-base
	checkboxTag = 'ui-checkbox'

	css
		d:block c:$ui-text ff:$ui-font

		.label d:block fs:sm fw:500 mb:1.5
		.group d:vflex g:2
		.items d:vflex g:2
			&.horizontal d:hflex flw:wrap g:2 4
			&.indented pl:6

		# Cards: each a bordered card (icon, label, description), ticked ones outlined.
		&.cards w:100%
		&.cards .items d:grid gtc:repeat(auto-fill, minmax(11rem, 1fr)) g:2
		&.cards >>> .item d:flex
		&.cards >>> .item .root d:flex flg:1 ai:flex-start g:2.5 p:3 bd:1px solid $ui-border rd:calc($ui-radius + 2px) bg:$ui-surface transition:border-color 120ms, background 120ms
		&.cards >>> .item .root@hover bc:$ui-muted
		&.cards >>> .item .root[data-state=checked] bc:$ui-accent bg:color-mix(in srgb, $ui-accent-soft 45%, $ui-surface) shadow:0 0 0 1px $ui-accent
		&.cards >>> .item .root[data-state=checked] .icon c:$ui-accent
		&.cards >>> .item .control mt:0.5
		&.cards >>> .item .label fw:500

		# Chips: pills that toggle, the tick showing inside when on.
		&.chips .items d:hflex flw:wrap g:1.5
		&.chips >>> .item .root g:1 h:7.5 px:3 box-sizing:border-box bd:1px solid $ui-border rd:full bg:$ui-surface fs:sm- transition:background 120ms, border-color 120ms
		&.chips >>> .item .root@hover bc:$ui-muted
		&.chips >>> .item .root[data-state=checked] bc:transparent bg:$ui-accent-soft c:$ui-accent-soft-text
		&.chips >>> .item .root@has(input:focus-visible) outline:2px solid $ui-ring-soft
		&.chips >>> .item .control w:auto h:auto bd:none bg:transparent c:inherit outline:none
		&.chips >>> .item .control d:none
		&.chips >>> .item .control[data-state=checked] d:grid
