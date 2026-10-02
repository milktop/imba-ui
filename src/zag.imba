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

	def stop
		unsubscribe!
		service.stop!

	def connect component
		component.connect(service.service, normalizeProps)
