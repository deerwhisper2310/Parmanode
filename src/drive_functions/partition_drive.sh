function partition_drive {

export disk_no_number="${disk%%[0-9]*}"

if [ ! -e "$disk_no_number" ] ; then #eg if /dev/sda doesn't exist
    set_terminal
    echo "Drive $disk does not exist. Exiting."
    enter_continue
    exit 1
fi

# Create a new GPT partition table and a single partition on the drive
# interestingly, you can plonk a redirection in the middle of a heredoc like this:
sudo fdisk "$disk_no_number" <<EOF >/dev/null 
g
n
1


w
EOF

# The above, with <<, is called a heredoc. The text between EOF and EOF is sent
# to fdisk to the left of <<. Except the >/dev/null bit.
# This will send g, enter, n, enter, 1, enter, enter, enter, & w to fdisk
# automating the normally interactive job.

echo "A new GPT partition table and a single partition have been created on $disk_no_number."
}