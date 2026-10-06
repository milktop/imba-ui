import source from './segmented.imba?raw'

tag page-segmented
	view = 'week'
	mode = 1
	views = [{ value: 'day', label: 'Day' }, { value: 'week', label: 'Week' }, { value: 'month', label: 'Month' }, { value: 'year', label: 'Year', disabled: true }]
	align = 'left'
	aligns = [{ value: 'left', label: 'Align left', icon: 'lucide:align-left' }, { value: 'center', label: 'Centre', icon: 'lucide:align-center' }, { value: 'right', label: 'Align right', icon: 'lucide:align-right' }]
	modes = [{ value: 1, label: 'Online' }, { value: 2, label: 'In person' }, { value: 3, label: 'Hybrid' }]

	<self>
		<demo-page source=source heading='Segmented' intro='ui-segmented is a compact row of options with an indicator that slides to the selected one.'>
			<demo-section heading='Basic'>
				<ui-fields>
					<ui-field span=6 label='Calendar view' hint='Year is disabled'>
						<ui-segmented items=views bind=view>
				<div.out>
					<json-print data={ view }>

			<demo-section heading='Number values'>
				<ui-fields>
					<ui-field span=6 label='Mode' hint='Item values stay numbers'>
						<ui-segmented items=modes bind=mode>
				<div.out>
					<json-print data={ mode }>
					<div.set>
						<button @click=(mode = 3)> "Hybrid"

			<demo-section heading='Icons only'>
				<ui-fields>
					<ui-field span=6 label='Alignment' hint='Hover or tab to an icon for its label'>
						<ui-segmented items=aligns iconOnly bind=align>
				<div.out>
					<json-print data={ align }>

			<demo-section heading='Sizes' uses='views aligns'>
				<div[d:vtl g:3]>
					<ui-segmented size='sm' items=views bind=view>
					<ui-segmented items=views bind=view>
					<ui-segmented size='lg' items=views bind=view>
					<div.row>
						<ui-segmented size='sm' iconOnly items=aligns bind=align>
						<ui-segmented iconOnly items=aligns bind=align>
						<ui-segmented size='lg' iconOnly items=aligns bind=align>
				<div.out>
					<p.note> "`size` is 'sm', 'md' (the default, matching the inputs) or 'lg', like ui-button."
