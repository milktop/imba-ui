import '../theme.imba'
import './base.imba'

tag ui-checkbox < ui-checkbox-base
	css
		# Top-aligned: as inline-block its baseline (and height) shifted with the icon.
		d:inline-flex va:top c:$ui-text ff:$ui-font

		.root d:inline-flex ai:center g:2 cursor:pointer fs:sm
			&[data-disabled] o:0.5 cursor:not-allowed
		.control d:grid place-items:center fls:0 w:4 h:4 bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius - 2px) c:$ui-accent-text
			&[data-state=checked], &[data-state=indeterminate] bg:$ui-accent bc:$ui-accent
			&[data-focus-visible] outline:2px solid $ui-ring-soft bc:$ui-ring
			&[data-invalid] bc:$ui-danger
		.indicator d:none
			&[data-state=checked], &[data-state=indeterminate] d:grid
