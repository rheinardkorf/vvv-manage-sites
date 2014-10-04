#!/usr/bin/env ruby 

# Author: Rheinard Korf
# 
# Usage:
# Run from command line using ./vvv-new-single.rb
#
# Optionally, pass the following arguments:  
#
# --folder        e.g. --folder"newsite"
# --site_title    e.g. --site_title"My Awesome Site"
# --database      e.g. --database"database1"
# --domain        e.g. --domain"test.dev"
# --email         e.g. --email"me@myprovider.com"
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
# Asuming a normal VVV instance, change if needed
# ---------------------------------------------
server_root = "/srv/www/"

# ---------------------------------------------
# Options hash for new site
# ---------------------------------------------
options = Hash.new

# ---------------------------------------------
# Get options from command line arguments
# ---------------------------------------------
ARGV.to_enum.with_index(1).each do|a, i|

  if /\-\-folder/.match( a )
    val = a.dup
    val.sub! '--folder=', ''
    val.sub! '--folder', ''
    options['folder'] = val
  end
  
  if /\-\-site\_title/.match( a )
    val = a.dup
    val.sub! '--site_title=', ''    
    val.sub! '--site_title', ''
    options['site_title'] = val
  end

  if /\-\-domain/.match( a )
    val = a.dup
    val.sub! '--domain=', ''    
    val.sub! '--domain', ''
    options['domain'] = val
  end  
  
  if /\-\-database/.match( a )
    val = a.dup
    val.sub! '--database=', ''    
    val.sub! '--database', ''
    options['database'] = val
  end    
  
  if /\-\-email/.match( a )
    val = a.dup
    val.sub! '--email=', ''    
    val.sub! '--email', ''
    options['email'] = val
  end  
  
end

# ---------------------------------------------
# Fill in the gaps for arguments not provided
# ---------------------------------------------
unless options.has_key?('folder') && options.has_key?('site_title') && options.has_key?('domain') && options.has_key?('database')

  if ! options.has_key?('folder')
    STDOUT.print "New folder in \"#{server_root}\" (e.g. 'newsite'): "
    STDOUT.flush
    options['folder'] = STDIN.gets.chomp
  end

  if ! options.has_key?('site_title')
    STDOUT.print "Site Title (e.g. 'My Awesome Site'): "
    STDOUT.flush
    options['site_title'] = STDIN.gets.chomp
  end
  
  if ! options.has_key?('database')
    STDOUT.print "Database (e.g. 'database1'): "
    STDOUT.flush
    options['database'] = STDIN.gets.chomp
  end

  if ! options.has_key?('domain')
    STDOUT.print "Domain (e.g. 'test.dev'): "
    STDOUT.flush
    options['domain'] = STDIN.gets.chomp
  end
  
  if ! options.has_key?('email')
    STDOUT.print "Admin Email: "
    STDOUT.flush
    email = STDIN.gets.chomp
    if email.length > 0
      options['email'] = email
    end
  end  

  puts "\n--------------------------------------------------------"
  puts "NEXT TIME..."
  puts "Try using this script with the following arguments:"
  puts "--folder\te.g. --folder\"newsite\""  
  puts "--site_title\te.g. --site_title\"My Awesome Site\""
  puts "--database\te.g. --database\"database1\""
  puts "--domain\te.g. --domain\"test.dev\""
  puts "--email\t\te.g. --email\"me@myprovider.com\""
  puts "--------------------------------------------------------\n\n"  

end

# ---------------------------------------------
# Bail if options are not set
# ---------------------------------------------
unless options['folder'].length > 0 && options['site_title'].length > 0 && options['database'].length > 0 && options['domain'].length > 0
  STDOUT.puts "\n\n ~~~\t[RIP]\t~~~"
  STDOUT.puts "SCRIPT KILLED"
  STDOUT.puts "You need values for 'folder', 'site_title', 'database' and 'domain'."
  STDOUT.puts " ~~~\t x.x\t~~~\n\n"
end


# ---------------------------------------------
# Create the folder path if it does not exist
# ---------------------------------------------
dirname = "#{server_root}#{options['folder']}/"

tokens = dirname.split("/")

1.upto( tokens.size - 1 ) do |n|
  dir = tokens[0..n]
  dir = dir.join("/")
  Dir.mkdir(dir) unless Dir.exist?(dir)
end

