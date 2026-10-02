import { subjects } from '../demo.imba'
import source from './select.imba?raw'

tag page-select
	subject = 1
	examBoards = []
	size = 'M'
	boards = ['AQA', 'Edexcel', 'OCR', 'WJEC']

	<self>
		<demo-page source=source heading='Select' intro='ui-select opens a list of options from a button, with typeahead and keyboard navigation. It emits the items’ own values.'>
			<demo-section heading='Single'>
				<ui-fields>
					<ui-field span=6 label='Subject' hint='Latin is disabled'>
						<ui-select items=subjects bind=subject>
				<div.out>
					<json-print data={ subject }>
					<div.set>
						<button @click=(subject = 2)> "English"
						<button @click=(subject = null)> "Clear"

			<demo-section heading='Multiple'>
				<ui-fields>
					<ui-field span=6 label='Exam boards'>
						<ui-select items=boards multiple clearable placeholder='Choose boards' bind:value=examBoards>
				<div.out>
					<json-print data={ examBoards }>
					<div.set>
						<button @click=(examBoards = ['AQA', 'OCR'])> "AQA + OCR"

			<demo-section heading='Plain strings, no field'>
				<ui-select label='T-shirt size' items=['S', 'M', 'L', 'XL'] bind=size>
				<div.out>
					<json-print data={ size }>
