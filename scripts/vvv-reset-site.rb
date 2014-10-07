#!/usr/bin/env ruby 

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

# ---------------------------------------------
# Site hash
# ---------------------------------------------
site = Hash.new

return_message = ''

# ---------------------------------------------
# Get options from command line arguments
# ---------------------------------------------
ARGV.to_enum.with_index(1).each do|a, i|

  if /\-\-path/.match( a )
    val = a.dup
    val.sub! '--path=', ''
    val.sub! '--path', ''
    site['path'] = val
  end
  
  if /\-\-email/.match( a )
    val = a.dup
    val.sub! '--email=', ''    
    val.sub! '--email', ''
    site['email'] = val
  end
  
  if /\-\-title/.match( a )
    val = a.dup
    val.sub! '--title=', ''    
    val.sub! '--title', ''
    site['title'] = val
  end

  if /\-\-url/.match( a )
    val = a.dup
    val.sub! '--url=', ''    
    val.sub! '--url', ''
    site['url'] = val
  end
        
end

# ---------------------------------------------
# Bail if options are not set
# ---------------------------------------------
unless site['path'].length > 0 && site['email'].length > 0 && site['title'].length > 0 && site['url'].length > 0 
  STDOUT.puts "\n\n ~~~\t[RIP]\t~~~"
  STDOUT.puts "SCRIPT KILLED"
  STDOUT.puts "Some required arguments are missing."
  STDOUT.puts " ~~~\t x.x\t~~~\n\n"
end

wp_config = File.join( site['path'], 'wp-config.php' )

wp_path = File.file?( wp_config ) ? site['path'] : ''

if wp_path.length > 0 
  
  
  result = `wp db reset --yes --path=#{site['path']}`

  if /Success/.match( result )
    return_message = "Database successfully emptied."
  end

  content = File.open( wp_config ).read()

  if /.*define\(.*MULTISITE.*true.*\)/.match( content )
    result = `wp core multisite-install --url=#{site['url']} --title="#{site['title']}" --admin_user=admin --admin_password=password --admin_email=#{site['email']} --allow-root --path=#{site['path']}`
  else
    result = `wp core install --url=#{site['url']} --title="#{site['title']}" --admin_user=admin --admin_password=password --admin_email=#{site['email']} --allow-root --path=#{site['path']}`
  end
  
  if /Success/.match( result )
    return_message = "#{return_message}\n\"#{site['title']}\" successfully reinstalled."
  end
  
end

puts return_message