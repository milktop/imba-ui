import '../theme.imba'
import './base.imba'

tag ui-switch < ui-switch-base
	css
		# Top-aligned: as inline-block its baseline (and height) shifted with the icon.
		d:inline-flex va:top c:$ui-text ff:$ui-font

		.root d:inline-flex ai:center g:2 cursor:pointer fs:sm
			&[data-disabled] o:0.5 cursor:not-allowed
		.control d:inline-flex ai:center fls:0 w:9 h:5 p:0.5 box-sizing:border-box bg:$ui-border rd:full transition:background-color 150ms
			&[data-state=checked] bg:$ui-accent
			&[data-focus-visible] outline:2px solid $ui-ring-soft outline-offset:1px
			&[data-invalid] outline:1px solid $ui-danger
		.thumb w:4 h:4 bg:white rd:full shadow:0 1px 2px rgba(0,0,0,0.2) transition:transform 150ms
			&[data-state=checked] transform:translateX(1rem)
