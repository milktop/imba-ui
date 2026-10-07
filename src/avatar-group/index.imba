import '../theme.imba'
import '../avatar/index.imba'
import '../tooltip/index.imba'
import './base.imba'

# A stack: each overlaps the one before, ringed in $ui-avatar-ring so the
# edges read. Avatars are slotted or rendered here, so through `>>>`.
tag ui-avatar-group < ui-avatar-group-base
	avatarTag = 'ui-avatar'

	css
		d:inline-flex ai:center va:middle
		$ui-avatar-ring:$ui-surface $overlap-size:0.625rem $overlap-scale:1
		$overlap:calc($overlap-size * $overlap-scale)
		&[data-size=sm] $overlap-size:0.5rem
		&[data-size=lg] $overlap-size:0.875rem
		&[data-size=xl] $overlap-size:1.25rem
		&[data-spacing=tight] $overlap-scale:1.5
		&[data-spacing=loose] $overlap-scale:0.4
		>>> :is(ui-avatar, .more) box-shadow:0 0 0 2px $ui-avatar-ring
		>>> :is(ui-avatar, ui-tooltip) + :is(ui-avatar, ui-tooltip) ml:calc($overlap * -1)
		# The "+N" sits in a tooltip wrapper (d:contents), so it takes the margin itself.
		>>> ui-avatar + ui-tooltip .more ml:calc($overlap * -1)

		.more d:inline-grid place-items:center fls:0 w:10 h:10 rd:full box-sizing:border-box bg:$ui-hover c:$ui-muted ff:$ui-font fs:xs fw:600 cursor:default
			&.square rd:$ui-radius
		&[data-size=sm] .more w:7 h:7 fs:11px
		&[data-size=lg] .more w:14 h:14 fs:15px
		&[data-size=xl] .more w:20 h:20 fs:20px
		&[data-size=custom] .more w:var(--avatar-size) h:var(--avatar-size) fs:calc(4px + 0.2 * var(--avatar-size))
