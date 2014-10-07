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
  
  if /\-\-database/.match( a )
    val = a.dup
    val.sub! '--database=', ''    
    val.sub! '--database', ''
    site['database'] = val
  end
  
end

# ---------------------------------------------
# Bail if options are not set
# ---------------------------------------------
unless site['path'].length > 0 
  STDOUT.puts "\n\n ~~~\t[RIP]\t~~~"
  STDOUT.puts "SCRIPT KILLED"
  STDOUT.puts "You need a valid WP path"
  STDOUT.puts " ~~~\t x.x\t~~~\n\n"
end

wp_path = File.file?( File.join( site['path'], 'wp-config.php' ) ) ? site['path'] : '';

if wp_path.length > 0 
  
  if site['database'].length > 0 
    result = `wp db drop --yes --path=#{site['path']}`
    
    if /Success/.match( result )
      return_message = "#{site['database']} successfully dropped."
    end
  end
  
  `rm -rf #{site['path']}`
  
  return_message = "#{return_message}\nFolder #{site['path']} removed."
  
end

puts return_message