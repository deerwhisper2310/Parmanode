function bre_docker_run {

docker run -d --name bre \
     -v $HOME/parmanode/bre:/home/parman/parmanode/bre \
     --network="host" \
     bre
}