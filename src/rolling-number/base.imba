# Headless rolling number: its digits roll to their new value when it
# changes, e.g. a live count on a dashboard. Still while the system asks for
# reduced motion; assistive tech reads the whole number, not the digits.
#
#   <ui-rolling-number value=appointments.length>
#   <ui-rolling-number value=revenue format={ style: 'currency', currency: 'GBP', maximumFractionDigits: 0 }>
#
# - `value`: the number
# - `format`: Intl.NumberFormat's options (grouping by default)
# - `duration`: how long a roll takes, in ms (600)
# - `locale`: the browser's by default
const digits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

tag ui-rolling-number-base
	prop value = 0
	prop format = null
	prop duration = 600
	prop locale = null

	get text
		let n = Number(value)
		return String(value ?? '') unless Number.isFinite(n)
		new Intl.NumberFormat(locale or undefined, format or {}).format(n)

	def render
		let text = text
		let chars = Array.from(text)
		style.setProperty('--duration', "{duration}ms")
		<self role='img' aria-label=text data-ui-rolling>
			# Keyed from the right, so the ones stay the ones as the number grows.
			for char, i in chars
				if /\d/.test(char)
					<span.digit key="d{chars.length - i}" aria-hidden='true'>
						<span.strip style="--digit: {char}">
							for d in digits
								<span> d
						<span.sizer> "0"
				else
					<span.char key="c{chars.length - i}" aria-hidden='true'> char
