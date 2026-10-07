import '../theme.imba'
import './base.imba'

# Shared with ui-button's count (same name, same frames).
global css @keyframes ui-pulse
	from transform:scale(1) opacity:0.7
	75%, to transform:scale(2.2) opacity:0

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

		# The count after a label: quiet by default, coloured for status.
		.count pos:relative d:inline-grid place-items:center min-width:18px h:18px px:1.25 box-sizing:border-box rd:full
			bg:var(--count-bg) c:var(--count-text) fs:11px fw:600 lh:1 font-variant-numeric:tabular-nums isolation:isolate
			--count-bg:$ui-hover --count-text:$ui-muted
			&.accent --count-bg:$ui-accent --count-text:$ui-accent-text
			&.danger --count-bg:$ui-danger --count-text:white
			&.success --count-bg:$ui-success --count-text:white
			&.warning --count-bg:#f59e0b --count-text:#451a03
			&.dot min-width:0 w:8px h:8px p:0
			&.neutral.dot --count-bg:$ui-muted
			# A copy of its colour that grows and fades behind it.
			&.pulse@after content:'' pos:absolute inset:0 zi:-1 rd:full bg:inherit animation:ui-pulse 1.6s cubic-bezier(0, 0, 0.2, 1) infinite
		.trigger[data-selected] .count.neutral --count-bg:$ui-accent-soft --count-text:$ui-accent-soft-text
		.sr-only pos:absolute w:1px h:1px of:hidden clip:rect(0 0 0 0) ws:nowrap
		.indicator transition-property:var(--transition-property) transition-duration:200ms
		.panels pt:4

		# Line: an underline that slides to the selected tab.
		&.line .list bdb:1px solid $ui-border
		# Taller than a control, so the underlined tabs have room to breathe.
		&.line .trigger rd:0 h:calc($ui-control-height + 0.5rem) px:3.5
		&.line .indicator pos:absolute b:-1px l:var(--left) w:var(--width) h:2px bg:$ui-accent

		# Pills: a raised pill behind the selected tab, like ui-segmented.
		&.pills .list d:inline-flex p:1 bg:$ui-hover rd:$ui-radius
		&.pills .trigger h:calc($ui-control-height - 8px) rd:calc($ui-radius - 2px)
		&.pills .indicator pos:absolute zi:0 t:var(--top) l:var(--left) w:var(--width) h:var(--height) bg:$ui-surface rd:calc($ui-radius - 2px) shadow:0 1px 3px rgba(0,0,0,0.12)

tag ui-tab < ui-tab-base
	css
		d:block outline:none
		@focus-visible outline:2px solid $ui-ring-soft outline-offset:4px rd:sm
