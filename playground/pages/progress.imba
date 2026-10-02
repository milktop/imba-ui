import source from './progress.imba?raw'

tag page-progress
	value = 40
	uploading = no

	def upload
		uploading = yes
		value = 0
		while value < 100
			await new Promise(do setTimeout($1, 120))
			value = Math.min(100, value + 7)
			imba.commit!
		uploading = no
		imba.commit!

	<self>
		<demo-page source=source heading='Progress' intro='ui-progress shows how far along something is, as a bar or a circle. With no value it is indeterminate.'>
			<demo-section heading='Bar'>
				<ui-progress label='Course completion' showValue value=value>
				<div.out>
					<json-print data={ value }>
					<div.set>
						<button @click=(value = Math.max(0, value - 10))> "−10"
						<button @click=(value = Math.min(100, value + 10))> "+10"
						<button @click=upload> uploading ? "Uploading…" : "Simulate upload"

			<demo-section heading='Circle'>
				<div.row>
					<ui-progress variant='circle' showValue value=value>
					<ui-progress variant='circle' size=64 thickness=6 showValue value=value>
				<div.out>
					<p.note> "Follows the same value as the bar above."

			<demo-section heading='Indeterminate'>
				<ui-progress label='Loading lessons…'>
				<div.row>
					<ui-progress variant='circle' size=32 thickness=4>

			<demo-section heading='Steps'>
				<ui-progress label='Booking' showValue min=0 max=4 value=3 formatOptions={ style: 'decimal' }>
				<div.out>
					<p.note> "min/max can be anything; here 3 of 4 steps."
