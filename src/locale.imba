# The app's locale and the components' words: one setting for the whole app,
# read by every component that formats dates, times and numbers (date picker,
# number input, slider, progress, charts, stats, the format tags…) or shows
# words of its own (placeholders, empty states, screen-reader labels).
#
#   import { uiLocale } from '@milktop/imba-ui/locale'
#   uiLocale.set('fr-FR')
#   uiLocale.set('en-GB', { table: { empty: 'No patients yet' } })
#
# - `uiLocale.locale`: a BCP 47 tag ('en-GB', 'fr-FR'); the browser's until set
# - `uiLocale.messages`: the words: the built-in list for the locale's
#   language (English and French; anything else gets English), with the
#   overrides given to `set` merged over it, so one word can change without
#   restating the rest. For another language, give them all, starting from `en`.
#
# Words given straight to a component (a `placeholder`, `emptyText`, `label`)
# win over these, and a component's own `locale` prop over the app's. Setting
# it re-renders the app. Entries that take values are functions. The `zag`
# group passes on to Zag's own `translations` (the screen-reader labels inside
# the date picker, number input, password input, pin input, tags input,
# pagination, file upload, copy button, tree view and editable); English
# leaves them to Zag.

const capital = do(name) name.charAt(0).toUpperCase! + name.slice(1)
const swatchNames = ['slate', 'red', 'orange', 'amber', 'yellow', 'lime', 'green', 'emerald', 'teal', 'cyan', 'sky', 'blue', 'indigo', 'violet', 'purple', 'fuchsia', 'pink', 'rose']

