import { parsePhoneNumberFromString, AsYouType, getCountries, getCountryCallingCode } from 'libphonenumber-js/max'
import { uid } from '../zag.imba'
import '../control.imba'
import 'iconify-icon'
import { uiLocale } from '../locale.imba'

const types = { MOBILE: 'mobile', FIXED_LINE: 'landline' }

def flagOf country
	country ? String.fromCodePoint(...[...country].map(do 127397 + $1.charCodeAt(0))) : '🌐'

def regionOf locale
	try
		new Intl.Locale(locale).maximize!.region
	catch
		null

# Headless phone number input: the number, and a flag that is also a country
# picker.
#
# - `country`: the country of numbers typed without a "+" (default: the
#   locale's region, e.g. FR for 'fr-FR')
# - `countries`: countries listed first in the picker, e.g. ['FR', 'BE', 'GB']
# - `showType`: a mobile or landline icon after a valid number (its word as
#   a tooltip and label)
# - `name`, `placeholder`, `autocomplete` ('tel'), `required`, `disabled`: as
#   on an input
#
# The value is the number in E.164 ('+33612345678') once it's valid, else the
# text as typed, so a form can still reject it. It shows in national format
# when it's in `country`, international otherwise. The flag follows the number
# ("+44…" shows the UK's); picking one reads a number typed without "+" as
# that country's (Ireland, then 087 677 8877). `change` emits on commit.
#
#   <ui-phone-input country='FR' showType bind=phone>
tag ui-phone-input-base < ui-control
	prop label = null
	prop value = null
	prop country = null
	prop countries = []
	prop showType = false
	prop name = null
	prop placeholder = null
	get autocomplete do #autocomplete ?? 'tel'
	set autocomplete v do #autocomplete = v
	prop required = false
	prop disabled = false
	prop locale = null

	# What the input shows. Not a field: field defaults land after the first
	# render, which would wipe the number shown from the value.
	get entry do #entry ?? ''
	set entry v do #entry = v
	get inputId do #inputId ||= uid('phone')

	get home do (country or regionOf(locale or uiLocale.locale) or 'FR').toUpperCase!
	# Numbers typed without "+" are read as this country's.
	get region do #picked or home

	def parse text
		parsePhoneNumberFromString(text or '', region)

	get number
		let parsed = parse(entry)
		parsed..isValid! ? parsed : null

	# The flag: the number's country, or the one it's being read as.
	get flagCountry
		return number.country if number
		return region unless entry.trim!.startsWith('+')
		let typing = new AsYouType(region)
		typing.input(entry)
		typing.getCountry!

	get type do number ? (types[number.getType!] ?? null) : null

	get countryItems
		let names = new Intl.DisplayNames([locale or uiLocale.locale], type: 'region')
		let item = do(code) { code, label: "{names.of(code)} +{getCountryCallingCode(code)}" }
		let all = getCountries!.map(item).sort(do $1.label.localeCompare($2.label))
		let first = (countries or []).map(do $1.toUpperCase!).filter(do getCountries!.includes($1)).map(item)
		{ first, all }

	def display value
		let parsed = parsePhoneNumberFromString(value or '', home)
		return value ?? '' unless parsed..isValid!
		parsed.country == home ? parsed.formatNational! : parsed.formatInternational!

	def valueOf text
		number ? number.number : text.trim!

	def typed
		data = #shown = valueOf(entry)

	def settle
		entry = display(data) if number
		#shown = data
		emit('change', data)

	def pick e
		let parsed = parse(entry)
		#picked = e.target.value
		entry = parsed.nationalNumber if parsed and entry.trim!.startsWith('+')
		typed!
		settle!
		$input.focus!

	# Options exist only after rendering, so the selection is set then.
	def rendered
		$picker.value = flagCountry or ''

	def render
		connectField!
		if data !== #shown
			entry = display(data)
			#shown = data
			#picked = null

		let locked = disabled or #locked
		let { first, all } = countryItems
		let messages = uiLocale.messages.phoneInput
		let input = describe({ 'aria-invalid': #field..invalid ? 'true' : undefined })

		<self data-scope='phone-input' data-invalid=(#field..invalid or undefined) data-disabled=(locked or undefined)>
			if label and !#field..label
				<label.label htmlFor=inputId> label
			<div.control>
				<span.country>
					<span.flag aria-hidden='true'> flagOf(flagCountry)
					<select$picker.picker aria-label=messages.country disabled=locked @change.stop=pick>
						<option value='' disabled hidden> '🌐'
						for item in first
							<option value=item.code> "{flagOf(item.code)} {item.label}"
						if first.length
							<option disabled> '──────────'
						for item in all
							<option value=item.code> "{flagOf(item.code)} {item.label}"
				<input$input.input zag=input id=inputId type='tel' name=(name or undefined) placeholder=(placeholder or '') autocomplete=autocomplete required=required disabled=locked bind=entry @input=typed @change.stop=settle>
				if showType and type
					<span.type title=messages[type] aria-label=messages[type]>
						<iconify-icon icon=(type == 'mobile' ? 'lucide:smartphone' : 'lucide:phone') aria-hidden='true'>
