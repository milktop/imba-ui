import { Editor } from '@tiptap/core'
import StarterKit from '@tiptap/starter-kit'
import { Placeholder, CharacterCount } from '@tiptap/extensions'
import { closestField } from '../control.imba'
import '../popover/base.imba'

# Headless rich text editor on TipTap (ProseMirror): a toolbar over an
# editable area whose value is HTML.
#
#   <ui-editor placeholder='Lesson notes…' bind=notes>
#
# Works with `bind=`, `bind:value=` or `value` + `@change` like the other
# controls; `change` emits the HTML ('' when empty) as you type. Inside a
# ui-field it takes the field's label, hint and error.
#
# - `value`: the HTML ('' when empty)
# - `tools`: which toolbar buttons, in order ('|' for a divider): bold,
#   italic, underline, strike, code, h2, h3, bulletList, orderedList,
#   blockquote, link, undo, redo
# - `toolbar`: false hides the toolbar
# - `placeholder`: shown while it's empty
# - `maxLength`: a character limit, with a counter
# - `minHeight`, `maxHeight`: CSS lengths; it scrolls past maxHeight
# - `disabled`: read only
#
# Keyboard shortcuts are TipTap's (⌘B, ⌘I, ⌘U, ⌘⇧7/8 for lists, ⌘Z…).
# The TipTap editor is `el.editor`, for anything more.
export const defaultTools = ['bold', 'italic', 'underline', 'strike', '|', 'h2', 'h3', '|', 'bulletList', 'orderedList', 'blockquote', '|', 'link', '|', 'undo', 'redo']

# Each tool: its icon and label, how it runs, and when it's active.
const toolDefs = {
	bold: { icon: 'lucide:bold', label: 'Bold', run: (do $1.toggleBold!), active: 'bold' }
	italic: { icon: 'lucide:italic', label: 'Italic', run: (do $1.toggleItalic!), active: 'italic' }
	underline: { icon: 'lucide:underline', label: 'Underline', run: (do $1.toggleUnderline!), active: 'underline' }
	strike: { icon: 'lucide:strikethrough', label: 'Strikethrough', run: (do $1.toggleStrike!), active: 'strike' }
	code: { icon: 'lucide:code', label: 'Code', run: (do $1.toggleCode!), active: 'code' }
	h2: { icon: 'lucide:heading-2', label: 'Heading', run: (do $1.toggleHeading(level: 2)), active: ['heading', { level: 2 }] }
	h3: { icon: 'lucide:heading-3', label: 'Subheading', run: (do $1.toggleHeading(level: 3)), active: ['heading', { level: 3 }] }
	bulletList: { icon: 'lucide:list', label: 'Bulleted list', run: (do $1.toggleBulletList!), active: 'bulletList' }
	orderedList: { icon: 'lucide:list-ordered', label: 'Numbered list', run: (do $1.toggleOrderedList!), active: 'orderedList' }
	blockquote: { icon: 'lucide:text-quote', label: 'Quote', run: (do $1.toggleBlockquote!), active: 'blockquote' }
	undo: { icon: 'lucide:undo-2', label: 'Undo', run: (do $1.undo!), can: 'undo' }
	redo: { icon: 'lucide:redo-2', label: 'Redo', run: (do $1.redo!), can: 'redo' }
}

tag ui-editor-base < ui-control
	prop value = ''
	prop placeholder = ''
	prop tools = defaultTools
	prop toolbar = true
	prop maxLength = null
	prop minHeight = '8rem'
	prop maxHeight = null
	prop disabled = false

	editor = null
	focused = no
	linkOpen = no
	linkUrl = ''
	#html = null

	def mount
		#html = data or ''
		editor = new Editor
			element: $content
			content: #html
			editable: !disabled
			extensions: [
				StarterKit.configure(heading: { levels: [2, 3] }, link: { openOnClick: false, autolink: yes })
				Placeholder.configure(placeholder: do placeholder)
				CharacterCount.configure(limit: maxLength)
			]
			# Read on every update, so the field's label and messages follow.
			editorProps:
				attributes: do
					let field = closestField(self)
					{
						role: 'textbox'
						'aria-multiline': 'true'
						'aria-labelledby': field..labelledBy or ''
						'aria-describedby': field..describedBy or ''
						'aria-invalid': field..invalid ? 'true' : 'false'
					}
			onUpdate: do({ editor })
				#html = editor.isEmpty ? '' : editor.getHTML!
				data = #html
				emit('change', data)
			onTransaction: do render!
			onFocus: do
				focused = yes
				render!
			onBlur: do
				focused = no
				render!

	def unmount
		editor..destroy!
		editor = null

	def isActive tool
		return no unless editor and tool.active
		Array.isArray(tool.active) ? editor.isActive(...tool.active) : editor.isActive(tool.active)

	def canRun tool
		return no unless editor and !disabled
		return editor.can![tool.can]! if tool.can
		yes

	def run tool
		tool.run(editor.chain!.focus!).run!

	# The link popover: the current link's address, applied or removed.
	def openLink
		linkUrl = editor..getAttributes('link')..href or ''

	def applyLink
		let url = linkUrl.trim!
		let chain = editor.chain!.focus!.extendMarkRange('link')
		url ? chain.setLink(href: (/^[a-z]+:/i.test(url) ? url : "https://{url}")).run! : chain.unsetLink!.run!
		linkOpen = no

	def removeLink
		editor.chain!.focus!.extendMarkRange('link').unsetLink!.run!
		linkOpen = no

	get characters do editor ? editor.storage.characterCount.characters! : 0

	def render
		connectField!
		# A new value from outside (not the editor's own) replaces the content.
		if editor and (data or '') !== #html
			#html = data or ''
			editor.commands.setContent(#html, emitUpdate: no)
		editor.setEditable(!(disabled or #locked)) if editor and editor.isEditable == !!(disabled or #locked)

		<self .focused=focused .disabled=(disabled or #locked)>
			if toolbar and !(disabled or #locked)
				<div.toolbar role='toolbar' aria-label='Formatting'>
					for name, i in tools
						if name == '|'
							<span.divider key="d{i}">
						elif name == 'link'
							<ui-popover key='link' placement='bottom-start' bind=linkOpen @openchange=(openLink! if e.detail)>
								<button.tool slot='trigger' type='button' aria-label='Link' aria-pressed=String(!!editor..isActive('link')) @mousedown.prevent>
									<iconify-icon icon='lucide:link' aria-hidden='true'>
								<form.link-form @submit.prevent=applyLink>
									<ui-input.link-input size='sm' icon='lucide:link' placeholder='https://…' bind=linkUrl>
									<div.link-actions>
										<ui-button size='sm' variant='ghost' @click=removeLink> "Remove" if editor..isActive('link')
										<ui-button size='sm' variant='primary' type='submit'> "Apply"
						elif toolDefs[name]
							let tool = toolDefs[name]
							<button.tool key=name type='button' aria-label=tool.label aria-pressed=(tool.active ? String(isActive(tool)) : undefined) disabled=!canRun(tool) @mousedown.prevent @click=run(tool)>
								<iconify-icon icon=tool.icon aria-hidden='true'>
			<div$content.content style="--min-height: {minHeight}; --max-height: {maxHeight or 'none'}">
			if maxLength
				<div.count .over=(characters >= maxLength)> "{characters} / {maxLength}"
