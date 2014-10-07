vvv-manage-sites
================

Scripts to help manage WordPress sites on VVV

Most of my scripts are in `ruby`, but I might add the odd surprise.

**Changes**  

You can run the scripts directly from commandline, see below, OR, you can checkout this project in a vagrant site. Navigating to your site in the browser and using this folder will run the 'wizard-esque' form giving you a more friendly way to create a site.  

---------------------------------------------  

**Adding to your vvv.dev site**  

Navigate to your `<vagrant-path>/www/default` folder and checkout the project.

    git clone https://github.com/rheinardkorf/vvv-manage-sites.git manage-sites  

Add a new hyperlink inside `<vagrant-path>/www/default/index.php`. You could change the navigation list to include the new link. For example:  

    <ul class="nav">
    	<li class="active"><a href="#">Home</a></li>
    	<li><a href="https://github.com/varying-vagrant-vagrants/vvv/">Repository</a></li>
    	<li><a href="database-admin/">phpMyAdmin</a></li>
    	<li><a href="memcached-admin/">phpMemcachedAdmin</a></li>
    	<li><a href="opcache-status/opcache.php">Opcache Status</a></li>
    	<li><a href="webgrind/">Webgrind</a></li>
    	<li><a href="phpinfo/">PHP Info</a></li>
    	<li><a href="manage-sites/">Manage Sites</a></li> <!-- NEW -->
    </ul>

Now navigating to vvv.dev you will have a new way to add new WordPress sites.

-----  

**vvv-new-single.rb**  
Creates the [VVV Auto Site Setup](https://github.com/Varying-Vagrant-Vagrants/VVV/wiki/Auto-site-Setup) files to provision a new WordPress single site.  Check out VVV wiki (previous link) for more information.

You can clone the repo onto your VVV box and run this script from commandline, inside the VM.  

    vagrant up
    vagrant ssh  
    git clone https://github.com/rheinardkorf/vvv-manage-sites.git  
    cd vvv-manage-sites/scripts  
    ./vvv-new-single.rb  
    exit  
    vagrant provision  
    vagrant halt  
    vagrant up  

-----  

**vvv-new-site.rb**  
Creates the [VVV Auto Site Setup](https://github.com/Varying-Vagrant-Vagrants/VVV/wiki/Auto-site-Setup) files to provision a new WordPress site.  The main difference is that this script will allow you to choose if you want to **install a network site**, and if you want to use a sub-domain network setup (over a sub-directory setup).  

When creating a network with subdomains this script will also create and activate a network plugin called VVV Host Update. This plugin will add your new network sites to vvv-hosts. This means that, if you have vagrant-hostsupdater installed, your new sites will automatically be added to the hosts file on your local machine - upon vagrant up/resume/reload.

You can clone the repo onto your VVV box and run this script from commandline, inside the VM.  

    vagrant up
    vagrant ssh  
    git clone https://github.com/rheinardkorf/vvv-manage-sites.git  
    cd vvv-manage-sites/scripts  
    ./vvv-new-site.rb  
    exit  
    vagrant provision  
    vagrant halt  
    vagrant up  

When running for the first time, look out for the helpful hint at the end :)

----- 

Enjoy!
