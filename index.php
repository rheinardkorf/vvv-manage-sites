<?php


function get_site_info( $item, $post ) {
	$site = array(
		'path' => $post['path'][ $item ],
		'title' => ! empty( $post['title'][ $item ] ) ? $post['title'][ $item ] : '',
		'url' => ! empty( $post['url'][ $item ] ) ? $post['url'][ $item ] : '',
		'database' => ! empty( $post['database'][ $item ] ) ? $post['database'][ $item ] : '',
		'email' => ! empty( $post['email'][ $item ] ) ? $post['email'][ $item ] : '',
	);

	return $site;
}


if ( isset( $_POST['kill'] ) ) {
	$item = array_keys( $_POST['kill'] );
	$item = array_pop( $item );
	
	$site = get_site_info( $item, $_POST );

	$command = './scripts/vvv-kill-site.rb --path"' . $site['path'] . '" --database"' . $site['database'] . '"';
	$msg = $command;
	$msg .= '<div><pre>' . shell_exec( $command ) . '</pre></div>';
	
}

if ( isset( $_POST['reset'] ) ) {
	$item = array_keys( $_POST['reset'] );
	$item = array_pop( $item );

	$site = get_site_info( $item, $_POST );

	$command  = './scripts/vvv-reset-site.rb --path"' . $site['path'] . '"';
	$command .= ' --email"' . $site['email'] . '" --title"' . $site['title'] . '" --url"' . $site['url'] . '"';
		
	$msg = $command;
	$msg .= '<div><pre>' . shell_exec( $command ) . '</pre></div>';
}


if ( isset( $_POST['submit'] ) ) {
	
	$error = false;
	
	$error = empty( $_POST['folder'] );
	$error = empty( $_POST['site_title'] );
	$error = empty( $_POST['database'] );	
	$error = empty( $_POST['domain'] );	
	
	if ( ! $error ) {

		$folder = $_POST['folder'];
		$site_title = $_POST['site_title'];
		$database = $_POST['database'];
		$domain = $_POST['domain'];
		$email = empty( $_POST['email'] ) ? 'admin@' . $domain : $_POST['email'];
		$multisite = isset( $_POST['multisite'] ) ? '--multisite ' : ' ';
		$subdomains = isset( $_POST['subdomains'] ) ? '--subdomains ' : ' ';
		$version = empty( $_POST['version'] ) ? '' : '--version"' . $_POST['version'] . '"';
		
		$command = './scripts/vvv-new-site.rb --folder"' . $folder . '" --site_title"' . $site_title . '" --database"' . $database . '" --domain"' . $domain . '" --email"' . $email . '" ' . $multisite . $subdomains . $version;
		$msg = $command;
		$msg .= '<div><pre>' . shell_exec( $command ) . '</pre></div>';
		
	} else {
		
		$msg = "<ul><li>Folder,</li><li>Title,</li><li>Database and</li><li>Domain are required.</li></ul>The rest will just use dummy data if not provided.";
		
	}
} 
	
ob_start();
?>

	<html>
	<head>
		<title>Create new VVV WordPress site</title>
		<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
		<script src="assets/script.js"></script>
		<style>
		div { padding-bottom:10px; }
		label{ width: 200px; display:inline-block;}
		[name="submit"] {
			width:150px;
			height: 40px;
			display:inline-block;
			font-size:1.1em;
		}
		[type="textbox"] {
			width: 250px;
		}
		.msg{
			border: 1px dashed #afafaf;
			margin-bottom: 20px;
			padding:20px;
		}
		table {
			width: 100%;
		}
		th {
			text-align: left;
		}
		tr {
			height: 20;
		}
		.even {
			background: #f1f1f1;
		}
		
		</style>
	</head>
	<body>	

		<h1>Create new VVV WordPress site</h1>

		<?php echo ! empty( $msg ) ? '<div class="msg">' . $msg . '</div>' : ''; ?>

		<h2>New Site Options</h2>
	
		<form action="" method="post" id="manage">
	
			<div>
				<label for="site_folder">New Site Folder:</label>
				<input type="textbox" name="folder" />
			</div>
			<div>
				<label for="site_folder">Site Title:</label>
				<input type="textbox" name="site_title" />
			</div>
			<div>	
				<label for="site_folder">Database Name: <small>No dots!</small></label>
				<input type="textbox" name="database" />	
			</div>
			<div>	
				<label for="site_folder">Domain:</label>
				<input type="textbox" name="domain" /> 
			</div>
			<div>	
				<label for="site_folder">Admin E-mail:</label>
				<input type="textbox" name="email" />
			</div>
			<div>	
				<label for="site_folder">This is a multi-site/network</label>
				<input type="checkbox" name="multisite" />
			</div>
			<div>
				<label for="site_folder">Use subdomains for network</label>
				<input type="checkbox" name="subdomains" />
			</div>
			<div>	
				<label for="site_folder">WordPress Version: <small>(Leave blank for current stable)</small></label>
				<input type="textbox" name="version" />	
			</div>
			<div>
				<label for="submit"></label>
				<input type="submit" name="submit" value="Ceate Site" />
			</div>	
		
			<hr />
		
			<table id="provisioned">
				<thead>
					<tr>
						<th>Path</th><th>Name</th><th>URL</th><th>Database</th><th>Actions</th>
					</tr>
				</thead>
				<tr class="loading"><td collspan="5">Scanning /srv/www for WordPress sites... <span class="time">0</span> seconds.</td></tr>
			</table>
			
		</form>		
		
	</body>
	<html>
<?php


echo ob_get_clean();


