import source from './pin-input.imba?raw'

tag page-pin-input
	code = ''
	booking = ''
	verified = no

	<self>
		<demo-page source=source heading='Pin input' intro='ui-pin-input has one box per character. Typing moves on, Backspace moves back, and pasting fills every box.'>
			<demo-section heading='Verification code'>
				<ui-fields>
					<ui-field span=6 label='Code' hint=(verified ? 'Verified' : 'We sent 6 digits to your phone')>
						<ui-pin-input length=6 otp bind=code @change=(verified = no) @complete=(verified = yes)>
				<div.out>
					<json-print data={ code, verified }>
					<div.set>
						<button @click=(code = '482913')> "Fill 482913"
						<button @click=(code = '')> "Clear"

			<demo-section heading='Letters and digits, masked'>
				<ui-fields>
					<ui-field span=6 label='Booking reference'>
						<ui-pin-input length=5 type='alphanumeric' mask bind=booking>
				<div.out>
					<json-print data={ booking }>
