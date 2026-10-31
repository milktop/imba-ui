import { parsePhoneNumberFromString, validatePhoneNumberLength, AsYouType, getCountries, getCountryCallingCode } from 'libphonenumber-js/max'
import { uid } from '../zag.imba'
import '../control.imba'
import '../popover/base.imba'
import 'iconify-icon'
import { uiLocale } from '../locale.imba'

const types = { MOBILE: 'mobile', FIXED_LINE: 'landline' }
const reasons = { TOO_SHORT: 'tooShort', TOO_LONG: 'tooLong' }

def flagOf country
	country ? String.fromCodePoint(...[...country].map(do 127397 + $1.charCodeAt(0))) : '🌐'

def regionOf locale
	try
		new Intl.Locale(locale).maximize!.region
	catch
		null

def fold text
	text.normalize('NFD').replace(/[̀-ͯ]/g, '').toLowerCase!

# Headless phone number input: the number, and a flag that is also a country
# picker.
#
# - `country`: the country of numbers typed without a "+" (default: the
#   locale's region, e.g. FR for 'fr-FR')
# - `countries`: countries listed first in the picker, e.g. ['FR', 'BE', 'GB']
# - `showType`: a mobile or landline icon after a valid number (its word as
#   a tooltip and label)
# - `picker`: 'search' (a list searched by name, code or dialling code) or
#   'native' (the browser's own select); by default native on touch screens
# - `name`, `placeholder`, `autocomplete` ('tel'), `required`, `disabled`: as
#   on an input
#
# The value is the number in E.164 ('+33612345678') once it's valid, else the
# text as typed, so a form can still reject it. It shows in national format
# when it's in `country`, international otherwise. The flag follows the number
# ("+44…" shows the UK's); picking one reads a number typed without "+" as
# that country's (Ireland, then 087 677 8877); Backspace in the empty input
# goes back to `country`. `change` emits on commit.
#
# A number left invalid says why once the input loses focus (too short, too
# long, not a number), in its ui-field when it has one; an `error` given to
# the field wins.
#
#   <ui-phone-input country='FR' showType bind=phone>
tag ui-phone-input-base < ui-control
	prop label = null
	prop value = null
	prop country = null
	prop countries = []
	prop showType = false
	prop picker = null
	prop name = null
	prop placeholder = null
	get autocomplete do #autocomplete ?? 'tel'
	set autocomplete v do #autocomplete = v
	prop required = false
	prop disabled = false
	prop locale = null

	popoverTag = 'ui-popover-base'

	# What the inputs show. Not fields: field defaults land after the first
	# render, which would wipe the number shown from the value.
	get entry do #entry ?? ''
	set entry v do #entry = v
	get query do #query ?? ''
	set query v do #query = v
	get inputId do #inputId ||= uid('phone')
	get listId do #listId ||= uid('phone-countries')

	get searching do picker ? picker == 'search' : !globalThis.matchMedia('(pointer: coarse)').matches

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

	# Why the number isn't valid, once the input has lost focus.
	get problem
		return null unless #touched and entry.trim! and !number
		uiLocale.messages.phoneInput[reasons[validatePhoneNumberLength(entry, region)] ?? 'invalid']

	get countryItems
		let names = new Intl.DisplayNames([locale or uiLocale.locale], type: 'region')
		let item = do(code)
			let name = names.of(code)
			let dial = getCountryCallingCode(code)
			{ code, name, dial, label: "{name} +{dial}", words: fold(name) }
		let all = getCountries!.map(item).sort(do $1.name.localeCompare($2.name))
		let first = (countries or []).map(do $1.toUpperCase!).filter(do getCountries!.includes($1)).map(item)
		{ first, all }

	# The list, `countries` first. A search matches a name's words (accents
	# ignored), the code, or the dialling code; names starting with it next.
	get matches
		let { first, all } = countryItems
		let text = fold(query.trim!)
		let place = do(item) first.findIndex(do $1.code == item.code)
		let rank = do(item) place(item) >= 0 ? 0 : (item.words.startsWith(text) ? 1 : 2)
		let hits = all.filter do(item)
			return yes unless text
			return item.dial.startsWith(text.replace(/\D/g, '')) if /^\+?[\d\s]+$/.test(text)
			item.code.toLowerCase! == text or item.words.split(/[\s'’-]+/).some(do $1.startsWith(text))
		hits.sort(do(a, b) rank(a) - rank(b) or place(a) - place(b))

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
		#touched = yes
		emit('change', data)

	def choose code
		let parsed = parse(entry)
		#picked = code
		entry = parsed.nationalNumber if parsed and entry.trim!.startsWith('+')
		typed!
		settle! if entry.trim!
		#open = no
		# After the popover has handed focus back to its trigger.
		setTimeout(&, 0) do $input.focus!

	# Backspace with nothing left to delete drops a picked country.
	def erase e
		return unless e.key == 'Backspace' and !entry and #picked
		#picked = null
		render!

	def toggle open
		#open = open
		return unless open
		query = ''
		#active = Math.max(0, matches.findIndex(do $1.code == flagCountry))
		render!
		reveal!

	def reveal
		querySelector('.option.active')..scrollIntoView(block: 'nearest')

	def navigate e
		let list = matches
		if e.key == 'ArrowDown' or e.key == 'ArrowUp'
			e.preventDefault!
			#active = Math.min(list.length - 1, Math.max(0, (#active or 0) + (e.key == 'ArrowDown' ? 1 : -1)))
			render!
			reveal!
		elif e.key == 'Enter'
			e.preventDefault!
			choose(list[#active].code) if list[#active]

	def hover i
		return if #active == i
		#active = i
		render!

	def searched
		#active = 0
		render!
		reveal!

	def rendered
		$picker.value = flagCountry or '' if $picker
		# The browser's own message too, for forms that check validity.
		$input.setCustomValidity(problem or '')
		#field.report(problem) if #field

	def render
		connectField!
		if data !== #shown
			entry = display(data)
			#shown = data
			#picked = null
			#touched = no

		let locked = disabled or #locked
		let messages = uiLocale.messages.phoneInput
		let invalid = !!(#field..invalid or problem)
		let input = describe({ 'aria-invalid': invalid ? 'true' : undefined })
		let flag = flagOf(flagCountry)
		let list = matches
		let active = list[#active]

		<self data-scope='phone-input' data-invalid=(invalid or undefined) data-disabled=(locked or undefined)>
			if label and !#field..label
				<label.label htmlFor=inputId> label
			<div.control>
				if searching
					<{popoverTag}.popover placement='bottom-start' flush open=!!#open @openchange.stop=toggle(e.detail)>
						<button.country slot='trigger' type='button' disabled=locked aria-label=messages.country>
							<span.flag aria-hidden='true'> flag
						<div.countries>
							<input.search type='search' placeholder=messages.search aria-label=messages.search autocomplete='off' role='combobox' aria-expanded='true' aria-controls=listId aria-activedescendant=(active ? "{listId}-{active.code}" : undefined) bind=query @input=searched @keydown=navigate>
							<div.list id=listId role='listbox' aria-label=messages.country>
								for item, i in list
									<div.option id="{listId}-{item.code}" role='option' aria-selected=(item.code == flagCountry ? 'true' : 'false') .active=(i == #active) @pointerdown.prevent @click=choose(item.code) @pointermove.silent=hover(i)>
										<span.flag aria-hidden='true'> flagOf(item.code)
										<span.name> item.name
										<span.dial> "+{item.dial}"
								if !list.length
									<div.empty> messages.noMatch
				else
					<span.country>
						<span.flag aria-hidden='true'> flag
						<select$picker.picker aria-label=messages.country disabled=locked @change.stop=choose(e.target.value)>
							<option value='' disabled hidden> '🌐'
							for item in countryItems.first
								<option value=item.code> "{flagOf(item.code)} {item.label}"
							if countryItems.first.length
								<option disabled> '──────────'
							for item in countryItems.all
								<option value=item.code> "{flagOf(item.code)} {item.label}"
				<input$input.input zag=input id=inputId type='tel' name=(name or undefined) placeholder=(placeholder or '') autocomplete=autocomplete required=required disabled=locked bind=entry @input=typed @keydown=erase @change.stop=settle>
				if showType and type
					<span.type title=messages[type] aria-label=messages[type]>
						<iconify-icon icon=(type == 'mobile' ? 'lucide:smartphone' : 'lucide:phone') aria-hidden='true'>
