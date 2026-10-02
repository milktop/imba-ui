import source from './skeleton.imba?raw'

tag page-skeleton
	loading = yes

	css
		.profile d:flex ai:center g:3 w:100% max-width:24rem

	<self>
		<demo-page source=source heading='Skeleton' intro='ui-skeleton shows the shape of content while it loads. It is hidden from assistive tech; mark the region aria-busy.'>
			<demo-section heading='Loading a profile'>
				<div.profile aria-busy=String(loading)>
					if loading
						<ui-skeleton circle width='40px' height='40px'>
						<div [fl:1]> <ui-skeleton lines=2>
					else
						<ui-avatar name='Ada Lovelace'>
						<div>
							<strong> "Ada Lovelace"
							<div [c:$ui-muted fs:sm]> "Maths tutor, 12 years"
				<div.out>
					<div.set>
						<button @click=(loading = !loading)> loading ? "Finish loading" : "Load again"

			<demo-section heading='Shapes'>
				<div [d:vflex g:3 w:100%]>
					<ui-skeleton height='120px'>
					<ui-skeleton lines=3>
					<div.row>
						<ui-skeleton width='80px' height='28px'>
						<ui-skeleton width='120px' height='28px'>
