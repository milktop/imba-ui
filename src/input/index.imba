import '../theme.imba'
import './base.imba'

tag ui-input < ui-input-base
	css
		d:hcl g:2 min-height:10 px:3 box-sizing:border-box min-width:0
		bg:$ui-surface bd:1px solid $ui-border rd:$ui-radius c:$ui-text ff:$ui-font fs:sm
		@focus-within bc:$ui-ring outline:2px solid $ui-ring-soft
		&:has([aria-invalid=true]) bc:$ui-danger
		&:has(:disabled) o:0.5

		# The default input or a slotted replacement.
		>>> :is(input, textarea) fl:1 min-width:0 p:0 bd:none bg:transparent outline:none c:inherit fs:inherit ff:inherit
			@placeholder c:$ui-muted
		>>> textarea as:stretch py:2 resize:vertical
		.affix d:hcc fls:0 c:$ui-muted ws:nowrap
		iconify-icon d:block w:1em h:1em fs:md
