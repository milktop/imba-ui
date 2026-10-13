import { icons } from '../icons.imba'
import '../dialog/base.imba'
import '../segmented/base.imba'
import { uid } from '../zag.imba'
import '../control.imba'
import 'iconify-icon'
import { uiLocale } from '../locale.imba'
import { formatBytes } from '../format/base.imba'

# Headless attachments: the files added to a page or form, as a grid of
# tiles (image thumbnails, or an icon and the extension) or a compact list.
#
#   <ui-attachments bind=files removable addable>
#
# - items (`bind=`, `bind:items=` or `items`): plain objects { name, size
#   (bytes, or text), type (MIME), url, thumb } or File objects (e.g. from
#   ui-file-upload or an <input type=file>), which are previewed locally
# - `layout`: 'grid' (default) or 'list'; `bind:layout=` works, and
#   `layoutchange` is emitted when the switch changes it
# - `switchable`: a grid/list switch above the files, so people pick; with
#   `persist` (a localStorage key) their choice is remembered
# - `label`: a label above it (skipped inside a ui-field, whose label, hint
#   and error it takes, as the other controls do)
# - `name`: posts the new Files with a plain <form> (a hidden file input);
#   `keptName` also posts the `id` of each saved item still in the list, so
#   the server can tell what was removed
# - `disabled`: read only (no adding or removing); a disabled fieldset's too
# - `columns`: the most tiles per row in the grid; fewer when tiles would get
#   too small (without it, as many as fit)
# - `removable`: a remove button on each; removing emits `remove` with the
#   item and `change` with the new list
# - `addable`: an "Add files" tile that opens the file picker, and files can
#   be dropped onto the attachments; adding emits `add` with the Files and
#   `change`
# - `accept` (MIME types or extensions, e.g. 'image/*,.pdf'), `maxFiles` and
#   `maxFileSize` (bytes) limit what's added, picked or dropped; files that
#   don't fit are listed with the reason, and `reject` is emitted with
#   [{ file, reason }]
# - clicking an image opens it large; other files open their `url`, if any,
#   in a new tab. Files with a `url` get a download button.
#
# In a new-record form, start with no items; in an edit form, with the
# record's saved files as plain objects (with an `id`). Files added are Files,
# so on submit: new = items that are Files, kept = the rest, removed = the
# saved ones no longer there.
tag ui-attachments-base < ui-control
	prop items = []
	prop layout = 'grid'
	prop switchable = false
	prop persist = null
	prop label = null
	prop name = null
	prop keptName = null
	prop disabled = false
	prop removable = false
	prop addable = false
	prop accept = null
	prop addLabel = null
	prop emptyText = null
	prop maxFiles = null
	prop columns = null
	prop maxFileSize = null

	previewing = null
	dragging = no
	addWide = no
	rejected = []
	previewOpen = no
	#urls = new WeakMap
	labelId = "{uid('attachments')}-label"

	# The layout switch; the styled attachments use ui-segmented.
	segmentedTag = 'ui-segmented-base'
	get layouts
		[
			{ value: 'grid', label: uiLocale.messages.attachments.grid, icon: 'lucide:layout-grid' }
			{ value: 'list', label: uiLocale.messages.attachments.list, icon: 'lucide:list' }
		]

	# A layout remembered under `persist` wins over the one given.
	def setup
		return unless persist
		try
			let saved = globalThis.localStorage.getItem(persist)
			layout = saved if saved == 'grid' or saved == 'list'

	def setLayout next
		return unless next and next != layout
		layout = next
		try globalThis.localStorage.setItem(persist, next) if persist
		emit('layoutchange', next)

	# Read only: no adding or removing.
	get locked do disabled or #locked
	get canAdd do addable and !locked
	get canRemove do removable and !locked

	def isFile item do typeof File != 'undefined' and item instanceof File

	# For a plain <form>: the new Files, in a hidden file input. A
	# DataTransfer is the only way to set an input's files.
	def syncPosted
		return unless name and $posted
		let files = (data or []).filter(do isFile($1))
		let key = files.map(do "{$1.name}|{$1.size}|{$1.lastModified}").join('\n')
		return if key == #postedKey
		#postedKey = key
		let transfer = new DataTransfer
		transfer.items.add(file) for file in files
		$posted.files = transfer.files

	get keptIds do (data or []).filter(do !isFile($1)).map(do $1.id).filter(do $1 != null)

	# `bind=` targets `data`, which aliases `items` here.
	get data do items
	set data v do items = v

	get list do (data or []).map do(item) info(item)

	# One shape for both plain objects and Files.
	def info item
		let file = typeof File != 'undefined' and item instanceof File
		let url = file ? localUrl(item) : item.url
		let type = item.type or ''
		let name = item.name or uiLocale.messages.attachments.untitled
		let image = type.startsWith('image/') or /\.(jpe?g|png|gif|webp|avif|svg)$/i.test(name)
		{
			item: item
			name: name
			size: typeof item.size == 'number' ? formatSize(item.size) : (item.size or '')
			url: url
			thumb: item.thumb or (image ? url : null)
			image: image
			ext: (name.match(/\.([a-z0-9]+)$/i)..[1] or '').toUpperCase!
			icon: iconFor(type, name)
		}

	def localUrl file
		#urls.set(file, URL.createObjectURL(file)) unless #urls.has(file)
		#urls.get(file)

	def formatSize bytes do formatBytes(bytes)

	def iconFor type, name
		let n = name.toLowerCase!
		return 'lucide:image' if type.startsWith('image/') or /\.(jpe?g|png|gif|webp|avif|svg)$/.test(n)
		return 'lucide:file-video' if type.startsWith('video/') or /\.(mp4|mov|webm)$/.test(n)
		return 'lucide:file-audio' if type.startsWith('audio/') or /\.(mp3|wav|m4a)$/.test(n)
		return 'lucide:file-spreadsheet' if /\.(xlsx?|csv|numbers)$/.test(n)
		return 'lucide:file-archive' if /\.(zip|rar|7z|gz)$/.test(n)
		return 'lucide:file-text' if /\.(pdf|docx?|txt|md|pages|rtf)$/.test(n)
		'lucide:file'

	def removeItem entry
		data = (data or []).filter(do $1 != entry.item)
		emit('remove', entry.item)
		emit('change', data)

	get count do (data or []).length
	get atMax do !!maxFiles and count >= maxFiles

	# Whether a file matches `accept`: an extension, a type/* or a MIME type.
	def accepts file
		return yes unless accept
		accept.split(',').map(do $1.trim!.toLowerCase!).filter(Boolean).some do(rule)
			if rule.startsWith('.')
				file.name.toLowerCase!.endsWith(rule)
			elif rule.endsWith('/*')
				(file.type or '').startsWith(rule.slice(0, -1))
			else
				file.type == rule

	# Adds what fits (type, size, count); the rest is rejected with a reason.
	def addFiles files
		let ok = []
		let bad = []
		for file in files
			if !accepts(file)
				bad.push({ file: file, reason: uiLocale.messages.attachments.notType })
			elif maxFileSize and file.size > maxFileSize
				bad.push({ file: file, reason: uiLocale.messages.attachments.over(formatSize(maxFileSize)) })
			elif maxFiles and count + ok.length >= maxFiles
				bad.push({ file: file, reason: uiLocale.messages.attachments.limit(maxFiles).replace(/^./, do $1.toLowerCase!) })
			else
				ok.push(file)
		rejected = bad
		emit('reject', bad) if bad.length
		return unless ok.length
		data = [...(data or []), ...ok]
		emit('add', ok)
		emit('change', data)

	def added e
		let files = Array.from(e.target.files or [])
		e.target.value = ''
		addFiles(files) if files.length

	# Dropping files: only while addable, and only for files (not text).
	def hasFiles e do canAdd and Array.from(e.dataTransfer..types or []).includes('Files')

	def dragOver e
		return unless hasFiles(e)
		e.preventDefault!
		e.dataTransfer.dropEffect = atMax ? 'none' : 'copy'
		dragging = yes

	def dragLeave e
		dragging = no unless contains(e.relatedTarget)

	def dropped e
		return unless hasFiles(e)
		e.preventDefault!
		dragging = no
		addFiles(Array.from(e.dataTransfer.files or []))

	# The add tile would start a row on its own when the files fill their rows;
	# then it becomes a slim full-width row instead of a big empty tile. The
	# column count is read off the grid, so it works for auto-fit grids too.
	def mount
		#observer = new ResizeObserver(do checkAddRow!)
		#observer.observe(self)

	def unmount
		#observer..disconnect!

	def rendered
		checkAddRow!
		syncPosted!
		# A fieldset around it renders after it (it's slotted there), so a
		# change to its disabled state shows on the next pass.
		globalThis.queueMicrotask do render! if isConnected and !!closest('fieldset:disabled') != #locked

	def checkAddRow
		return unless $files
		let columns = layout == 'grid' ? globalThis.getComputedStyle($files).gridTemplateColumns.split(' ').filter(Boolean).length : 0
		let wide = !!columns and list.length > 0 and list.length % columns == 0
		return if wide == addWide
		addWide = wide
		render!

	def open entry
		if entry.image and entry.url
			previewing = entry
			previewOpen = yes
		elif entry.url
			globalThis.open(entry.url, '_blank', 'noopener')

	def render
		connectField!
		let labelledBy = #field..labelledBy or (label ? labelId : undefined)
		let invalid = !!#field..invalid

		<self .{layout} .empty=!list.length .add-wide=addWide .dragging=dragging .fixed=!!columns .invalid=invalid .disabled=locked style=(columns ? "--columns: {columns}" : undefined)
			role='group' zag={ 'aria-labelledby': labelledBy, 'aria-describedby': #field..describedBy ?? undefined, 'aria-invalid': invalid ? 'true' : undefined }
			@dragenter=dragOver @dragover=dragOver @dragleave=dragLeave @drop=dropped>
			if (label and !#field..label) or switchable
				<div.header>
					if label and !#field..label
						<span.label id=labelId> label
					if switchable
						<{segmentedTag}.switch size='sm' iconOnly items=layouts value=layout aria-label=uiLocale.messages.attachments.layout @change.stop=setLayout(e.detail)>
			if !list.length and !canAdd and emptyText
				<p.empty> emptyText
			<ul$files.files>
				for entry in list
					<li.file>
						<button.open type='button' aria-label=uiLocale.messages.attachments.open(entry.name) @click=open(entry)>
							<span.thumb .has-image=!!entry.thumb>
								if entry.thumb
									<img src=entry.thumb alt='' loading='lazy'>
								else
									<iconify-icon.icon icon=entry.icon aria-hidden='true'>
									<span.ext> entry.ext if entry.ext
							<span.meta>
								<span.name> entry.name
								<span.size> entry.size if entry.size
						<span.actions>
							if entry.url
								<a.action href=entry.url download=entry.name aria-label=uiLocale.messages.attachments.downloadFile(entry.name)> <ui-icon path=icons.download size=14>
							if canRemove
								<button.action type='button' aria-label=uiLocale.messages.common.remove(entry.name) @click=removeItem(entry)> <ui-icon path=icons.x size=14>
				if canAdd and !atMax
					<li.file.add>
						<label.add-tile>
							<input.add-input type='file' multiple=(maxFiles != 1) accept=accept @change.stop=added>
							<span.add-icon> <ui-icon path=icons.plus size=18>
							<span.add-text>
								<span.add-label> addLabel ?? uiLocale.messages.attachments.add
								<span.limit> uiLocale.messages.attachments.orDrop unless list.length
								<span.limit> uiLocale.messages.attachments.count(count, maxFiles) if maxFiles and list.length
			if rejected.length
				<ul.rejected role='alert'> for item in rejected
					<li> uiLocale.messages.attachments.notAdded(item.file.name, item.reason)
			if dragging
				<div.drop-hint aria-hidden='true'>
					<ui-icon path=icons.upload size=20>
					<span> atMax ? uiLocale.messages.attachments.limit(maxFiles) : uiLocale.messages.attachments.dropToAdd

			<ui-dialog size='lg' heading=(previewing..name) bind=previewOpen>
				<img.preview src=(previewing..url) alt=(previewing..name or '')> if previewing
				<div slot='footer'>
					<a.download-link href=(previewing..url) download=(previewing..name)> uiLocale.messages.attachments.download if previewing
			# Last, so a ui-field's label points at the add input, not these.
			if name
				<input$posted type='file' name=name multiple hidden aria-hidden='true' tabIndex=-1>
			if keptName
				for kept in keptIds
					<input type='hidden' name=keptName value=String(kept)>
