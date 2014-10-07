<?php

ob_start();

if ( isset( $_POST['action'] ) ) {
	
	switch ( $_POST['action'] ) {
		
		
		case 'get_site_info':
			$command = './../scripts/vvv-all-sites-info.rb';
			$results = shell_exec( $command );
			echo $results;
		break;
		
		
		
		
		
		
		
		
		
		
	}
	
	
	
}



echo ob_get_clean();