# ---------------------------------------------
# Create vvv-init.sh
# ---------------------------------------------
# This file will get current stable WP core;
# Create the new database;
# Create wp-config.php with debugging flags;
# Run the WP install so you don't have to.
# ---------------------------------------------
f = File.new( "#{server_root}#{options['folder']}/vvv-init.sh", "w" )

f.puts "echo \"Setting up: '#{options['site_title']}'\";"
f.puts "echo \"Creating #{options['database']} (if it doesn't exist)\""
f.puts "mysql -u root --password=root -e \"CREATE DATABASE IF NOT EXISTS #{options['database']}\""
f.puts "mysql -u root --password=root -e \"GRANT ALL PRIVILEGES ON #{options['database']}.* TO wp@localhost IDENTIFIED BY 'wp';\""
f.puts "if [ ! -d htdocs ]"
f.puts "then"
f.puts "    echo \"Checking out WordPress\""
f.puts "    wp core download --path=htdocs"
f.puts "    cd htdocs"
f.puts "    wp core config --dbname=\"#{options['database']}\" --dbuser=wp --dbpass=wp --dbhost=\"localhost\" --allow-root --extra-php <<PHP"
f.puts "    // Enable WP_DEBUG mode"
f.puts "    define('WP_DEBUG', true);"
f.puts ""
f.puts "    // Enable Debug logging to the /wp-content/debug.log file"
f.puts "    define('WP_DEBUG_LOG', true);"
f.puts ""
f.puts "    // Disable display of errors and warnings "
f.puts "    define('WP_DEBUG_DISPLAY', false);"
f.puts ""
f.puts "    @ini_set('display_errors',0);"
f.puts ""
f.puts "    // Use dev versions of core JS and CSS file"
f.puts "    define('SCRIPT_DEBUG', true);"
f.puts "PHP"
f.puts "    wp core install --url=#{options['domain']} --title=\"#{options['site_title']}\" --admin_user=admin --admin_password=password --admin_email=#{options['email']} --allow-root"
f.puts "    cd .."
f.puts "else"
f.puts "    echo \"Updating WordPress\""
f.puts "    cd htdocs"
f.puts "    wp core check-update"
f.puts "    cd .."
f.puts "fi"
f.puts "echo \"'#{options['site_title']}' now installed\";"

f.close


# ---------------------------------------------
# Create vvv-nginx.conf
# ---------------------------------------------
# This file sets up the nginx configuration
# ---------------------------------------------
f = File.new( "#{server_root}#{options['folder']}/vvv-nginx.conf", "w" )

f.puts "server {"
f.puts "    # Listen at port 80 for HTTP requests"
f.puts "    listen          80;"
f.puts "    # Listen at port 443 for secure HTTPS requests"
f.puts "    listen          443 ssl;"
f.puts "    # The domain name(s) that the site should answer"
f.puts "    # for. You can use a wildcard here, e.g. "
f.puts "    # *.example.com for a subdomain multisite."
f.puts "    server_name     #{options['domain']};"
f.puts ""
f.puts "    # The folder containing your site files."
f.puts "    # The {vvv_path_to_folder} token gets replaced "
f.puts "    # with the folder containing this, e.g. if this"
f.puts "    # folder is /srv/www/foo/ and you have a root"
f.puts "    # value of `{vvv_path_to_folder}/htdocs` this "
f.puts "    # will be auto-magically transformed to"
f.puts "    # `/srv/www/foo/htdocs`."
f.puts "    root            {vvv_path_to_folder}/htdocs;"
f.puts ""
f.puts "    # A handy set of common Nginx configuration commands"
f.puts "    # for WordPress, maintained by the VVV project."
f.puts "    include         /etc/nginx/nginx-wp-common.conf;"
f.puts "}"

f.close

# ---------------------------------------------
# Create vvv-hosts
# ---------------------------------------------
# Note: For this to work you have to have the
# Vagrant HostUpdated plugin installed
# ---------------------------------------------
f = File.new( "#{server_root}#{options['folder']}/vvv-hosts", "w" )

f.puts "# Your site domain"
f.puts options['domain']

f.close

puts "\n--------------------------------------------------------"
puts "Auto Site Setup files created.\n"
puts "Don't forget to run 'vagrant provision' outside the VM"
puts "to initialize the sites."
puts "--------------------------------------------------------\n\n"