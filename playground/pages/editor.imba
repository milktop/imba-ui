import source from './editor.imba?raw'

# Stands in for a real upload: waits a moment, then returns a local URL.
def fakeUpload file
	await new Promise(do(done) setTimeout(done, 600))
	URL.createObjectURL(file)

tag page-editor
	notes = '<h2>Fractions and decimals</h2><p>Recap <strong>equivalent fractions</strong>, then convert between fractions and decimals.</p><ul><li><p>Halves, quarters and tenths</p></li><li><p>Ordering a mixed list</p></li></ul>'
	message = ''
	feedback = ''
	homework = '<p>Label the parts of this diagram:</p><img src="https://picsum.photos/seed/editor-diagram/800/400" alt="Diagram">'

	<self>
		<demo-page source=source heading='Editor' intro='ui-editor is a rich text editor on TipTap (ProseMirror). Its value is HTML, bindable like the other controls; the toolbar is configurable and the usual shortcuts work (⌘B, ⌘I, ⌘U…).'>
			<demo-section heading='Notes'>
				<ui-editor bind=notes placeholder='Lesson notes…'>
				<div.out>
					<json-print data={ notes }>

			<demo-section heading='In a field'>
				<ui-fields>
					<ui-field label='Message to parents' hint='They’ll get this by email.' error=(message.length > 0 and message.length < 20 ? 'A little more, please' : null)>
						<ui-editor bind=message placeholder='Write a message…' minHeight='6rem'>

			<demo-section heading='Fewer tools, with a limit'>
				<ui-editor bind=feedback tools=['bold', 'italic', '|', 'bulletList', '|', 'link'] maxLength=280 minHeight='5rem' placeholder='Short feedback for the student…'>

			<demo-section heading='With images'>
				<p.note> "Give it `uploadImage` (an async function: File in, URL out) and images can be dropped, pasted or picked with the image button. Without it, dropped files are ignored instead of opening in the tab."
				<ui-editor bind=homework uploadImage=fakeUpload>

			<demo-section heading='Read only'>
				<ui-editor value=notes disabled>
