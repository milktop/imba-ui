import { VanillaMachine, normalizeProps, spreadProps, mergeProps } from '@zag-js/vanilla'

export { normalizeProps, mergeProps }

# `<div zag=api.getRootProps!>` compiles to `el.zag = props`, so one setter is
# the whole "spread" story. Imba owns `class` (scoped CSS and flags), so Zag's
# is dropped; everything else (aria-*, data-*, id, style, on*) goes through
# Zag's own diffing spreadProps.
extend class Element
	set zag attrs
		return unless attrs
		if attrs.class or attrs.children
			attrs = Object.assign({}, attrs)
			delete attrs.class
			delete attrs.children
		spreadProps(self, attrs)

# Drops null and undefined entries, for machines that spread their props over
# defaults (passing `min: undefined` would wipe out the default).
export def defined props
	let out = {}
	for own key, value of props
		out[key] = value unless value == null
	out

let counter = 0
export def uid prefix = 'ui'
	"{prefix}-{++counter}"

# Owns a Zag service for a component's lifetime.
#
# - Zag expects the DOM to be current when its effects run (e.g. focusing the
#   selected cell right after opening), so the owner re-renders synchronously
#   on every change instead of waiting for imba.commit's next frame.
# - Zag calls the props function lazily and repeatedly, so anything derived
#   from component state that must stay fixed (like a parsed defaultValue)
#   has to be worked out before it, not inside it.
export class Machine
	constructor owner, machine, props
		service = new VanillaMachine(machine, props)
		unsubscribe = service.subscribe do
			owner.render! if owner.isConnected
			imba.commit!

	def start do service.start!

	# Re-run Zag's prop watchers and re-render after props it reads lazily
	# (e.g. a collection) changed outside of a machine event. Deferred so it
	# is safe to call from inside render.
	def refresh
		globalThis.queueMicrotask do service.notify!

	# Refreshes when `key` changes: state outside Zag that its props read, like
	# an enclosing field's label and error.
	def watch key
		return if key == #watchKey
		#watchKey = key
		refresh!

	# Controlled values. Components call `syncValue` from render with their
	# current value; when it differs from the last one seen (a parent or a bound
	# model changed it), `apply` pushes it into the machine, deferred like
	# refresh. `track` records values the machine produced and returns whether
	# it is new, so the echo of a pushed value doesn't emit `change` (native
	# inputs don't either).
	def track value
		let key = valueKey(value)
		let changed = key != #valueKey
		#valueKey = key
		changed

	def syncValue value, apply
		let key = valueKey(value)
		return if key == #valueKey
		#valueKey = key
		globalThis.queueMicrotask(apply)

	def valueKey value
		[].concat(value ?? []).map(String).join('\n')

	def stop
		unsubscribe!
		service.stop!

	def connect component
		component.connect(service.service, normalizeProps)

# Zag hides a closing popup at once, so it can't animate out. Presence keeps
# it shown while its exit animation runs: call `update` from render with the
# open state, spread `keep(props)` onto the parts it hides, and call `done`
# on animationend (a timeout covers popups without an exit animation).
export class Presence
	constructor owner, timeout = 300
		#owner = owner
		#timeout = timeout

	# `instant` closes at once, e.g. a tooltip handing over to the next one.
	def update open, instant = no
		if open or instant
			#leaving = no
		elif #wasOpen
			#leaving = yes
			clearTimeout(#timer)
			#timer = setTimeout(&, #timeout) do done!
		#wasOpen = open
		#leaving

	def keep props
		#leaving ? Object.assign({}, props, hidden: false) : props

	def done
		return unless #leaving
		#leaving = no
		#owner.render! if #owner.isConnected
