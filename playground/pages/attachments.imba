import source from './attachments.imba?raw'

# Photos from picsum.photos (Unsplash images, fixed by seed): a small
# thumbnail for the tile and a larger one for the preview.
def photo seed
	{ thumb: "https://picsum.photos/seed/{seed}/400/300", url: "https://picsum.photos/seed/{seed}/1200/900" }

tag page-attachments
	files = [
		{ name: 'Field trip.jpg', size: 1153024, type: 'image/jpeg', ...photo('tutor-trip') }
		{ name: 'Study notes.jpg', size: 624000, type: 'image/jpeg', ...photo('tutor-notes') }
		{ name: 'Library.jpg', size: 810000, type: 'image/jpeg', ...photo('tutor-library') }
		{ name: 'Lesson slides.pdf', size: 2516582, type: 'application/pdf' }
		{ name: 'Mock results.xlsx', size: 48000 }
		{ name: 'Revision notes.docx', size: 132000 }
	]
	docs = files.slice(3)
	photos = []
	rejects = []
	removed = null

	<self>
		<demo-page source=source heading='Attachments' intro='ui-attachments shows the files added to a page or form: image thumbnails (click one to see it large) and file icons, with download and remove. It takes plain objects or File objects, e.g. from ui-file-upload.'>
			<demo-section heading='Grid'>
				<ui-attachments bind=files removable addable @remove=(removed = e.detail.name)>
				<div.out>
					<json-print data={ count: files.length, removed }>
					<p.note> "Hover a tile for download and remove; the last tile adds files from your computer, or drop them anywhere on the attachments (previewed locally)."

			<demo-section heading='Limits and dropping'>
				<ui-attachments bind=photos removable addable accept='image/*,.pdf' maxFiles=3 maxFileSize=(2 * 1024 * 1024) addLabel='Add photos or PDFs' @reject=(rejects = e.detail.map(do $1.file.name))>
				<div.out>
					<json-print data={ photos: photos.map(do $1.name), rejects }>
					<p.note> "Drag files onto it, or use the tile: images or PDFs, up to 2 MB each, at most 3. Files that don’t fit are listed with the reason."

			<demo-section heading='List'>
				<ui-attachments layout='list' items=docs removable addable addLabel='Attach a file'>

			<demo-section heading='Read only, three per row'>
				<ui-attachments columns=3 items=[
					{ name: 'Cover 1.jpg', size: 920000, type: 'image/jpeg', ...photo('cover-one') }
					{ name: 'Cover 2.jpg', size: 870000, type: 'image/jpeg', ...photo('cover-two') }
					{ name: 'Cover 3.jpg', size: 1010000, type: 'image/jpeg', ...photo('cover-three') }
				]>
				<div.out>
					<p.note> "`columns` sets the most per row (fewer when tiles would get too small). Images can have a small `thumb` for the tile and a full-size `url` for the preview."
