import { icons } from '../icons.imba'
import '../dialog/base.imba'

# Headless attachments: the files added to a page or form, as a grid of
# tiles (image thumbnails, or an icon and the extension) or a compact list.
#
#   <ui-attachments bind=files removable addable>
#
# - items (`bind=`, `bind:items=` or `items`): plain objects { name, size
#   (bytes, or text), type (MIME), url, thumb } or File objects (e.g. from
#   ui-file-upload or an <input type=file>), which are previewed locally
# - `layout`: 'grid' (default) or 'list'
# - `removable`: a remove button on each; removing emits `remove` with the
#   item and `change` with the new list
# - `addable`: an "Add files" tile that opens the file picker (`accept`
#   limits it); adding emits `add` with the Files and `change`
# - clicking an image opens it large; other files open their `url`, if any,
#   in a new tab. Files with a `url` get a download button.
tag ui-attachments-base
	prop items = []
	prop layout = 'grid'
	prop removable = false
	prop addable = false
	prop accept = null
	prop addLabel = 'Add files'
	prop emptyText = null

	previewing = null
	previewOpen = no
	#urls = new WeakMap

	# `bind=` targets `data`, which aliases `items` here.
	get data do items
	set data v do items = v

	get list do (data or []).map do(item) info(item)

	# One shape for both plain objects and Files.
	def info item
		let file = typeof File != 'undefined' and item instanceof File
		let url = file ? localUrl(item) : item.url
		let type = item.type or ''
		let name = item.name or 'Untitled'
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

	def formatSize bytes
		return "{bytes} B" if bytes < 1024
		return "{Math.round(bytes / 1024)} KB" if bytes < 1024 * 1024
		"{(bytes / 1024 / 1024).toFixed(1)} MB"

	def iconFor type, name
		let n = name.toLowerCase!
		return 'lucide:image' if type.startsWith('image/') or /\.(jpe?g|png|gif|webp|avif|svg)$/.test(n)
		return 'lucide:file-video' if type.startsWith('video/') or /\.(mp4|mov|webm)$/.test(n)
		return 'lucide:file-audio' if type.startsWith('audio/') or /\.(mp3|wav|m4a)$/.test(n)
		return 'lucide:file-spreadsheet' if /\.(xlsx?|csv|numbers)$/.test(n)
		return 'lucide:file-archive' if /\.(zip|rar|7z|gz)$/.test(n)
		return 'lucide:file-text' if /\.(pdf|docx?|txt|md|pages|rtf)$/.test(n)
		'lucide:file'

	def remove entry
		data = (data or []).filter(do $1 != entry.item)
		emit('remove', entry.item)
		emit('change', data)

	def added e
		let files = Array.from(e.target.files or [])
		e.target.value = ''
		return unless files.length
		data = [...(data or []), ...files]
		emit('add', files)
		emit('change', data)

	def open entry
		if entry.image and entry.url
			previewing = entry
			previewOpen = yes
		elif entry.url
			globalThis.open(entry.url, '_blank', 'noopener')

	<self .{layout}>
		if !list.length and !addable and emptyText
			<p.empty> emptyText
		<ul.files>
			for entry in list
				<li.file>
					<button.open type='button' aria-label="Open {entry.name}" @click=open(entry)>
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
							<a.action href=entry.url download=entry.name aria-label="Download {entry.name}"> <ui-icon path=icons.download size=14>
						if removable
							<button.action type='button' aria-label="Remove {entry.name}" @click=remove(entry)> <ui-icon path=icons.x size=14>
			if addable
				<li.file.add>
					<label.add-tile>
						<input.add-input type='file' multiple accept=accept @change.stop=added>
						<ui-icon path=icons.plus size=18>
						<span> addLabel
		<ui-dialog size='lg' heading=(previewing..name) bind=previewOpen>
			<img.preview src=(previewing..url) alt=(previewing..name or '')> if previewing
			<div slot='footer'>
				<a.download-link href=(previewing..url) download=(previewing..name)> "Download" if previewing
