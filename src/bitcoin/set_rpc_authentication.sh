function set_rpc_authentication {
if [[ $bitcoin == "yolo" ]]
	then export rpcuser=null ; export rpcpassword=null
	return 0 
	fi

while true ; do
set_terminal_bit_higher  

if [[ -z $1 ]] ; then
echo "
########################################################################################

                           Bitcoin Core RPC Authentication

    Remote Procedure Call (RPC) is how other applications (like wallets) connect to 
    Bitcoin Core. The default authentication method is with what's caled a COOKIE 
    FILE Stored in the Bitcoin data directory. 
	
    Some software (eg Fulcrum or Electrum Server) requires the alternative way, 
    which is with a USERNAME and PASSWORD, rather than a cookie file. 
	
	For convenience, you can set a username and password here.

	Note, this password doesn't need to be incredibly secure, and do also bear in 
    mind that it will be stored on the computer in clear text insie the bitcoin.conf
	file and other configuration files. Therefore, don't use highly sensitive
	passwords that you might use for other things.


       (s)     Set the Bitcoin username and password (edits bitcoin.conf)

       (L)     Leave Bitcoin username and password unchanged 

       (c)     Use cookie ...(deletes from bitcoin.conf; Won't work with Fulcrum) 

       (p)     Exit this menu (set username/pass from menu later)


########################################################################################

"
choose "xpq" ; read choice
else
choice=$1
fi

case $choice in
    s|S)
	            password_changer
				 
	            stop_bitcoind  
                set_rpc_authentication_update_conf_edits #defined below

				add_userpass_to_fulcrum 
				#(extracted from bitcoin.conf)	
				#checks if fulcrum installed, otherwise returns
				
				export btc_authentication="user/pass" >/dev/null
				parmanode_conf_remove "btc_authentication" && parmanode_conf_add "btc_authentication=$btc_authentication"

				sleep 1 
				echo "Starting Bitcoin"
				run_bitcoind

                break
		        ;;
		
	l|L) 
				add_userpass_to_fulcrum
				break
				;;
	c)
	            stop_bitcoind
                delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcuser" && unset rpcuser
                delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcpassword" && unset rpcpassword

				export btc_authentication="cookie"
				parmanode_conf_remove "btc_authentication" && parmanode_conf_add "btc_authentication=$btc_authentication"

				sleep 1
				run_bitcoind 
				return 1 #important for testing if user/pass set
		;;	

	p|P) return 1 ;; #important for testing if user/pass set

	q|Q|Quit|QUIT) exit 0 ;;

	*)
		invalid
		;;	
esac

done
return 0
}

function set_rpc_authentication_update_conf_edits {

	delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcuser" >/dev/null 2>&1
	delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcpassword" >/dev/null 2>&1
	echo "rpcuser=$rpcuser" >> $HOME/.bitcoin/bitcoin.conf 2>&1
	echo "rpcpassword=$rpcpassword" >> $HOME/.bitcoin/bitcoin.conf 2>&1
	parmanode_conf_add "rpcuser=$rpcuser"
	parmanode_conf_add "rpcpassword=$rpcpassword"

set_terminal

run_bitcoind

}

function add_userpass_to_fulcrum {

source $HOME/.parmanode/parmanode.conf >/dev/null 2>&1

	if cat $HOME/.parmanode/installed.conf | grep -q "fulcrum-end" ; then
		true
	else
		return 1
	fi

	if [[ $OS == "Mac" ]] ; then edit_user_pass_fulcrum_docker ; return 0 ; fi

	if [[ $OS == "Linux" ]] ; then
					delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "rpcuser"
					delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "rpcpassword"
					echo "rpcuser = $rpcuser" >> $HOME/parmanode/fulcrum/fulcrum.conf
					echo "rpcpassword = $rpcpassword" >> $HOME/parmanode/fulcrum/fulcrum.conf
					return 0
					fi

}