import '../theme.imba'
import './base.imba'

tag ui-tabs < ui-tabs-base
	css
		d:block w:100% c:$ui-text ff:$ui-font

		.list pos:relative d:flex g:1 ofx:auto
		.trigger pos:relative zi:1 d:inline-flex ai:center g:2 h:$ui-control-height px:3 bd:none bg:transparent c:$ui-muted ff:inherit fs:sm fw:500 ws:nowrap cursor:pointer rd:$ui-radius
			@hover c:$ui-text
			@focus-visible outline:2px solid $ui-ring-soft
			&[data-selected] c:$ui-text
			&[data-disabled] o:0.4 cursor:not-allowed
		.icon d:block w:1em h:1em fs:md
		.indicator transition-property:var(--transition-property) transition-duration:200ms
		.panels pt:4

		# Line: an underline that slides to the selected tab.
		&.line .list bdb:1px solid $ui-border
		&.line .trigger rd:0
		&.line .indicator pos:absolute b:-1px l:var(--left) w:var(--width) h:2px bg:$ui-accent

		# Pills: a raised pill behind the selected tab, like ui-segmented.
		&.pills .list d:inline-flex p:1 bg:$ui-hover rd:$ui-radius
		&.pills .trigger h:calc($ui-control-height - 8px) rd:calc($ui-radius - 2px)
		&.pills .indicator pos:absolute zi:0 t:var(--top) l:var(--left) w:var(--width) h:var(--height) bg:$ui-surface rd:calc($ui-radius - 2px) shadow:0 1px 3px rgba(0,0,0,0.12)

tag ui-tab < ui-tab-base
	css
		d:block outline:none
		@focus-visible outline:2px solid $ui-ring-soft outline-offset:4px rd:sm
