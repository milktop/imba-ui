import '../theme.imba'
import './base.imba'

global css @keyframes ui-spin
	to transform:rotate(360deg)

tag ui-spinner < ui-spinner-base
	css
		d:inline-block fls:0 w:5 h:5 box-sizing:border-box va:middle bd:2px solid $ui-border bc:$ui-accent $ui-border $ui-border $ui-border rd:full animation:ui-spin 0.7s linear infinite
		&.sm w:4 h:4
		&.lg w:8 h:8 bw:3px
