function parmaraid_info {

set_terminal 48 88 ; echo -e "$blue
########################################################################################
$orange
                                  ParmaRAID
$blue
    RAID stands for Redundant Array of Independent Disks. There are various types, 
    each with their advantages and disadvantages. This Parmanode add-on offers 
    to help you setup either RAID-0 or RAID-1
$green
    RAID-0 $blue
    This allows you to have two dives connected which act as one single drive.
    Handy if you have multiple small drives that can all contribute towards storage
    for a Bitcoin node.
$green
    RAID-1 $blue
    This allows you to have two drives that mirror each other, allowing for
    redundancy and data protection. When mountedn, it will appear that you have one
    drive connected. Each time you modify the contents, the data will be stored
    identically on both disks. If the two drives are different in size, both will
    only be able to store the capacity of the smaller drive.
$green
    RAID-2 to 6 and 10 $blue
    These are less commonly used variations.
$blue
########################################################################################
"
enter_continue
}