import * as zagFile from '@zag-js/file-upload'
import { Machine, uid, defined } from '../zag.imba'
import { fieldIds } from '../control.imba'
import { icons } from '../icons.imba'

# Headless file upload: a dropzone (click, Enter or drop files on it) and the
# list of chosen files, with image previews and a remove button each.
#
# - `accept`: MIME types or extensions, e.g. 'image/*' or '.pdf,.docx'
# - `maxFiles`: how many (default 1); `maxFileSize` in bytes
# - `hint`: text under the dropzone's prompt, e.g. 'PDF up to 5 MB'
#
# The value is a File (or null) with maxFiles 1, otherwise an array of Files;
# `change` is emitted with it. Rejected files are listed with the reason.
tag ui-file-upload-base < ui-control
	prop label = null
	prop value = null
	prop accept = null
	prop maxFiles = 1
	prop maxFileSize = null
	prop hint = null
	prop name = null
	prop disabled = false

	zagId = uid('file-upload')
	#previews = new WeakMap

	get single do maxFiles == 1
	def files value do [].concat(value ?? [])

	# Files have no stable identity as plain values, so they're compared by
	# what makes them the same file.
	def fileKey list do list.map(do "{$1.name}:{$1.size}:{$1.lastModified}").join('|')

	def previewFor file
		return null unless file.type..startsWith('image/')
		#previews.set(file, URL.createObjectURL(file)) unless #previews.has(file)
		#previews.get(file)

	def reason code
		{
			FILE_INVALID_TYPE: 'Not an accepted file type'
			FILE_TOO_LARGE: 'Too large'
			FILE_TOO_SMALL: 'Too small'
			TOO_MANY_FILES: 'Too many files'
			FILE_EXISTS: 'Already added'
		}[code] or code

	def setup
		machine = new Machine self, zagFile.machine, do defined({
			id: zagId
			ids: fieldIds(self)
			accept: accept
			maxFiles: maxFiles
			maxFileSize: maxFileSize
			name: name
			disabled: disabled or #locked
			invalid: !!#field..invalid
			defaultAcceptedFiles: files(data)
			onFileAccept: do(details)
				let list = details.files
				# Files pushed in from outside come back the same: no `change` for
				# those, as with native inputs.
				let changed = fileKey(list) != #key
				#key = fileKey(list)
				data = single ? (list[0] ?? null) : list
				emit('change', data) if changed
		})
		#key = fileKey(files(data))

	def mount do machine.start!
	def unmount do machine.stop!

	def render
		connectField!

		# Outside changes (e.g. clearing the model) go into Zag.
		let key = fileKey(files(data))
		if key != #key
			#key = key
			globalThis.queueMicrotask do machine.connect(zagFile).setFiles(files(data))

		let api = machine.connect(zagFile)

		<self zag=api.getRootProps!>
			if label and !#field..label
				<label.label zag=api.getLabelProps!> label
			<div.dropzone zag=describe(api.getDropzoneProps!)>
				<ui-icon.icon path=icons.upload size=20>
				<div.prompt>
					"Drop {single ? 'a file' : 'files'} here or "
					<button.browse zag=api.getTriggerProps!> "browse"
				<div.hint> hint if hint
			<input zag=api.getHiddenInputProps! @change.stop>
			if api.acceptedFiles.length
				<ul.files zag=api.getItemGroupProps(type: 'accepted')>
					for file in api.acceptedFiles
						<li.file zag=api.getItemProps(file: file, type: 'accepted')>
							if let url = previewFor(file)
								<img.preview src=url alt=''>
							else
								<span.preview.generic> <ui-icon path=icons.file size=16>
							<span.name zag=api.getItemNameProps(file: file, type: 'accepted')> file.name
							<span.size zag=api.getItemSizeTextProps(file: file, type: 'accepted')> api.getFileSize(file)
							<button.remove zag=api.getItemDeleteTriggerProps(file: file, type: 'accepted')> <ui-icon path=icons.x size=14>
			if api.rejectedFiles.length
				<ul.files.rejected zag=api.getItemGroupProps(type: 'rejected')>
					for item in api.rejectedFiles
						<li.file zag=api.getItemProps(file: item.file, type: 'rejected')>
							<span.preview.generic> <ui-icon path=icons.error size=16>
							<span.name zag=api.getItemNameProps(file: item.file, type: 'rejected')> item.file.name
							<span.reason> item.errors.map(do reason($1)).join(', ')
							<button.remove zag=api.getItemDeleteTriggerProps(file: item.file, type: 'rejected')> <ui-icon path=icons.x size=14>
