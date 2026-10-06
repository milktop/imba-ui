import '../theme.imba'
import '../tooltip/index.imba'
import './base.imba'

tag ui-avatar < ui-avatar-base
	css
		pos:relative d:inline-grid place-items:center fls:0 w:10 h:10 of:hidden rd:full
		bg:$ui-accent-soft c:$ui-accent-soft-text ff:$ui-font fs:sm fw:600 us:none va:middle
		&.square rd:$ui-radius
		&.sm w:7 h:7 fs:xs
		&.lg w:14 h:14 fs:lg
		&.xl w:20 h:20 fs:2xl
		# Numeric sizes: the initials grow in step with the named sizes.
		&.custom w:var(--avatar-size) h:var(--avatar-size) fs:calc(6px + 0.2 * var(--avatar-size))

		&[data-color=gray] bg:#f4f4f5 c:#3f3f46
		&[data-color=red] bg:#fee2e2 c:#991b1b
		&[data-color=orange] bg:#ffedd5 c:#9a3412
		&[data-color=amber] bg:#fef3c7 c:#92400e
		&[data-color=green] bg:#dcfce7 c:#166534
		&[data-color=teal] bg:#ccfbf1 c:#115e59
		&[data-color=blue] bg:#dbeafe c:#1e40af
		&[data-color=purple] bg:#f3e8ff c:#6b21a8
		&[data-color=pink] bg:#fce7f3 c:#9d174d
		html.dark &[data-color=gray], [data-theme=dark] &[data-color=gray] bg:#3f3f46 c:#e4e4e7
		html.dark &[data-color=red], [data-theme=dark] &[data-color=red] bg:#7f1d1d c:#fecaca
		html.dark &[data-color=orange], [data-theme=dark] &[data-color=orange] bg:#7c2d12 c:#fed7aa
		html.dark &[data-color=amber], [data-theme=dark] &[data-color=amber] bg:#78350f c:#fde68a
		html.dark &[data-color=green], [data-theme=dark] &[data-color=green] bg:#14532d c:#bbf7d0
		html.dark &[data-color=teal], [data-theme=dark] &[data-color=teal] bg:#134e4a c:#99f6e4
		html.dark &[data-color=blue], [data-theme=dark] &[data-color=blue] bg:#1e3a8a c:#bfdbfe
		html.dark &[data-color=purple], [data-theme=dark] &[data-color=purple] bg:#581c87 c:#e9d5ff
		html.dark &[data-color=pink], [data-theme=dark] &[data-color=pink] bg:#831843 c:#fbcfe8

		.image pos:absolute inset:0 w:100% h:100% obj:cover
		.fallback d:grid place-items:center w:100% h:100% lh:1
		.person w:55% h:55%
		.tooltip-target pos:absolute inset:0
