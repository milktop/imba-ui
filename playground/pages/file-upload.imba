import source from './file-upload.imba?raw'

tag page-file-upload
	avatar = null
	worksheets = []

	def describe list do [].concat(list ?? []).map(do { name: $1.name, size: $1.size, type: $1.type })

	<self>
		<demo-page source=source heading='File upload' intro='ui-file-upload takes files from a dropzone or the file picker, shows them with previews, and lists rejected ones with the reason.'>
			<demo-section heading='One image'>
				<ui-fields>
					<ui-field span=6 label='Profile photo'>
						<ui-file-upload accept='image/*' maxFileSize=(2 * 1024 * 1024) hint='PNG or JPG up to 2 MB' bind=avatar>
				<div.out>
					<json-print data={ avatar: describe(avatar)[0] or null }>
					<div.set>
						<button @click=(avatar = null)> "Clear"

			<demo-section heading='Several files'>
				<ui-fields>
					<ui-field span=6 label='Worksheets'>
						<ui-file-upload accept='.pdf,.docx,.png,.jpg' maxFiles=5 hint='Up to 5 files: PDF, Word or images' bind=worksheets>
				<div.out>
					<json-print data={ worksheets: describe(worksheets) }>
