import '../menu/base.imba'

# Headless context menu: ui-menu opened by right-clicking (or long-pressing
# on touch) an area, at the pointer.
#
#   <ui-context-menu items=actions @select=run(e.detail)>
#     <div slot='trigger'> …the area…
#
# Takes the same `items`, `label` and child tags (submenus too) as ui-menu and
# emits `select` with the chosen item's value. The element in the `trigger` slot is the area.
tag ui-context-menu-base < ui-menu-base
	def triggerProps api do api.getContextTriggerProps!
