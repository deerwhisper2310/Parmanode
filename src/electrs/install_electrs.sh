function install_electrs {

grep -q "bitcoin-end" < "$HOME/.parmanode/installed.conf" >/dev/null || { announce "Must install Bitcoin first. Aborting." && return 1 ; }
if ! which nginx ; then install_nginx || { announce "Trying to first install Nginx, something went wrong." \
"Aborting" ; } 
fi

unset electrs_compile && restore_elctrs #get electrs_compile true/false

[[ $electrs_compile == "false" ]] && please_wait && rm -rf $HOME/parmanode/electrs/ && mkdir $HOME/parmanode/electrs/ \
&& cp -r $HOME/.electrs_backup/* $HOME/parmanode/electrs/
installed_config_add "electrs-start"
if [[ $electrs_compile == "true" ]] ; then
preamble_install_electrs || return 1
build_dependencies_electrs && log "electrs" "build_dependencies success" 
download_electrs && log "electrs" "download_electrs success" ; debug "download electrs done"
compile_electrs && log "electrs" "compile_electrs success" ; debug "build, download, compile... done"
fi

#remove old certs (in case they were copied from backup), then make new certs
rm $HOME/parmanode/electrs/*.pem  
{ make_ssl_certificates "electrs" && debug "check certs error " ; } || announce "SSL certificate generation failed. Proceed with caution." ; debug "ssl certs done"
electrs_nginx add

# check Bitcoin settings
unset rpcuser rpcpassword prune server
source $HOME/.bitcoin/bitcoin.conf >/dev/null
check_pruning_off || return 1
check_server_1 || return 1
check_rpc_bitcoin

#prepare drives
choose_and_prepare_drive_parmanode "Electrs" && log "electrs" "choose and prepare drive function borrowed"

source $HOME/.parmanode/parmanode.conf >/dev/null
debug "check ext drive directories before proceeding"
if [[ $drive_electrs == "external" && $drive == "external" || $drive_fulcrum == "external" ]] ; then 
    # format not needed
    # check if there is a backup electrs_db on the drive and restore it
      restore_elctrs_drive # check export electrum_db_restore=true, and modify prepare_drive_electrs function later.
      debug "restore variable - $electrs_db_restore"
else
format_ext_drive "electrs" || return 1
fi

prepare_drive_electrs || { log "electrs" "prepare_drive_electrs failed" ; return 1 ; } ; debug "prepare drive done"


#config
make_electrs_config && log "electrs" "config done" ; debug "config done"

make_electrs_service || log "electrs" "service file failed" ; debug "service file done"

installed_config_add "electrs-end" ; debug "finished electrs install"

success "electrs" "being installed"

if [[ $electrs_compile == "true" ]] ; then
backup_electrs
fi

}

########################################################################################

function install_cargo {

announce "You may soon see a prompt to install Cargo. Choose \"1\" to continue" \
"the installation"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs/ | sh 
source $HOME/.cargo/env #or restart shell
debug "install cargo function end"
}

function download_electrs {
cd $HOME/parmanode/ && git clone --depth 1 https://github.com/romanz/electrs && installed_config_add "electrs-start"
}

function compile_electrs {
set_terminal ; echo "   Compiling electrs..."
please_wait ; echo ""
cd $HOME/parmanode/electrs && cargo build --locked --release
}

function check_pruning_off {
    if [[ $prune -gt 0 ]] ; then
    announce "Note that Electrs won't work if Bitcoin is pruned. You'll have to" \
    "completely start bitcoin sync again without pruning to use Electrs. Sorry."
    return 1
    else
    return 0
    fi
}

function check_server_1 {
if [[ $server -ne 1 ]] ; then 
announce "\"server=1\" needs to be included in the bitcoin.conf file." \
"Please do that and try again. Aborting." 
return 1 
fi
}


