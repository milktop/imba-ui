import '../theme.imba'
import './base.imba'

tag ui-sortable-list < ui-sortable-list-base
	css
		d:block w:100% c:$ui-text ff:$ui-font fs:sm
		.list d:flex fld:column m:0 p:0 list-style:none
		&.card .list bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius + 2px) shadow:$ui-card-shadow
		&.plain .list g:2
		.item pos:relative d:flex ai:center g:2 py:2.5 px:3 bg:$ui-surface box-sizing:border-box outline:none us:none
		&.card .item bdb:1px solid $ui-border
			@first-child rd:calc($ui-radius + 2px) calc($ui-radius + 2px) 0 0
			@last-child bdb:none rd:0 0 calc($ui-radius + 2px) calc($ui-radius + 2px)
		&.plain .item bd:1px solid $ui-border rd:calc($ui-radius + 2px)
		# The rows it passes slide out of its way.
		.item.shifting transition:transform 150ms ease
		# Lifted while it's dragged (or picked up), above the others.
		.item.dragging zi:1 rd:calc($ui-radius + 2px) shadow:$ui-shadow cursor:grabbing
		# The whole row is the handle (handle=false): it shows it can be grabbed.
		.item[role=button] cursor:grab touch-action:none
			@focus-visible outline:2px solid $ui-ring-soft outline-offset:-2px
		.handle d:grid place-items:center fls:0 w:6 h:7 ml:-1 p:0 bd:none rd:calc($ui-radius - 2px) bg:transparent c:$ui-muted fs:md cursor:grab touch-action:none
			@hover bg:$ui-hover c:$ui-text
			@focus-visible outline:2px solid $ui-ring-soft
		.dragging .handle cursor:grabbing
		.content flg:1 min-width:0
		.sr-only pos:absolute w:1px h:1px of:hidden clip:rect(0 0 0 0) ws:nowrap
		&.disabled .item us:auto
