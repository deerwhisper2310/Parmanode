function run_thub_docker {
docker run -d --name thunderhub -p $thub_port:3000/tcp \
                                     -v $hp/thunderhub/account_1.yaml:/app/account_1.yaml \
                                     -v $hp/thunderhub/.env.local:/app/.env.local \
                                     -v $HOME/.lnd/data/chain/bitcoin/mainnet/admin.macaroon:$HOME/.lnd/data/chain/bitcoin/mainnet/admin.macaroon \
                                     -v $HOME/.lnd/tls.cert:$HOME/.lnd/tls.cert \
                                     thunderhub || runfailed=true
echo "pausing to see if run command successful"
enter_continue
if [[ $runfailed == true ]] ; then 
announce "Something went wrong. Aborting."
unset runfailed ; return 1 ; fi
}