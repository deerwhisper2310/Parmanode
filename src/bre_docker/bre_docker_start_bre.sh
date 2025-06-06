#this funny function name is to distinguish between bre_docker_start, which
#starts the container, but this function start BRE inside an already
#started container.
function bre_docker_start_bre {

if ! docker ps >$dn 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue
jump $enter_cont
return 1
fi

#start container
if ! docker ps 2>&1 | grep -q bre ; then #is bre container running?
    tmux "
    docker start bre
    docker exec -du parman bre /bin/bash -c 'btc-rpc-explorer'
    "
else
#start program
    tmux "
    docker exec -du parman bre /bin/bash -c 'btc-rpc-explorer'
    "
fi
}