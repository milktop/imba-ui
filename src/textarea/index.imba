import '../theme.imba'
import './base.imba'

tag ui-textarea < ui-textarea-base
	css
		d:block px:3 py:2 box-sizing:border-box min-width:0
		bg:$ui-surface bd:1px solid $ui-border rd:$ui-radius c:$ui-text ff:$ui-font fs:sm
		@focus-within bc:$ui-ring outline:2px solid $ui-ring-soft
		&:has([aria-invalid=true]) bc:$ui-danger
		&:has(:disabled) o:0.5

		.textarea d:block w:100% p:0 m:0 bd:none bg:transparent outline:none c:inherit fs:inherit ff:inherit lh:1.5 resize:vertical
			@placeholder c:$ui-muted
			&.autogrow resize:none of:hidden
