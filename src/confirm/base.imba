import { uid } from '../zag.imba'
import '../dialog/base.imba'
import '../button/base.imba'
import '../input/base.imba'
import '../alert/base.imba'

# confirm(): asks before doing something, from anywhere. A dialog you
# `await` for a yes or no, with no state to keep and nothing to put in the
# layout.
#
#   if await confirm(heading: 'Archive Ada?', confirmLabel: 'Archive')
#   	archive(ada)
#
#   await confirm
#   	heading: 'Delete Ada Lovelace?'
#   	description: 'Her lessons and invoices go too.'
#   	danger: yes
#   	confirmLabel: 'Delete'
#   	typeToConfirm: 'Ada Lovelace'
#   	onConfirm: do api.delete(ada.id) # the button spins until it's done
#
# Resolves true when confirmed, false when cancelled (Cancel, Escape or the
# close button). Calls made while one is open wait their turn.
#
# - `heading`, `description`; `content`: more text under them
# - `confirmLabel` ('Confirm'), `cancelLabel` ('Cancel'; null for none, an
#   acknowledgement)
# - `danger`: a red confirm button, for things that can't be undone
# - `typeToConfirm`: text to type before the button enables
# - `onConfirm`: runs before it closes, with the button loading; if it
#   throws (or rejects), the dialog stays open and shows the error's message
# - `size`: the dialog's size ('sm')
#
# Each one is a ui-confirm element at the end of <body>, removed once it
# has closed. Import confirm from '@milktop/imba-ui/confirm' for the styled
# one; this file's renders the headless tags.

# The open request first, then the ones waiting.
const queue = []

export const confirmHost = { tag: 'ui-confirm-base' }

def showNext
	return unless queue.length and !queue[0].shown
	let request = queue[0]
	request.shown = yes
	imba.mount <{confirmHost.tag} request=request>

export def confirm options = {}
	new Promise do(resolve)
		queue.push(Object.assign({}, options, { resolve }))
		showNext!

tag ui-confirm-base
	prop request = {}

	typed = ''
	busy = no
	error = null
	open = yes
	formId = uid('confirm')

	# The tags it's built from; the styled ui-confirm uses the styled ones.
	dialogTag = 'ui-dialog-base'
	buttonTag = 'ui-button-base'
	inputTag = 'ui-input-base'
	alertTag = 'ui-alert-base'

	get ready do !request.typeToConfirm or typed.trim! === request.typeToConfirm
	get cancelLabel do request.cancelLabel === undefined ? 'Cancel' : request.cancelLabel

	# The text to type takes focus (an alert dialog would focus its close button).
	def mount
		if request.typeToConfirm
			setTimeout(&, 60) do document.querySelector("#{formId} input")..focus!

	# Answers once: resolves the promise, then closes.
	def settle confirmed
		return unless open
		open = no
		request.resolve(confirmed)
		render!

	def accept
		return if !ready or busy
		if request.onConfirm
			busy = yes
			error = null
			render!
			try
				await request.onConfirm!
			catch e
				busy = no
				error = e..message or String(e)
				render!
				return
			busy = no
		settle(yes)

	# Closing any other way (Escape, the close button) is a no, unless it's
	# still working.
	def openChange e
		settle(no) if !e.detail and !busy
		render!

	# Gone once it has animated out; the next one (if any) opens.
	def finish
		queue.shift!
		remove!
		showNext!

	<self>
		<{dialogTag} alert open=open size=(request.size or 'sm') heading=request.heading description=request.description @openchange=openChange @exitcomplete=finish>
			if request.content or request.typeToConfirm or error
				<div.confirm-body>
					<p.content> request.content if request.content
					if request.typeToConfirm
						<form.type id=formId @submit.prevent=accept>
							<span.type-label>
								"Type "
								<strong> request.typeToConfirm
								" to confirm."
							<{inputTag} bind=typed attrs={ autocomplete: 'off', 'aria-label': "Type {request.typeToConfirm} to confirm" }>
					if error
						<{alertTag} variant='danger'> error
			<div.actions slot='footer'>
				if cancelLabel !== null
					<{buttonTag} disabled=busy @click=settle(no)> cancelLabel
				<{buttonTag} variant=(request.danger ? 'danger' : 'primary') disabled=!ready loading=busy @click=accept> request.confirmLabel or 'Confirm'
