#!/usr/bin/env ruby 

require 'open3'
require 'json'

# Author: Rheinard Korf
# 
# Usage:
#
# License: License: GPLv2  
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

path = "/srv/www/"

sites = Hash.new

count = -1
Dir.entries( path ).select do |entry, i| 
  
  full_path = File.join( path, entry )
  
  if File.directory? full_path and !(entry =='.' || entry == '..')
  
    wp_path = ''
  
    # Look for htdocs first
    htdocs = File.join( full_path, 'htdocs' )
    
    if File.directory? htdocs
      wp_path = File.file?( File.join( htdocs, 'wp-config.php' ) ) ? htdocs : ''
    # Ok, not dealing with htdocs
    else
      wp_path = File.file?( File.join( full_path, 'wp-config.php' ) ) ? full_path : ''
    end
  
    # If dealing with a configured WP site...
    if wp_path.length > 0
      count += 1
      
      # WP Path
      sites[count] = Hash.new
      sites[count]['path'] = wp_path
      
      # Get the database name and other info from DB
      o, e, s = Open3.capture3("wp db query \"select database() from dual\" --path=\"#{wp_path}\"")
      # Only if there were no errors
      if e.length <= 0
        db_name = o.gsub(/(.*database\(\).*|\|\s*)|\n/, '' )
        # Get options
        o1, e1, s1 = Open3.capture3("wp db query \"select option_name, option_value from wp_options where option_name IN('blogname','siteurl', 'admin_email')\" --path=\"#{wp_path}\"")
        # Only if there were no errors
        if e1.length <= 0
          site_name = o1.gsub(/(http:\/\/|https:\/\/)/, '' )
          site_name = site_name.gsub(/option_.*\n/, '' )
        
          blog_name = site_name.gsub(/siteurl.*\n|admin_email.*\n|blogname/, '' ).strip!
          site_url = site_name.gsub(/blogname.*\n|admin_email.*\n|siteurl/, '' ).strip!
          admin_email = site_name.gsub(/blogname.*\n|siteurl.*\n|admin_email/, '' ).strip!
          sites[count]['title'] = blog_name
          sites[count]['url'] = site_url
          sites[count]['database'] = db_name
          sites[count]['email'] = admin_email
        end

      end
      
    end
    
  end
    
end

# Output sites
puts sites.to_json
