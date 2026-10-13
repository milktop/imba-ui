import { uiLocale } from '../locale.imba'

# Number, size and relative-time formatting on Intl, with the formatters kept
# (making one is the slow part), so they're cheap to call in lists. Each takes
# a `locale`: the app's (uiLocale) when left out.
#
#   formatNumber(1820.5)                                      # '1,820.5'
#   formatNumber(1820, style: 'currency', currency: 'GBP')    # '£1,820.00'
#   formatNumber(0.125, style: 'percent')                     # '13%'
#   formatNumber(12400, notation: 'compact')                  # '12K'
#   formatBytes(2516582)                                      # '2.5 MB'
#   formatRelative('2026-10-11T09:00')                        # '2 days ago'
#
# As tags, in markup: ui-format-number, ui-format-bytes, ui-format-relative.

const cache = new Map

def cached kind, locale, options, make
	let key = "{kind}|{locale}|{JSON.stringify(options)}"
	cache.set(key, make!) unless cache.has(key)
	cache.get(key)

# A number for people: grouped digits, currency, percent, units, compact.
# `options` are Intl.NumberFormat's, plus `locale`.
export def formatNumber value, options = {}
	return '' if value == null or (typeof value == 'number' and Number.isNaN(value))
	let { locale, ...rest } = options or {}
	let tag = locale or uiLocale.locale
	cached('number', tag, rest, do new Intl.NumberFormat(tag, rest)).format(value)

# A size in bytes: '512 bytes', '624 KB', '2.4 MB' (decimal units, as file
# managers show them; `binary: yes` for KiB, MiB…).
export def formatBytes bytes, options = {}
	return '' if bytes == null or Number.isNaN(bytes)
	let { locale, binary = no, maximumFractionDigits = 1 } = options or {}
	let base = binary ? 1024 : 1000
	let units = ['byte', 'kilobyte', 'megabyte', 'gigabyte', 'terabyte', 'petabyte']
	let unit = 0
	let value = Math.abs(bytes)
	while value >= base and unit < units.length - 1
		value /= base
		unit++
	let text = formatNumber(Math.sign(bytes) * value, locale: locale, style: 'unit', unit: units[unit], unitDisplay: (unit == 0 ? 'long' : 'short'), maximumFractionDigits: (unit == 0 ? 0 : maximumFractionDigits))
	# Intl writes 'kB'; binary sizes swap in KiB, MiB…
	binary and unit > 0 ? text.replace(/[kKMGTP]B/, do $1[0].toUpperCase! + 'iB') : text.replace(/\bkB\b/, 'KB')

const steps = [['second', 60], ['minute', 60], ['hour', 24], ['day', 7], ['week', 4.34524], ['month', 12], ['year', Infinity]]

# A time relative to now: '2 hours ago', 'in 3 days', 'yesterday'.
# - `now`: what it's relative to; `numeric`: 'auto' (default, 'yesterday')
#   or 'always' ('1 day ago'); `style`: 'long' (default), 'short' or 'narrow'
export def formatRelative date, options = {}
	return '' if date == null
	let { locale, now = new Date, numeric = 'auto', style = 'long' } = options or {}
	let when = date isa Date ? date : new Date(date)
	return '' if Number.isNaN(when.getTime!)
	let value = (when.getTime! - now.getTime!) / 1000
	let unit = 'second'
	for [name, size] in steps
		unit = name
		break if Math.abs(value) < size
		value /= size
	let tag = locale or uiLocale.locale
	cached('relative', tag, { numeric, style }, do new Intl.RelativeTimeFormat(tag, { numeric, style })).format(Math.round(value), unit)

# A number for people, in markup.
#
#   <ui-format-number value=1820 format={ style: 'currency', currency: 'GBP' }>
#
# - `value`; `format`: Intl.NumberFormat's options; `locale`: the app's by default
tag ui-format-number-base
	prop value = null
	prop format = null
	prop locale = null

	<self data-value=(value ?? undefined)> formatNumber(value, Object.assign({ locale }, format))

# A size in bytes: '2.4 MB'.
#
# - `value`: bytes; `binary`: KiB, MiB…; `maximumFractionDigits` (1)
tag ui-format-bytes-base
	prop value = null
	prop binary = false
	prop maximumFractionDigits = 1
	prop locale = null

	<self data-value=(value ?? undefined)> formatBytes(value, { locale, binary, maximumFractionDigits })

# A time relative to now ('2 hours ago'), kept up to date, with the full date
# and time on hover.
#
# - `value`: a Date, ISO string or timestamp
# - `numeric`: 'auto' (default) or 'always'; `format`: Intl's style, 'long'
#   (default), 'short' or 'narrow'
# - `live`: updates every 30 seconds (true)
tag ui-format-relative-base
	prop value = null
	prop numeric = 'auto'
	prop format = 'long'
	prop live = true
	prop locale = null

	def mount
		#timer = setInterval(&, 30000) do render! if live
	def unmount do clearInterval(#timer)

	def render
		let when = value == null ? null : (value isa Date ? value : new Date(value))
		let valid = when and !Number.isNaN(when.getTime!)
		<self datetime=(valid ? when.toISOString! : undefined) title=(valid ? when.toLocaleString(locale or uiLocale.locale) : undefined)>
			formatRelative(when, { locale, numeric, style: format })
