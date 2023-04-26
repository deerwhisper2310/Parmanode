function menu_startup {
while true ; do
set_terminal_bit_higher
echo "
########################################################################################

                             P A R M A N O D E - STARTUP MENU 
            

                 (i)         Install/Uninstall ......  (Hint: start here)

                 (r)         Run Parmanode

                 (l)         See logs and configuration files

                 (pp)        Parmanode Premium 

                 (e)         Education

                 (t)         Tools

                 (d)         Donate

                 (a)         About Parmanode


########################################################################################
"
choose "xq"
echo "
(Note, <enter> is the same as <return>)"
read choice

case $choice in

    i)
        menu_install
        ;;

    r|R|R|r)    
        menu_parmanode
        ;;
    l|L) menu_log_config
        ;;
    pp)
        premium
        ;;
    e|E)
        education
        ;;
    t|T)
        PMtools
        ;;
    d|D)
        donations
        ;;
    a|A)
        about
        ;;
    q | Q | quit)
        exit 0
        ;;
    *)
        invalid
	;;

esac

done

return 0
}
