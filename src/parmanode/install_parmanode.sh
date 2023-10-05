function install_parmanode {

set_terminal

# the check below is redundant because the menu no longer allows a "re-install", but it's left here
# in case a bug causes an issue in the future.

install_check "parmanode" #checks parmanode.conf, and exits if already installed.
    if [ $? == 1 ] ; then return 1 ; fi #error mesages done in install_check, this ensures code exits to menu
    # $? is a variable of the error code of the command that was run immediately before. This variable is set
    # after every command is run. 0 indicates success and a non zero number indicates failure.
    # by sending a return 1 and exiting this function, then nested functions can send an error signal
    # all the way up the chain of functions.

# a counter to see how many times the program is installed...
curl -s https://parman.org/downloadable/parmanode_${version}_install_parmanode_counter >/dev/null 2>&1 &

# a self explanatory custom function
update_computer 

if [[ $OS == "Mac" ]] ; then 

	brew_check  # brew needs to be installed for parmanode to work on macs
	if [ $? == 1 ] ; then return 1 ; fi   

    greadlink_check  # For macs, this function is needed for text manipulation functions I'll be making.
        
fi

#Test for necessary functions
sudo_check # needed for preparing drives etc.
gpg_check  # needed to download programs from github
curl_check # needed to download things using the command prompt rather than a browser.
make_dot_parmanode # creates a hidden configuration directory for parmanode.

make_home_parmanode  # creates the directory that holds all the apps' directories installed by parmanode.
    if [ $? == 1 ] ; then return 1 ; fi #exiting this function with return 1 takes user to menu.
        
# Update config files
    installed_config_add "parmanode-end" # This syntax, -start and -end, helps identifiy installations
    #that have started vs installations that have completed.



set_terminal ; echo "
########################################################################################
    
                                 S U C C E S S  ! ! 
                                      				    
    Parmanode has been installed. 
    
    You can now go to the \"add\" menu to install the prgrams you want, 
    eg Bitcoin Core and many others.

########################################################################################
"
enter_continue
return 0
}


