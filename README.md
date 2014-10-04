vvv-scripts
===========

Scripts to help manage WordPress sites on VVV

Most of my scripts are in `ruby`, but I might add the odd surprise.

-----  

**vvv-new-single.rb**  
Creates the [VVV Auto Site Setup](https://github.com/Varying-Vagrant-Vagrants/VVV/wiki/Auto-site-Setup) files to provision a new WordPress single site.  Check out VVV wiki (previous link) for more information.

Clone the repo onto your VVV box and run the script inside the VM.  

    vagrant up
    vagrant ssh  
    git clone https://github.com/rheinardkorf/vvv-scripts.git  
    cd vvv-scripts  
    ./vvv-new-single.rb  
    exit  
    vagrant provision  
    vagrant halt  
    vagrant up  

-----  

**vvv-new-site.rb**  
Creates the [VVV Auto Site Setup](https://github.com/Varying-Vagrant-Vagrants/VVV/wiki/Auto-site-Setup) files to provision a new WordPress site.  The main difference is that this script will allow you to choose if you want to install a network site, and if you want to use a sub-domain network setup (over a sub-directory setup).  

When creating a network with subdomains this script will also create and activate a network plugin called VVV Host Update. This plugin will add your new network sites to vvv-hosts. This means that, if you have vagrant-hostsupdater installed, your new sites will automatically be added to the hosts file on your local machine - upon vagrant up/resume/reload.

Clone the repo onto your VVV box and run the script inside the VM.  

    vagrant up
    vagrant ssh  
    git clone https://github.com/rheinardkorf/vvv-scripts.git  
    cd vvv-scripts  
    ./vvv-new-site.rb  
    exit  
    vagrant provision  
    vagrant halt  
    vagrant up  

When running for the first time, look out for the helpful hint at the end :)

----- 

Enjoy!
