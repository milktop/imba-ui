// TipTap's image node, keeping any data-* attributes (e.g. an id or signed
// id your server resolves later) through parsing, editing and getHTML().
// Plain JS: TipTap's extend() needs `this.parent`, which Imba's `do` blocks
// don't give.
import Image from '@tiptap/extension-image'

export const RichImage = Image.extend({
	addAttributes() {
		return {
			...this.parent?.(),
			data: {
				default: null,
				parseHTML: (element) => {
					const out = {}
					for (const { name, value } of Array.from(element.attributes)) {
						if (name.startsWith('data-')) out[name] = value
					}
					return Object.keys(out).length ? out : null
				},
				renderHTML: (attributes) => attributes.data || {},
			},
		}
	},
})
