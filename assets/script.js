//
// function confirm_kill( e ) {
// 	c = confirm('This will remove the site and drop the database. Are you sure you want to do this?');
//
// 	if ( c ) {
// 	} else {
// 		e.preventDefault();
// 		e.stopPropagation();
// 	}
// }
//
// function confirm_reset( e ) {
// 	c = confirm('This will wipe all data and reset the installation. Are you sure you want to do this?');
//
// 	if ( c ) {
// 	} else {
// 		e.preventDefault();
// 		e.stopPropagation();
// 	}
// }


jQuery(document).ready(function( $ ){


	setInterval(function () {
		$('span.time').text(  parseInt( $('span.time').text() ) + 1 );
    }, 1000);

	$.ajax({ 
        type:'post',
        url:'assets/script_loader.php',
        data:{
        	'action': 'get_site_info',
        },
        dataType:'json',
        success: function(rs)
        {
			count = -1;
			
			$('tr.loading').remove();
			
			$.each( rs, function( key, site ) {
				count += 1;
				
				css_class = (count + 1) % 2 == 0 ? 'even' : 'odd';
				exists = typeof( site.title ) !== 'undefined' ? true : false;
				
				html = '<tr class="' + css_class + '">';
				html += '<td>' + site.path + '</td>';
				if ( exists ) {
					html += '<td>' + site.title + '</td>';
					html += '<td><a href="http://' + site.url + '">' + site.url + '</a></td>';
					html += '<td>' + site.database + '</td>';
				} else {
					html += '<td>Database not found.</td><td></td><td></td>';
				}
				
				html += '<td>';

					// We still need something to work with...
					html += '<input type="hidden" name="path[' + count + ']" value="' + site.path + '" />'
					
					if ( exists ) {
						html += '<input type="submit" name="reset[' + count + ']" value="Reset DB" />';
						
						// These are only available if a database is populated...
						html += '<input type="hidden" name="title[' + count + ']" value="' + site.title + '" />'
						html += '<input type="hidden" name="url[' + count + ']" value="' + site.url + '" />'
						html += '<input type="hidden" name="database[' + count + ']" value="' + site.database + '" />'
						html += '<input type="hidden" name="email[' + count + ']" value="' + site.email + '" />'

					}
				
					html += '<input type="submit" name="kill[' + count + ']" value="Kill Site" />';
				

				
					html += '</td>';
					
				html += '</tr>';
				
				
				$('table#provisioned').append( html );				
				
			});
			
			$('[name^="kill"]').click( function( e ) {
				c = confirm('This will remove the site and drop the database. Are you sure you want to do this?');

				if ( c ) {		
				} else {
					e.preventDefault();
					e.stopPropagation();			
				}					
			});

			$('[name^="reset"]').click( function( e ) {
				c = confirm('This will wipe all data and reset the installation. Are you sure you want to do this?');

				if ( c ) {		
				} else {
					e.preventDefault();
					e.stopPropagation();			
				}					
			});
			
        },
        failure : function(rs)
        {
        	
        },
    });

}); 