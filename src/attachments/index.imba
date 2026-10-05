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
		.add-tile d:flex ai:center box-sizing:border-box c:$ui-muted fs:sm cursor:pointer
			@hover c:$ui-text
			@focus-within outline:2px solid $ui-ring-soft outline-offset:2px
		.add-icon d:grid place-items:center fls:0
		.add-text d:flex fld:column min-width:0
		.add-label fw:500

		# Grid: tiles with a 4:3 preview and the name under it. Rows share a
		# height, so the add tile matches the others even on a row of its own.
		&.grid .files d:grid gtc:repeat(auto-fill, minmax(8.5rem, 1fr)) gar:1fr g:3
		# With `columns`: at most that many, fewer when tiles would drop below 7rem.
		&.grid.fixed .files gtc:repeat(auto-fill, minmax(max(7rem, calc((100% - (var(--columns) - 1) * 0.75rem) / var(--columns))), 1fr))
		&.grid .file bg:$ui-surface bd:1px solid $ui-border rd:calc($ui-radius + 2px) of:hidden shadow:$ui-card-shadow
		&.grid .open fld:column h:100%
		&.grid .thumb aspect-ratio:4 / 3 w:100%
		&.grid .meta p:2 px:2.5
		&.grid .actions t:1.5 r:1.5 o:0 transition:opacity 120ms
		&.grid .file@hover .actions, &.grid .file@focus-within .actions o:1
		&.grid .add bd:none bg:transparent shadow:none of:visible
		&.grid .add-tile fld:column jc:center g:2 h:100% min-height:24 p:3 ta:center bd:1.5px dashed $ui-border rd:calc($ui-radius + 2px)
			@hover bc:$ui-muted bg:$ui-surface
		&.grid .add-text ai:center g:0.5
		&.grid .add-icon w:9 h:9 rd:full bg:$ui-hover
		# On a row of its own, the add tile is a slim full-width row.
		&.grid.add-wide .files gar:auto
		&.grid.add-wide .add gc:1 / -1
		&.grid.add-wide .add-tile fld:row min-height:12 h:auto py:2.5 g:3
		&.grid.add-wide .add-icon w:7 h:7
		&.grid.add-wide .add-text fld:row g:2 ai:baseline
		# With nothing yet, the grid's add tile is a full-width dropzone (the list
		# keeps its usual add row).
		&.grid.empty .add gc:1 / -1
		&.grid.empty .add-tile min-height:28

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
		# The add row lines its icon up with the files' previews.
		&.list .add bdb:none
		&.list .add-tile flg:1 g:3 px:3 py:2.5
			@hover bg:color-mix(in srgb, $ui-hover 60%, transparent)
		&.list .add-icon w:10 h:10 rd:$ui-radius bd:1.5px dashed $ui-border box-sizing:border-box
		&.list .add-text fld:row g:2 ai:baseline

		.limit fs:xs c:$ui-muted o:0.8
		.rejected d:flex fld:column g:0.5 m:0 mt:2 p:0 list-style:none fs:xs c:$ui-danger
		# While files are dragged over: a tinted overlay saying what dropping does.
		.drop-hint pos:absolute inset:-1.5 zi:5 d:flex fld:column ai:center jc:center g:1.5 rd:calc($ui-radius + 4px) bd:2px dashed $ui-accent bg:color-mix(in srgb, $ui-accent-soft 85%, transparent) c:$ui-accent-soft-text fw:500 pointer-events:none

		.preview d:block max-width:100% max-height:70vh mx:auto rd:$ui-radius
		.download-link d:inline-flex ai:center h:$ui-control-height-sm px:3 rd:$ui-radius bd:1px solid $ui-border c:$ui-text td:none fs:sm
			@hover bg:$ui-hover
