import '../theme.imba'
import '../dialog/index.imba'
import './base.imba'

tag ui-attachments < ui-attachments-base
	css
		d:block pos:relative w:100% c:$ui-text ff:$ui-font fs:sm
		.empty m:0 c:$ui-muted
		.files m:0 p:0 list-style:none
		.file pos:relative min-width:0
		.open d:flex w:100% p:0 bd:none bg:transparent c:inherit ff:inherit fs:inherit ta:left cursor:pointer rd:inherit
			@focus-visible outline:2px solid $ui-ring-soft outline-offset:2px
		.thumb pos:relative d:grid place-items:center of:hidden bg:$ui-hover c:$ui-muted
			img d:block w:100% h:100% object-fit:cover
		.icon fs:26px
		.ext pos:absolute b:1.5 l:50% transform:translateX(-50%) px:1.5 rd:sm bg:$ui-surface fs:10px fw:600 ls:0.04em c:$ui-muted
		.meta d:flex fld:column min-width:0
		.name fw:500 of:hidden text-overflow:ellipsis ws:nowrap
		.size fs:xs c:$ui-muted
		# Download and remove: over the tile's corner, shown on hover or focus.
		.actions pos:absolute d:flex g:1
		.action d:grid place-items:center w:7 h:7 p:0 bd:1px solid $ui-border rd:$ui-radius bg:$ui-surface c:$ui-muted cursor:pointer td:none shadow:$ui-card-shadow
			@hover c:$ui-text
			@focus-visible outline:2px solid $ui-ring-soft
		.add-input pos:absolute w:1px h:1px of:hidden clip:rect(0 0 0 0)
		.add-tile d:flex fld:column ai:center jc:center g:1.5 h:100% min-height:10 box-sizing:border-box bd:1.5px dashed $ui-border rd:calc($ui-radius + 2px) c:$ui-muted fs:sm cursor:pointer
			@hover c:$ui-text bc:$ui-muted bg:$ui-surface
			@focus-within outline:2px solid $ui-ring-soft

		# Grid: tiles with a 4:3 preview and the name under it.
		&.grid .files d:grid gtc:repeat(auto-fill, minmax(8.5rem, 1fr)) g:3
		&.grid .file bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius + 2px) of:hidden shadow:$ui-card-shadow
		&.grid .open fld:column
		&.grid .thumb aspect-ratio:4 / 3 w:100%
		&.grid .meta p:2 px:2.5
		&.grid .actions t:1.5 r:1.5 o:0 transition:opacity 120ms
		&.grid .file@hover .actions, &.grid .file@focus-within .actions o:1
		&.grid .add bd:none bg:transparent shadow:none
		&.grid .add-tile aspect-ratio:auto min-height:100%
		# With nothing yet, the add tile is a full-width dropzone.
		&.empty .add gc:1 / -1
		&.empty .add-tile min-height:28

		# List: rows with a small preview, the name and size, and the actions.
		&.list .files d:flex fld:column bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius + 2px) shadow:$ui-card-shadow of:hidden
		&.list .file d:flex ai:center bdb:1px solid $ui-border
			@last-child bdb:none
		&.list .open ai:center g:3 px:3 py:2.5 flg:1 min-width:0
			@hover bg:color-mix(in srgb, $ui-hover 60%, transparent)
		&.list .thumb w:10 h:10 fls:0 rd:$ui-radius
		&.list .icon fs:18px
		&.list .ext d:none
		&.list .actions pos:static pr:3
		&.list .action bd:none shadow:none bg:transparent
			@hover bg:$ui-hover
		&.list .add bdb:none
		&.list .add-tile fld:row min-height:12 bd:none rd:0 bdt:1px dashed $ui-border

		.limit fs:xs c:$ui-muted o:0.8
		.rejected d:flex fld:column g:0.5 m:0 mt:2 p:0 list-style:none fs:xs c:$ui-danger
		# While files are dragged over: a tinted overlay saying what dropping does.
		.drop-hint pos:absolute inset:-1.5 zi:5 d:flex fld:column ai:center jc:center g:1.5 rd:calc($ui-radius + 4px) bd:2px dashed $ui-accent bg:color-mix(in srgb, $ui-accent-soft 85%, transparent) c:$ui-accent-soft-text fw:500 pointer-events:none

		.preview d:block max-width:100% max-height:70vh mx:auto rd:$ui-radius
		.download-link d:inline-flex ai:center h:$ui-control-height-sm px:3 rd:$ui-radius bd:1px solid $ui-border c:$ui-text td:none fs:sm
			@hover bg:$ui-hover
