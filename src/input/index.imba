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
		>>> input::placeholder c:$ui-muted
		>>> textarea::placeholder c:$ui-muted
		# A slotted textarea fills the box, which pads it like the input.
		&:has(textarea) ai:stretch py:2
		>>> textarea resize:vertical lh:1.5
		# Number inputs drop the native spinners.
		>>> input[type=number] appearance:textfield
		>>> input::-webkit-inner-spin-button appearance:none m:0
		>>> input::-webkit-outer-spin-button appearance:none m:0
		.affix d:hcc fls:0 c:$ui-muted ws:nowrap
			&.start mr:1
		iconify-icon d:block w:1em h:1em fs:md
