function menu_rtl {

while true ; do 
unset tor_message ONION_ADDR_RTL

if grep -q "rtl_tor" < $dp/parmanode.conf ; then
get_onion_address_variable rtl
tor_message="      RTL Onion Address:$bright_blue

            $ONION_ADDR_RTL:7005 $orange
                  "
fi 

set_terminal 
echo -e "
########################################################################################
                                 $cyan   RTL Menu     $orange 
########################################################################################
"
if docker ps | grep -q rtl ; then echo -e "
                                 RTL is$green RUNNING$orange" 
else 
echo -e "
                                 RTL is$red NOT RUNNING$orange"
fi

if ! ps -x | grep lnd | grep bin >/dev/null 2>&1  && ! docker ps | grep -q lnd ; then echo -e "$red
                WARNING: LND is not running. RTL won't funciton.$orange" ; fi

echo -e "      


      (start)          Start RTL Docker container

      (stop)           Stop RTL Docker container

      (restart)        Restart RTL Docker container

      (pw)             Password Change

      (lnd)            Reinstall RTL to reconnect with LND (need if LND reset)

      (t)              Enable/Disable RTL access over Tor

      

      The RTL wallet can be accessed in your browser at:
$green
                       http://localhost:3000 
                       http://$IP:3000 $orange

$tor_message
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;

q|Q|QUIT|Quit) exit 0 ;;

p|P) 
if [[ $1 == overview ]] ; then return 0 ; fi
menu_use ;; 

start|Start|START|S|s)
start_rtl
continue
;;

stop|STOP|Stop)
docker stop rtl
continue
;;

restart|RESTART|Restart)
docker stop rtl 
start_rtl
continue
;;

pw|Pw|PW)
rtl_password
continue
;;

lnd|LND|Lnd)
reset_rtl_lnd
continue
;;

t|T|tor|Tor|TOR)
clear
if ! grep -q "rtl_tor" < $dp/parmanode.conf ; then
enable_tor_rtl
else
disable_tor_rtl
fi

;;

*)
invalid
;;

esac
done
}