export const en = {
	common: {
		close: 'Close', dismiss: 'Dismiss', cancel: 'Cancel', confirm: 'Confirm', save: 'Save', edit: 'Edit', loading: 'Loading'
		remove: (do(name) "Remove {name ?? ''}".trim!), more: (do(count) "{count} more")
	}
	confirm: { typePrefix: 'Type', typeSuffix: 'to confirm.', typeToConfirm: (do(word) "Type {word} to confirm") }
	copyButton: { copy: 'Copy', copied: 'Copied' }
	shell: {
		nav: 'Main', openMenu: 'Open menu', closeMenu: 'Close menu', expandSidebar: 'Expand sidebar', collapseSidebar: 'Collapse sidebar'
		expandAll: 'Expand all', collapseAll: 'Collapse all'
	}
	breadcrumbs: { label: 'Breadcrumb', more: (do(count) "Show {count} more") }
	pagination: { label: 'Pagination', showing: (do(from, to, count, noun) "Showing {from}–{to} of {count}{noun ? ' ' + noun : ''}") }
	table: { empty: 'Nothing here yet', selectAll: 'Select all rows', selectRow: (do(name) "Select {name}") }
	select: { placeholder: 'Select…', searchPlaceholder: 'Search…', empty: 'No matches', loading: 'Loading…', create: (do(text) "Create “{text}”") }
	datePicker: {
		format: (do(pattern) "Enter a date as {pattern}"), min: (do(date) "Pick a date from {date}"), max: (do(date) "Pick a date up to {date}")
		unavailable: 'That date isn’t available'
	}
	dateRangeFilter: {
		placeholder: 'All dates', clear: 'Clear'
		ranges: {
			today: 'Today', yesterday: 'Yesterday', tomorrow: 'Tomorrow'
			last7: 'Last 7 days', last30: 'Last 30 days', next7: 'Next 7 days', next30: 'Next 30 days'
			thisWeek: 'This week', lastWeek: 'Last week', nextWeek: 'Next week'
			thisMonth: 'This month', lastMonth: 'Last month', nextMonth: 'Next month'
			thisQuarter: 'This quarter', lastQuarter: 'Last quarter', thisYear: 'This year', lastYear: 'Last year'
		}
	}
	swatchPicker: { placeholder: 'Pick a colour', colors: Object.fromEntries(swatchNames.map(do [$1, capital($1)])) }
	command: { label: 'Command menu', search: 'Search…', placeholder: 'Type a command or search…', empty: 'No results', loading: 'Searching…', esc: 'Esc' }
	toaster: { label: 'Notifications' }
	actionBar: { label: 'Selection actions' }
	spinner: { label: 'Loading' }
	chart: { label: 'Chart', total: 'Total', trend: (do(values) "Trend: {values}") }
	stat: { up: 'Up', down: 'Down', same: 'No change' }
	themeToggle: { label: 'Colour scheme', light: 'Light', dark: 'Dark', system: 'System' }
	appearance: {
		label: 'Appearance', mode: 'Mode', accent: 'Colour', sidebar: 'Sidebar', lightOnly: 'in light mode'
		custom: 'Any colour', dev: 'Dev mode', reset: 'Reset'
		accents: { slate: 'Slate', blue: 'Blue', indigo: 'Indigo', violet: 'Violet', teal: 'Teal', emerald: 'Emerald', rose: 'Rose' }
		sidebars: { default: 'Default', neutral: 'Neutral', soft: 'Soft', tint: 'Tint', accent: 'Accent', dark: 'Dark', deep: 'Deep' }
	}
	fileUpload: {
		prompt: (do(multiple) "Drop {multiple ? 'files' : 'a file'} here or "), browse: 'browse'
		reasons: { FILE_INVALID_TYPE: 'Not an accepted file type', FILE_TOO_LARGE: 'Too large', FILE_TOO_SMALL: 'Too small', TOO_MANY_FILES: 'Too many files', FILE_EXISTS: 'Already added' }
	}
	attachments: {
		add: 'Add files', layout: 'Layout', grid: 'Grid', list: 'List', orDrop: 'or drop files here', dropToAdd: 'Drop to add', download: 'Download', untitled: 'Untitled'
		open: (do(name) "Open {name}"), downloadFile: (do(name) "Download {name}")
		count: (do(count, max) "{count} of {max}"), limit: (do(max) "The limit is {max} files")
		notType: 'not an accepted type', over: (do(size) "over {size}"), notAdded: (do(name, reason) "{name} wasn’t added: {reason}.")
	}
	sortableList: {
		handle: 'Drag to reorder'
		instructions: 'Press Space to pick this up. While it’s picked up, use the arrow keys to move it, Space to drop it, or Escape to cancel.'
		position: (do(index, count) "position {index} of {count}")
		pickedUp: (do(name, place) "Picked up {name}, at {place}.")
		movedTo: (do(name, place) "{name} moved to {place}.")
		dropped: (do(name, place) "{name} dropped at {place}.")
		cancelled: (do(name, place) "Reordering cancelled: {name} is back at {place}.")
	}
	calendar: {
		today: 'Today', previous: 'Previous', next: 'Next', allDay: 'All day', view: 'View', pickDate: 'pick a date'
		day: 'Day', week: 'Week', workweek: 'Work week', days: (do(count) "{count} days")
		more: (do(count) "+{count} more"), unavailable: 'Not available', cancel: 'Cancel', event: 'Event'
		placing: (do(name) "Placing {name}: click a time, or press Escape to cancel.")
		selected: (do(when) "Selected {when}."), moved: (do(name, when) "{name} moved to {when}."), resized: (do(name, time) "{name} now ends at {time}.")
	}
	editor: {
		toolbar: 'Formatting', link: 'Link', image: 'Image', remove: 'Remove', apply: 'Apply', uploading: 'Uploading…'
		tools: {
			bold: 'Bold', italic: 'Italic', underline: 'Underline', strike: 'Strikethrough', code: 'Code', h2: 'Heading', h3: 'Subheading'
			bulletList: 'Bulleted list', orderedList: 'Numbered list', blockquote: 'Quote', undo: 'Undo', redo: 'Redo'
		}
	}
	phoneInput: { country: 'Country', mobile: 'Mobile', landline: 'Landline' }
	zag: {}
}

const frViews = { day: 'jours', month: 'mois', year: 'années' }

