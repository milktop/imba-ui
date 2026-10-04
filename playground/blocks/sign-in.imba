# A sign-in screen: a centred card with the form, a social option and a link
# to sign up.
tag block-sign-in
	email = ''
	password = ''
	remember = yes
	busy = no

	def submit
		busy = yes
		setTimeout(&, 1200) do
			busy = no
			imba.commit!

	css
		d:grid place-items:center py:8
		.card w:100% max-width:24rem
		.brand d:flex fld:column ai:center g:3 mb:6 ta:center
		.mark d:grid place-items:center w:10 h:10 rd:calc($ui-radius + 2px) bg:$ui-accent c:$ui-accent-text fw:700
		h2 m:0 fs:xl fw:700
		.sub m:0 c:$ui-muted fs:sm
		form d:flex fld:column g:4
		.row d:flex ai:center jc:space-between
		.link c:$ui-accent fs:sm td:none
			@hover td:underline
		.or d:flex ai:center g:3 c:$ui-muted fs:xs my:1
			@before, @after content:'' flg:1 h:1px bg:$ui-border
		.foot m:0 mt:6 ta:center fs:sm c:$ui-muted

	<self>
		<div.card>
			<div.brand>
				<span.mark> "T"
				<div>
					<h2> "Welcome back"
					<p.sub> "Sign in to your tutoring account"
			<ui-card>
				<form @submit.prevent=submit>
					<ui-fields>
						<ui-field label='Email' type='email' icon='lucide:mail' placeholder='you@example.com' autocomplete='email' bind=email>
						<ui-field label='Password' type='password' autocomplete='current-password' bind=password>
					<div.row>
						<ui-checkbox label='Remember me' bind=remember>
						<a.link href='#'> "Forgot password?"
					<ui-button type='submit' variant='primary' block loading=busy> "Sign in"
					<div.or> "or"
					<ui-button block icon='logos:google-icon'> "Continue with Google"
			<p.foot>
				"New here? "
				<a.link href='#'> "Create an account"
