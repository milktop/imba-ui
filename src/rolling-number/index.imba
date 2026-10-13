import '../theme.imba'
import './base.imba'

tag ui-rolling-number < ui-rolling-number-base
	# A fixed line height in em: Imba turns the `lh` unit into a variable that
	# font-size utilities around it may set to a plain number.
	css
		d:inline-flex ai:baseline lh:1.2 font-variant-numeric:tabular-nums ws:nowrap
		# One digit: a window a line tall over a column of 0–9.
		.digit pos:relative d:inline-block h:1.2em of:hidden
		.sizer visibility:hidden
		.strip pos:absolute l:0 t:0 d:flex fld:column
			transform:translateY(calc(var(--digit) * -1.2em))
			transition:transform var(--duration) cubic-bezier(0.2, 0.7, 0.2, 1)
		.strip > span h:1.2em
