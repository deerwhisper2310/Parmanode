#Called when turning on TOR in electrum menu. 
#Can be electrs or fulcrum, specified with argument, unless Mac.
#variables set, then finally calls enable_electrum_string_swaps function to do the work
#enable_electrum_string_swaps function declared at the end of file.

function enable_electrum_tor {

if [[ $OS == "Mac" ]] ; then
    set_terminal ; 
    echo "Please paste in the onion address for your Fulcrum/Electrum server you wish to use."
    echo ""
    echo "Note this is not the onion address for your Bitcoin Node. It's for Fulcrum/Electrum."
    echo ""
    echo "You need the long string plus the ending \".onion\". If there is a port number for"
    echo "the address, don't include that. For example:"
    echo ""
    echo "wcyj5idoz7ohlpvmaltoppe1h2nc6j46npghyyls2cqxs7yoquwyjmy4.onion"
    echo ""
    echo "After pasting the address, hit <enter>."
    echo ""

    read o_add && export o_add

    echo "If there is a port number after the onion address, type that in now, otherwise,"
    echo "hit <enter> to leave it blank"
    
    read torport && export torport

    echo "TCP connection is most common for TOR ":t". If you think it needs SSL, type s,"
    echo "otherwise just hit <enter> to leave the default as TCP."

    read choice 
    if [[ $choice == s ]] ; then export TCP_or_SSL=s ; else export TCP_or_SSL=t ; fi

    set_terminal
    echo "Do you use Tor by a browser (b) or daemon (d). Please type your choice, then <enter>."

    read portchoice 

    if [[ $portchoice == "b"  ]] ; then
        export port="9150"
    fi
    if [[ $portchoice == "d"  ]] ; then
        export port="9050"
    fi

    enable_electrum_string_swaps
    return 0
fi

if [[ $1 == "fulcrum" ]] ; then
    #check Fulcrum is running
    if ! ps -x | grep fulcrum | grep conf >$dn 2>&1 ; then
    announce "Fulcrum is not running. The wallet configuration files will be edited," \
    "but you can't connect until you run Fulcrum."
    fi
    
get_onion_address_variable "fulcrum" 
if ! grep -q "fulcrum_tor" $HOME/.parmanode/parmanode.conf ; then
announce "Fulcrum doesn't seem to have Tor turned on. Aborting." && return 1
fi
[ -z $ONION_ADDR_FULCRUM ] && announce "Fulcrum doesn't seem to have Tor turned on. Aborting." && return 1

set_terminal
announce "Make sure Electrum Wallet has been completely shut down before proceeding."
export port=9050
export torport=7002
export o_add=$ONION_ADDR_FULCRUM
export TCP_or_SSL="t"
enable_electrum_string_swaps 
return 0
fi

if [[ $1 == "electrs" ]] ; then
    #check electrs is running
    if ! ps -x | grep electrs | grep conf >$dn 2>&1 && ! docker ps | grep -q electrs ; then 
    announce "Electrs is not running. The wallet configuration files will be edited," \
    "but you can't connect until you run electrs."
    fi
    
get_onion_address_variable "electrs" 
if ! grep -q "electrs_tor" $HOME/.parmanode/parmanode.conf ; then
announce "electrs doesn't seem to have Tor turned on. Aborting." && return 1
fi
[ -z $ONION_ADDR_ELECTRS ] && announce "electrs doesn't seem to have Tor turned on. Aborting." && return 1

set_terminal
announce "Make sure Electrum Wallet has been completely shut down before proceeding."

export port=9050
export torport=7004
export o_add=$ONION_ADDR_ELECTRS
export TCP_or_SSL="t"
enable_electrum_string_swaps
return 0
fi

}

########################################################################################################################
function enable_electrum_string_swaps {
#swap the whole line
nogsedtest
sudo gsed -i "/\"server/c\\    \"server\": \"${o_add}:$torport:$TCP_or_SSL\"," $HOME/.electrum/config 
#delete the line
sudo gsed -i "/proxy/d" $HOME/.electrum/config 
#insert line after
sudo gsed -i "/oneserver/a\\    \"proxy\": \"socks5:127.0.0.1:$port::\"," $HOME/.electrum/config 
}