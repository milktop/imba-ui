import source from './textarea.imba?raw'

tag page-textarea
	notes = ''
	bio = ''
	message = ''

	<self>
		<demo-page source=source heading='Textarea' intro='ui-textarea grows with its content from `rows` up to `maxRows`, then scrolls. A ui-field with type="textarea" renders one.'>
			<demo-section heading='Auto-growing'>
				<ui-fields>
					<ui-field span=6 label='Notes' type='textarea' rows=2 maxRows=6 hint='Grows up to 6 lines' bind=notes>
				<div.out>
					<json-print data={ notes }>
					<div.set>
						<button @click=(notes = 'Line 1\nLine 2\nLine 3\nLine 4\nLine 5\nLine 6\nLine 7\nLine 8')> "Fill 8 lines"
						<button @click=(notes = '')> "Clear"

			<demo-section heading='Fixed height'>
				<ui-fields>
					<ui-field span=6 label='Bio' hint='Resizable by dragging'>
						<ui-textarea rows=4 autogrow=false bind=bio>
				<div.out>
					<json-print data={ bio }>

			<demo-section heading='With a limit'>
				<ui-fields>
					<ui-field span=6 label='Message' hint="{message.length} / 200">
						<ui-textarea rows=3 attrs={ maxlength: 200 } bind=message>
