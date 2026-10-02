import * as zagClipboard from '@zag-js/clipboard'
import { Machine, uid, defined } from '../zag.imba'
import { icons } from '../icons.imba'

# Headless copy button: copies `value` to the clipboard and shows a tick and
# "Copied" for `timeout` ms.
#
# - `label`, `copiedLabel`: the text ('Copy' and 'Copied'); `iconOnly` hides
#   it (it stays the accessible name)
# - put it in a ui-input's suffix slot for a copyable field
#
# Emits `copy` with the value once it is copied.
tag ui-copy-button-base
	prop value = ''
	prop label = 'Copy'
	prop copiedLabel = 'Copied'
	prop iconOnly = false
	prop timeout = 2000

	zagId = uid('copy')

	def setup
		machine = new Machine self, zagClipboard.machine, do defined({
			id: zagId
			value: String(value ?? '')
			timeout: timeout
			onStatusChange: do(details)
				emit('copy', value) if details.copied
		})

	def mount do machine.start!
	def unmount do machine.stop!

	def render
		machine.watch String(value ?? '')
		let api = machine.connect(zagClipboard)
		let text = api.copied ? copiedLabel : label

		<self .copied=api.copied>
			<button.trigger .icon-only=iconOnly zag=api.getTriggerProps! aria-label=(iconOnly ? text : undefined)>
				<ui-icon.icon path=(api.copied ? icons.check : icons.copy) size=14>
				<span.text aria-live='polite'> text unless iconOnly
