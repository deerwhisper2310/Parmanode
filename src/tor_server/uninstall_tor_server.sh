function unsinstall_tor-server {
    
if ! grep -q "tor-server" ~/.parmanode/installed.conf ; then set_terminal
echo "Tor-server is not installed. Aborting uninstall." 
enter_continue
return 1
fi

delete_line "/etc/tor/torrc" "/var/lib/tor/tor-server"
delete_line "/etc/tor/torrc" "127.0.0.1:7001" 
sudo rm /etc/nginx/conf.d/tor-server.conf >/dev/null
installed_conf_remove "tor-server"

set_terminal
echo "Do you wish to delete the /tor-server directory an all its contents?"
echo "Type \"yolo\" to delete, or anything else to leave it, then <enter>."
read choice
if [[ $choice == "yolo" ]] ; then
    sudo rm -rf /tor-server
fi

set_terminal
echo "Do you wish to uninstall Nginx? \"y\" will uninstal."
read choice
if [[ $choice == "y" ]] ; then
    sudo apt-get purge nginx
fi
}
