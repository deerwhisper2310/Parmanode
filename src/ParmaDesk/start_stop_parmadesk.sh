function start_parmadesk {
    sudo systemctl start vnc.service noVNC.service >$dn 2>&1
}
function stop_parmadesk {
    sudo systemctl stop vnc.service noVNC.service >$dn 2>&1
}
function restart_parmadesk {
    sudo systemctl restart vnc.service noVNC.service >$dn 2>&1
}

