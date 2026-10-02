import * as zagToast from '@zag-js/toast'
import { Machine, uid } from '../zag.imba'
import { icons } from '../icons.imba'

# Toasts: brief notifications stacked in a corner.
#
#   import { toaster } from '@milktop/imba-ui/toast'
#   toaster.success(title: 'Lesson booked', description: 'Thursday at 16:00')
#   toaster.error(title: 'Could not save')
#   let id = toaster.loading(title: 'Uploading…')
#   toaster.update(id, type: 'success', title: 'Uploaded')
#
# Render one <ui-toaster> (e.g. in the app layout). Toasts pause while hovered
# or focused, Escape dismisses the focused one, and Alt+T jumps to them.
# An `action: { label, onClick }` adds a button.
#
# The shared `toaster` stacks at bottom-end; make another with createToaster
# and pass it as `store`.
export def createToaster options = {}
	zagToast.createStore(Object.assign({ placement: 'bottom-end', overlap: true, max: 5 }, options))

export const toaster = createToaster!

const typeIcons = { info: icons.info, success: icons.success, warning: icons.warning, error: icons.error }

# One toast; the toaster renders these, keyed by toast id.
tag ui-toast-base
	prop toast = null
	prop parent = null
	prop index = 0

	def setup
		machine = new Machine self, zagToast.machine, do
			Object.assign({}, toast, parent: parent, index: index)

	def mount do machine.start!
	def unmount do machine.stop!

	def render
		# Zag reads the toast's props lazily; refresh when they change.
		machine.watch "{index}|{JSON.stringify(toast)}"
		let api = machine.connect(zagToast)
		let action = toast..action

		<self zag=api.getRootProps!>
			<span zag=api.getGhostBeforeProps!>
			if api.type == 'loading'
				<span.icon.spinner aria-hidden='true'>
			elif typeIcons[api.type]
				<ui-icon.icon path=typeIcons[api.type] size=18 aria-hidden='true'>
			<div.text>
				<div.title zag=api.getTitleProps!> api.title if api.title
				<div.description zag=api.getDescriptionProps!> api.description if api.description
			if action
				# Zag calls action.onClick and dismisses the toast.
				<button.action zag=api.getActionTriggerProps!> action.label
			<button.close zag=api.getCloseTriggerProps!> <ui-icon path=icons.x size=14>
			<span zag=api.getGhostAfterProps!>

# The region toasts stack in, rendered at the end of <body>.
tag ui-toaster-base
	prop store = toaster
	prop label = 'Notifications'

	# The tag for each toast; the styled toaster uses ui-toast.
	toastTag = 'ui-toast-base'

	def setup
		machine = new Machine self, zagToast.group.machine, do
			id: uid('toaster')
			store: store

	def mount do machine.start!
	def unmount do machine.stop!

	def render
		let api = machine.connect(zagToast.group)
		let parent = machine.service.service

		<self>
			<global>
				<div.group zag=api.getGroupProps(label: label)>
					# Keyed by id, so each toast keeps its element (and machine) as
					# others come and go.
					for data, i in api.getToasts!
						<{toastTag} key=data.id toast=data parent=parent index=i>
