# The shared parent of the form controls (`tag ui-select-base < ui-control`),
# and the helpers for finding a control's ui-field. It imports nothing, so
# field/base.imba and the controls it renders can all build on it.

# Finds the ui-field (or subclass) a control sits in.
export def closestField el
	let node = el.parentElement
	node = node.parentElement until !node or node.isUiField
	node

# Zag ids for a component's label. Zag keeps `ids` from when the machine is
# created, before the component may be in a field, so the id is looked up on use.
export def fieldIds owner
	Object.defineProperty({}, 'label', enumerable: yes, get: do closestField(owner)..labelledBy)

# What every control repeated:
#
# - `data`: what `bind=` targets. It aliases `value` here; controls bound to
#   another property (checked, open) override the pair. `bind:value=` targets
#   `value` itself. Either way Imba replaces the property with one reading and
#   writing the bound model, so controls read and write through `data`.
# - `connectField`: call it first in render. It finds the enclosing ui-field
#   (`#field`) and disabled fieldset (`#locked`), and refreshes the machine
#   when either changes what Zag reads (pass `extra` for anything else).
# - `describe(props)`: adds the field's aria-describedby to a control's props.
#
# Private names compile to Symbol.for('#name'), so subclasses read #field and
# #locked directly (e.g. `invalid: !!#field..invalid` in their machine props).
tag ui-control
	get data do value
	set data v do value = v

	def connectField extra = ''
		#field = closestField(self)
		#locked = !!closest('fieldset:disabled')
		machine..watch "{#field..stateKey}|{#locked}|{extra}"

	def describe props
		#field ? #field.describe(props) : props
