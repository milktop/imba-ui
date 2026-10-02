import source from './copy-button.imba?raw'

tag page-copy-button
	link = 'https://tutor.app/book/ada-lovelace'
	code = 'TUT-4821-XQ'
	copies = 0

	<self>
		<demo-page source=source heading='Copy button' intro='ui-copy-button copies a value to the clipboard and shows a tick for a moment.'>
			<demo-section heading='Basic'>
				<div.row>
					<code> code
					<ui-copy-button value=code @copy=(copies++)>
				<div.out>
					<json-print data={ copies }>

			<demo-section heading='Icon only'>
				<div.row>
					<span> "Booking code {code}"
					<ui-copy-button value=code iconOnly label='Copy booking code'>

			<demo-section heading='In an input'>
				<ui-fields>
					<ui-field span=8 label='Share link' hint='Anyone with the link can book'>
						<ui-input value=link attrs={ readonly: true }>
							<ui-copy-button slot='suffix' value=link>
				<div.out>
					<p.note> "The copy button sits in ui-input's suffix slot."
