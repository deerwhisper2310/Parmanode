function verify_ledger {

if [[ $OS == Mac ]] ; then
brew_check "Ledger Suite" || return 1
if ! which openssl >$dn ; then brew install openssl ; fi
fi
pem=$HOME/parman_programs/parmanode/src/ledger/ledgerlive.pem
sig=$HOME/parman_programs/parmanode/src/ledger/ledger-live-desktop-$ledger_version.sha512sum.sig
shasum=$HOME/parman_programs/parmanode/src/ledger/ledger-live-desktop-$ledger_version.sha512sum
if ! openssl dgst -sha256 -verify $pem -signature $sig $shasum ; then
announce "Verification failed. Aborting." 
return 1
else
short_announce "Verification$green PASSED$orange." "5"
fi

#Regular shasum --check not possible because Ledger fucked up the spacing in the SHA file
#Resorting to manual checking.
if [[ $OS == Mac ]] ; then
sha_ledger_result=$(shasum -a 512 ledger*dmg | awk '{print $1}')
sha_check=$(grep '.dmg' $shasum | awk '{print $1}') >$dn
fi

if [[ $OS == Linux ]] ; then
sha_ledger_result=$(shasum -a 512 ledger*AppImage | awk '{print $1}')
sha_check=$(grep 'AppImage' $shasum | awk '{print $1}') >$dn
fi

if [[ $sha_check == $sha_ledger_result ]] ; then
short_announce "SHA512 test$green PASSED$orange." "5"
else
announce "SHA512 test$red FAILD. Aborting$orange."
return 1
fi

}