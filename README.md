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
    vagrant up  

----- 

Enjoy!
