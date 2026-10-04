import source from './attachments.imba?raw'

# A placeholder image: a gradient with a shape, as an SVG data URL.
def picture from, to, shape
	let svg = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 400 300'><defs><linearGradient id='g' x1='0' y1='0' x2='1' y2='1'><stop offset='0' stop-color='{from}'/><stop offset='1' stop-color='{to}'/></linearGradient></defs><rect width='400' height='300' fill='url(#g)'/>{shape}</svg>"
	# Data URLs can't contain a bare #.
	"data:image/svg+xml;utf8,{svg.replaceAll('#', '%23')}"

const whiteboard = picture('#c7d2fe', '#a5b4fc', "<circle cx='140' cy='150' r='60' fill='white' fill-opacity='0.6'/><rect x='220' y='90' width='110' height='120' rx='12' fill='white' fill-opacity='0.5'/>")
const worksheet = picture('#bbf7d0', '#5eead4', "<rect x='120' y='60' width='160' height='190' rx='8' fill='white' fill-opacity='0.75'/>")
const graph = picture('#fde68a', '#fdba74', "<polyline points='60,230 140,170 210,190 290,100 350,80' fill='none' stroke='white' stroke-width='12' stroke-linecap='round'/>")

tag page-attachments
	files = [
		{ name: 'Whiteboard.jpg', size: 1153024, type: 'image/jpeg', url: whiteboard }
		{ name: 'Worksheet scan.png', size: 624000, type: 'image/png', url: worksheet }
		{ name: 'Progress graph.png', size: 210000, type: 'image/png', url: graph }
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

			<demo-section heading='Read only'>
				<ui-attachments items=files.slice(0, 3)>
