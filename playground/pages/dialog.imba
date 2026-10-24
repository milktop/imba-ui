import source from './dialog.imba?raw'

tag page-dialog
	editOpen = no
	confirmOpen = no
	noticeOpen = no
	documentOpen = no
	student = { name: 'Ada Lovelace', email: 'ada@example.com', year: 11 }
	draftStudent = {}
	deleted = no

	css .document fl:1 w:100% bd:none

	def startEditStudent do draftStudent = Object.assign({}, student)
	def saveStudent
		student = draftStudent
		editOpen = no
	def confirmDelete
		deleted = yes
		confirmOpen = no

	<self>
		<demo-page source=source heading='Dialog' intro='ui-dialog is a modal rendered at the end of <body>: focus is trapped inside, the page behind doesn’t scroll, and Escape closes it.'>
			<demo-section heading='Form dialog'>
				<ui-dialog heading='Edit student' description='Changes are saved to their profile.' bind=editOpen @openchange=(startEditStudent! if e.detail)>
					<ui-button slot='trigger' icon='lucide:pencil'> "Edit student"
					<ui-fields>
						<ui-field label='Name' bind=draftStudent.name>
						<ui-field span=8 label='Email' type='email' bind=draftStudent.email>
						<ui-field span=4 label='Year' type='number' min=7 max=13 bind=draftStudent.year>
					<div slot='footer'>
						<ui-button @click=(editOpen = no)> "Cancel"
						<ui-button variant='primary' @click=saveStudent> "Save"
				<div.out>
					<json-print data={ student }>

			<demo-section heading='Confirmation'>

				<ui-dialog alert size='sm' closable=false heading='Delete lesson?' description='Thursday’s lesson with Ada will be cancelled and both of you notified.' bind=confirmOpen>
					<ui-button slot='trigger' variant='danger' icon='lucide:trash-2'> "Delete lesson"
					<div slot='footer'>
						<ui-button @click=(confirmOpen = no)> "Keep it"
						<ui-button variant='danger' @click=confirmDelete> "Delete"

				<div.out>
					<json-print data={ deleted }>
					<div.set>
						<button @click=(deleted = no)> "Undo delete"
					<p.note> "`alert` makes it an alertdialog: clicking the backdrop doesn’t close it."

			<demo-section heading='Full size'>
				<ui-dialog size='full' heading='Facture vil-28923' bind=documentOpen>
					<iframe.document title='Facture vil-28923' srcdoc="<body style='font: 14px system-ui; padding: 2rem'><h1>Invoice</h1><p>A PDF would fill this frame.</p></body>">
					<div slot='footer'>
						<ui-button icon='lucide:download'> "Download"
						<ui-button variant='primary' @click=(documentOpen = no)> "Close"
				<div.out>
					<div.set>
						<button @click=(documentOpen = yes)> "Open document"
					<p.note> "`size='full'` takes most of the screen and lets its body fill the height, unpadded: give the content `flex: 1`."

			<demo-section heading='Opened from code'>
				<ui-dialog heading='Lesson booked' bind=noticeOpen>
					"Maths with Ada, Thursday 8 October at 16:00. A confirmation is on its way."
					<div slot='footer'>
						<ui-button variant='primary' @click=(noticeOpen = no)> "Done"
				<div.out>
					<div.set>
						<button @click=(noticeOpen = yes)> "Open dialog"
					<p.note> "No trigger: binding `open` is enough."
