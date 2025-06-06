function connect_wallet_info {
while true
do
set_terminal 38 110
echo -e "
##############################################################################################################
                                    
            $cyan                        Bitcoin Wallet Connection Info$orange

    To connect your wallet, you need to first wait for the Bitcoin blockchain to finish syncing. You can 
    inspect the debug.log file (access from Parmanode Bitcoin menu) to check its progress in real 
    time. Any errors with Bitcoin will show up here as well.
$cyan
                            s)$orange          Sparrow Bitcoin Wallet
$cyan
                            e)$orange          Electrum Desktop Wallet
$cyan
                            sd)$orange         Specter Desktop Wallet

##############################################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
set_terminal 38 110
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;; 

    s|S)
    sparrow_wallet_info
    ;;

    e|E)
    electrum_wallet_info
    ;;

    sd|SD|sD|Sd)
    specter_wallet_info
    ;;

    *)
    invalid
    break
    ;;

esac
done
return 0
}



function sparrow_wallet_info {
set_terminal 38 110
echo -e "
##############################################################################################################
$cyan
                                           SPARROW BITCOIN WALLET
$orange
    Unfortunately, for now, this wallet needs to be on the same computer as the Parmanode software if you
    want Parmanode to magically connect it to your node.
     
    In the Sparrow Server settings, use$cyan 127.0.0.1$orange as the IP address and$cyan 8332$orange as the port (Parmanode has
    actualy autoconfigured it for you). 

    For easy configuration, use the options in the Parmanode Sparrow menu to make a connection choice.

##############################################################################################################

"
enter_continue ; jump $enter_cont
return 0
}

function electrum_wallet_info {
set_terminal 50 110
echo -e "
##############################################################################################################
$cyan
                                       ELECTRUM DESKTOP WALLET
$orange
    Note that a connection with Electrum Wallet is not possible until Fulcrum Server or electrs server
    is installed.
$green
    Parmanode will connect your wallet to your sever automagically, but if you have Electrum installed 
    without the help of Parmanode, this is the method...
$orange
    Once a server is installed (and synchronised), you can connect to it from your Electrum Wallet with the
    following steps:
$cyan
        1)$orange Go to Electrum Network settings (from menu or the circle on the bottom right)
$cyan	
        2)$orange Uncheck 'Select server automatically'
$cyan	
        3)$orange Type the IP address of the computer that runs Parmanode.
        
                You can find this by typing$cyan 'ifconfig | grep broadcast'$orange in your terminal window. 
                You'll see it as one of the outputs. Typically something like$cyan 192.168.0.150$orange
                If you don't have ifconfig, you can install it, or use$green 'ip a'$orange as a replacement.
                Parmanode will also tell you your IP address (see tools menu).
$cyan
        4)$orange If the wallet and Parmanode are on the same computer, you can type either
            ${green}localhost$orange or$green 127.0.0.1$orange for the IP address.
$cyan	    
        5)$orange If your wallet is NOT on the same computer as Parmanode, you need to type the IP address
           of the Parmanode computer in your wallet.
$cyan
        6)$orange You also MUST type in the port AND connection type. 
           The default value is 50002:s 
           An example would look like:
$cyan
                                         127.0.0.1:50002:s
$cyan
        7)$orange For TCP connections (not SSL), you'd use port 50001, and change the s to a t:
$cyan
                                         127.0.0.1:50001:t
$green
        Note that electrs installed via Parmanode has a different port (to avoid conflicts with Fulcrum). It
        is 50005 for TCP, and 50006 for SSL.
$orange
        At the top of the network settings window, you will see 'connected to x nodes'. If x is not equal
        to 1, you should try to fix that (f). Parmanode will do that automatically if you use it to install
        Electrum, but otherwise, you need to manually edit the Electrum config file, and change 
        'onserver=false' to 'oneserver=true'

##############################################################################################################

Type$cyan (f)$orange for instructions to connect to only one server, or hit$cyan <enter>$orange alone to return.

"
read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; m|M) back2main ;;
f)
electrum_one_server 
;;
esac
return 0

}

function electrum_one_server {
set_terminal 38 110
echo -e "
##############################################################################################################
$cyan
                                  Connect Electrum to One Server Only
$orange
    Unfortunately, this is harder than it needs to be.

    You MUST open a Wallet in Electrum at least once. Even a dummy/discardable wallet will do. This will
    populate a default config file. Then exit Electrum completely. Shut it down.

    Then navigate to $HOME/.electrum

    Open the file$cyan config$orange. You could open via terminal with$cyan nano config$orange.

    Modify the line that has$cyan oneserver$orange in it, from$red false$orange to$green true$orange, and do not change the syntax.

    Save and exit. You can then open Electrum Wallet, check the network settings and see that you are only
    connected to one node.

##############################################################################################################
"
enter_continue ; jump $enter_cont
return 0
}

function specter_wallet_info {
set_terminal 38 110
echo -e "
##############################################################################################################
    $cyan                  
                                        Specter Desktop Wallet:
$orange
    Newer versions of Specter now allow you to connect not only to Bitcoin directly, but to an 
    Electrum (Fulcrum) server as well. 
    
    You need to name the connection to proceed. It's not yet tested, but if it insists on a username and 
    password, you need to modify the bitcoin.conf file (see the Parmanode Bitcoin menu to access) and 
    add it in like this (careful changing the user/password as other programs might depend on it):

$cyan                                  rpcuser=my_user_name $orange (default is 'parman')
                                        
$cyan                                  rpcpassword=my_password $orange (default is 'parman')
    
    If you make changes to the config file, you need to restart Bitcoin for the changes to take effect.

    In Specter Wallet, you'll see$cyan http://localhost $orange- leave as is, but if that doesn't work, try 
$cyan    http://127.0.0.1$orange, then finally, click$pink Connect
$orange

##############################################################################################################
"
enter_continue ; jump $enter_cont
return 0

}
