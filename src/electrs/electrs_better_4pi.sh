function electrs_better_4pi {

if [[ $chip == "arm64" || $chip == "aarch64" || $chip == "armv6l" || $chip == "armv7l" ]] ; then
while true ; do
set_terminal
echo -e "
########################################################################################

    It's best for Raspberry Pi's to use electrs instead of Fulcrum

    Continue Fulcrum installation?     

    y     or     n

########################################################################################
"
choose "xpmq"
read choice

case $choice in 
q|Q) exit ;;
p|P) return 1 ;;
m|M) back2main ;;
y|Y) return 0 ;;
n|N) return 1 ;;
*) invalid ;;
esac
done
fi
}