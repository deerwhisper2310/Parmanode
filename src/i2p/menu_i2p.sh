function menu_i2p {
while true ; do
if sudo systemctl status i2p.service >/dev/null 2>&1 ; then 
export i2prunningmenu="\nI2P is$green RUNNING$orange"
else
export i2prunningmenu="\nI2P is$red NOT RUNNING$orange"
fi
set_terminal ; echo -e "
########################################################################################$cyan
                                   I2P Menu$orange
########################################################################################
    $i2prunningmenu
$cyan
                      start)$orange           Start I2P daemon
$cyan
                       stop)$orange           Stop I2P daemon

$pink
    ACCESS:   http://127.0.0.1:7657    
$orange

########################################################################################
"
choose "xpmq" ; read choice
jump $choice
case $choice in q|Q) exit  0 ;; m|M) back2main ;; p|P) return 1 ;;
start)
        clear
        start_i2p
;;
stop)
        clear
        stop_i2p
;;  
*)
invalid
;;
"")
continue
;;
esac
done

}