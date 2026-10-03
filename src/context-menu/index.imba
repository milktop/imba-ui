import '../menu/index.imba'
import './base.imba'

# Extends the styled ui-menu for its look (ui-context-menu-base does the same
# on the headless menu).
tag ui-context-menu < ui-menu
	def triggerProps api do api.getContextTriggerProps!
