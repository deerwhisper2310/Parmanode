function ParmanodL_cleanup {

# stop and remove docker container

    if [[ $OS == Mac ]] ; then
        if docker ps -a | grep -q ParmanodL ; then docker stop ParmanodL >/dev/null 2>&1 ; docker rm ParmanodL >/dev/null 2>&1 ; fi
    fi

# unmount image

    sudo umount -f ${disk}* >/dev/null 2>&1

# Remove temporary directories

    sudo rm -rf /tmp/mnt

while true ; do
set_terminal ; echo "
########################################################################################

    Do you want the zip and image files deleted off your computer? - They're big files
    and you can save some space.

                                   y   or   n 

########################################################################################
"
choice "x" ; read choice 

case $choice in 
y|Y|YES|yes|Yes) 
   rm -rf $HOME/ParmanodL 
   return 0
   ;;
n|N|No|NO|no)
   return 0
   ;;
*)
   invalid
   ;;
esac
done


return 0

}