export const fr = {
	common: {
		close: 'Fermer', dismiss: 'Ignorer', cancel: 'Annuler', confirm: 'Confirmer', save: 'Enregistrer', edit: 'Modifier', loading: 'Chargement'
		remove: (do(name) "Retirer {name ?? ''}".trim!), more: (do(count) "{count} de plus")
	}
	confirm: { typePrefix: 'Saisissez', typeSuffix: 'pour confirmer.', typeToConfirm: (do(word) "Saisissez {word} pour confirmer") }
	copyButton: { copy: 'Copier', copied: 'Copié' }
	shell: {
		nav: 'Principal', openMenu: 'Ouvrir le menu', closeMenu: 'Fermer le menu', expandSidebar: 'Déplier la barre latérale'
		collapseSidebar: 'Replier la barre latérale', expandAll: 'Tout déplier', collapseAll: 'Tout replier'
	}
	breadcrumbs: { label: 'Fil d’Ariane', more: (do(count) "Afficher {count} de plus") }
	pagination: { label: 'Pagination', showing: (do(from, to, count, noun) "{from}–{to} sur {count}{noun ? ' ' + noun : ''}") }
	table: { empty: 'Rien pour l’instant', selectAll: 'Sélectionner toutes les lignes', selectRow: (do(name) "Sélectionner {name}") }
	select: { placeholder: 'Choisir…', searchPlaceholder: 'Rechercher…', empty: 'Aucun résultat', loading: 'Chargement…', create: (do(text) "Créer « {text} »") }
	datePicker: {
		format: (do(pattern) "Saisissez une date au format {pattern.replace(/d/g, 'j').replace(/y/g, 'a')}")
		min: (do(date) "Choisissez une date à partir du {date}"), max: (do(date) "Choisissez une date jusqu’au {date}")
		unavailable: 'Cette date n’est pas disponible'
	}
	dateRangeFilter: {
		placeholder: 'Toutes les dates', clear: 'Effacer'
		ranges: {
			today: 'Aujourd’hui', yesterday: 'Hier', tomorrow: 'Demain'
			last7: '7 derniers jours', last30: '30 derniers jours', next7: '7 prochains jours', next30: '30 prochains jours'
			thisWeek: 'Cette semaine', lastWeek: 'Semaine dernière', nextWeek: 'Semaine prochaine'
			thisMonth: 'Ce mois-ci', lastMonth: 'Mois dernier', nextMonth: 'Mois prochain'
			thisQuarter: 'Ce trimestre', lastQuarter: 'Trimestre dernier', thisYear: 'Cette année', lastYear: 'Année dernière'
		}
	}
	swatchPicker: {
		placeholder: 'Choisir une couleur'
		colors: {
			slate: 'Ardoise', red: 'Rouge', orange: 'Orange', amber: 'Ambre', yellow: 'Jaune', lime: 'Citron vert', green: 'Vert'
			emerald: 'Émeraude', teal: 'Sarcelle', cyan: 'Cyan', sky: 'Ciel', blue: 'Bleu', indigo: 'Indigo', violet: 'Violet'
			purple: 'Pourpre', fuchsia: 'Fuchsia', pink: 'Rose', rose: 'Rose vif'
		}
	}
	command: { label: 'Menu de commandes', search: 'Rechercher…', placeholder: 'Tapez une commande ou recherchez…', empty: 'Aucun résultat', loading: 'Recherche…', esc: 'Échap' }
	toaster: { label: 'Notifications' }
	actionBar: { label: 'Actions sur la sélection' }
	spinner: { label: 'Chargement' }
	chart: { label: 'Graphique', total: 'Total', trend: (do(values) "Tendance : {values}") }
	stat: { up: 'Hausse', down: 'Baisse', same: 'Stable' }
	themeToggle: { label: 'Thème', light: 'Clair', dark: 'Sombre', system: 'Système' }
	appearance: {
		label: 'Apparence', mode: 'Mode', accent: 'Couleur', sidebar: 'Barre latérale', lightOnly: 'en mode clair'
		custom: 'Couleur libre', dev: 'Mode dev', reset: 'Réinitialiser'
		accents: { slate: 'Ardoise', blue: 'Bleu', indigo: 'Indigo', violet: 'Violet', teal: 'Teal', emerald: 'Émeraude', rose: 'Rose' }
		sidebars: { default: 'Par défaut', neutral: 'Neutre', soft: 'Doux', tint: 'Teinte', accent: 'Accent', dark: 'Foncé', deep: 'Très foncé' }
	}
	fileUpload: {
		prompt: (do(multiple) "Déposez {multiple ? 'des fichiers' : 'un fichier'} ici ou "), browse: 'parcourez'
		reasons: { FILE_INVALID_TYPE: 'Type non autorisé', FILE_TOO_LARGE: 'Trop volumineux', FILE_TOO_SMALL: 'Trop petit', TOO_MANY_FILES: 'Trop de fichiers', FILE_EXISTS: 'Déjà ajouté' }
	}
	attachments: {
		add: 'Ajouter des fichiers', layout: 'Affichage', grid: 'Grille', list: 'Liste', orDrop: 'ou déposez des fichiers ici'
		dropToAdd: 'Déposez pour ajouter', download: 'Télécharger', untitled: 'Sans titre'
		open: (do(name) "Ouvrir {name}"), downloadFile: (do(name) "Télécharger {name}")
		count: (do(count, max) "{count} sur {max}"), limit: (do(max) "La limite est de {max} fichiers")
		notType: 'type non accepté', over: (do(size) "plus de {size}"), notAdded: (do(name, reason) "{name} n’a pas été ajouté : {reason}.")
	}
	sortableList: {
		handle: 'Glisser pour réordonner'
		instructions: 'Appuyez sur Espace pour saisir cet élément. Déplacez-le ensuite avec les flèches, déposez-le avec Espace, ou appuyez sur Échap pour annuler.'
		position: (do(index, count) "position {index} sur {count}")
		pickedUp: (do(name, place) "{name} saisi, en {place}.")
		movedTo: (do(name, place) "{name} déplacé en {place}.")
		dropped: (do(name, place) "{name} déposé en {place}.")
		cancelled: (do(name, place) "Déplacement annulé : {name} est revenu en {place}.")
	}
	calendar: {
		today: 'Aujourd’hui', previous: 'Précédent', next: 'Suivant', allDay: 'Journée', view: 'Vue', pickDate: 'choisir une date'
		day: 'Jour', week: 'Semaine', workweek: 'Semaine de travail', days: (do(count) "{count} jours")
		more: (do(count) "+{count} de plus"), unavailable: 'Indisponible', cancel: 'Annuler', event: 'Événement'
		placing: (do(name) "Placement de {name} : cliquez sur un créneau, ou Échap pour annuler.")
		selected: (do(when) "{when} sélectionné."), moved: (do(name, when) "{name} déplacé au {when}."), resized: (do(name, time) "{name} finit maintenant à {time}.")
	}
	editor: {
		toolbar: 'Mise en forme', link: 'Lien', image: 'Image', remove: 'Retirer', apply: 'Appliquer', uploading: 'Envoi…'
		tools: {
			bold: 'Gras', italic: 'Italique', underline: 'Souligné', strike: 'Barré', code: 'Code', h2: 'Titre', h3: 'Sous-titre'
			bulletList: 'Liste à puces', orderedList: 'Liste numérotée', blockquote: 'Citation', undo: 'Annuler', redo: 'Rétablir'
		}
	}
	phoneInput: { country: 'Pays', mobile: 'Mobile', landline: 'Fixe' }
	zag: {
		datePicker: {
			dayCell: (do(state) state.unavailable ? "Indisponible. {state.valueText}" : (state.selected ? "Date choisie. {state.valueText}" : "Choisir {state.valueText}"))
			trigger: (do(open) open ? 'Fermer le calendrier' : 'Ouvrir le calendrier')
			viewTrigger: (do(view, next) next ? "Passer à la vue {frViews[next] ?? next}" : "Vue {frViews[view] ?? view}")
			prevTrigger: (do(view) view == 'year' ? 'Décennie précédente' : (view == 'month' ? 'Année précédente' : 'Mois précédent'))
			nextTrigger: (do(view) view == 'year' ? 'Décennie suivante' : (view == 'month' ? 'Année suivante' : 'Mois suivant'))
			presetTrigger: (do(range) "choisir du {range[0] ?? ''} au {range[1] ?? ''}")
			clearTrigger: 'Effacer les dates', content: 'calendrier', monthSelect: 'Choisir le mois', yearSelect: 'Choisir l’année'
		}
		numberInput: { incrementLabel: 'augmenter', decrementLabel: 'diminuer' }
		passwordInput: { visibilityTrigger: (do(visible) visible ? 'Masquer le mot de passe' : 'Afficher le mot de passe') }
		tagsInput: {
			clearTriggerLabel: 'Effacer toutes les étiquettes', deleteTagTriggerLabel: (do(value) "Supprimer l’étiquette {value}")
			tagAdded: (do(value) "Étiquette {value} ajoutée"), tagsPasted: (do(values) "{values.length} étiquettes collées")
			tagEdited: (do(value) "Modification de l’étiquette {value}. Entrée pour enregistrer, Échap pour annuler.")
			tagUpdated: (do(value) "Étiquette modifiée en {value}"), tagDeleted: (do(value) "Étiquette {value} supprimée")
			tagSelected: (do(value) "Étiquette {value} sélectionnée. Entrée pour modifier, Suppr ou Retour arrière pour retirer.")
			noTagsSelected: 'Aucune étiquette sélectionnée', inputLabel: (do(count) count == 1 ? '1 étiquette' : "{count} étiquettes")
		}
		pagination: {
			rootLabel: 'pagination', firstTriggerLabel: 'première page', prevTriggerLabel: 'page précédente'
			nextTriggerLabel: 'page suivante', lastTriggerLabel: 'dernière page'
			itemLabel: (do(d) "{d.totalPages > 1 and d.page == d.totalPages ? 'dernière page, ' : ''}page {d.page}")
		}
		fileUpload: { dropzone: 'zone de dépôt', itemPreview: (do(file) "aperçu de {file.name}"), deleteFile: (do(file) "supprimer le fichier {file.name}") }
		combobox: { triggerLabel: 'Afficher les suggestions', clearTriggerLabel: 'Effacer' }
		select: { clearTriggerLabel: 'Effacer' }
		clipboard: { triggerLabel: (do(copied) copied ? 'Copié dans le presse-papiers' : 'Copier dans le presse-papiers') }
		treeView: { treeLabel: 'Arborescence', renameInputLabel: 'Renommer l’élément' }
		editable: { input: 'champ modifiable', edit: 'modifier', submit: 'valider', cancel: 'annuler' }
		pinInput: { inputLabel: (do(index, length) "chiffre {index + 1} sur {length}") }
	}
}

export const builtIn = { en, fr }

# Merges plain objects; functions, arrays and everything else replace.
export def mergeMessages base, over
	return base unless over
	let out = Object.assign({}, base)
	for own key, value of over
		continue if value === undefined
		let current = out[key]
		let nested = value and typeof value == 'object' and !Array.isArray(value) and current and typeof current == 'object'
		out[key] = nested ? mergeMessages(current, value) : value
	out

class UiLocale
	#locale = null
	#overrides = null
	#messages = null

	# The locale in use: the one set, or the browser's.
	get locale do #locale or globalThis.navigator..language or 'en-GB'

	get messages
		#messages ||= mergeMessages(builtIn[locale.split('-')[0].toLowerCase!] or en, #overrides)

	# The locale (and words to change); the app re-renders with them.
	def set locale, overrides = null
		#locale = locale
		#overrides = overrides
		#messages = null
		imba.commit!

	# Zag's own screen-reader words for one of its machines, if any.
	def zag name do messages.zag..[name]

export const uiLocale = new UiLocale
