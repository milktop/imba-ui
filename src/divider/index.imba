import '../theme.imba'
import './base.imba'

tag ui-divider < ui-divider-base
	css
		--style:solid
		d:block c:$ui-muted ff:$ui-font
		&.dashed --style:dashed
		&.dotted --style:dotted
		.label d:none fls:0 fs:xs fw:500 ws:nowrap
		&.horizontal w:100% my:var(--spacing,0.75rem) bdt:1px var(--style) $ui-border
		# Labelled: two lines with the label between.
		&.horizontal.labelled d:flex ai:center g:3 bdt:none
			@before, @after content:'' flg:1 bdt:1px var(--style) $ui-border
			.label d:block
		&.horizontal.labelled.start@before flg:0 flb:4
		&.horizontal.labelled.end@after flg:0 flb:4
		&.vertical as:stretch w:0 min-height:1em mx:var(--spacing,0.5rem) bdl:1px var(--style) $ui-border
