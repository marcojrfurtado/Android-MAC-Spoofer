############## Begin - Initial setup ###############################
# Has to to be run as root
#su

# Default folders
MAC_SPOOF_DIR="/sdcard/mac-spoof/"
BACKUP_FILE="${MAC_SPOOF_DIR}/.macaddr.original"
TARGET_FILE="/persist/wifi/.macaddr"

# Check if target exists
if ! [ -e "$TARGET_FILE" ];then
	echo "Sorry, MAC-spoofing method not available for your device" >&2
	exit 1
fi

# Check if backup dir exists
if [ -d "$MAC_SPOOF_DIR" ]; then
  mkdir -p $MAC_SPOOF_DIR
fi
############## End - Initial setup ###############################

############## Begin - Function definition ###############################

function backup {
	if ! [ -e "$BACKUP_FILE" ];then
		cp -f $TARGET_FILE $BACKUP_FILE
	fi
}

function restore {
	if ! [ -e "$BACKUP_FILE" ];then
		echo "Backup file has not been found"
		exit 1
	fi	
	cat $BACKUP_FILE > $TARGET_FILE
}

function update {
	NEW_MAC=$1
	
	# Remove improper characters from MAC address
	SANITIZED_MAC=$( echo "$NEW_MAC" | tr '[:lower:]' '[:upper:]' )
	SANITIZED_MAC=$( echo "$SANITIZED_MAC" | tr -cd '[[:xdigit:]]' )
	
	LENGTH=$( echo ${#SANITIZED_MAC})
	
	# Verify if MAC address is correct
	if [ "$LENGTH" -ne 12 ]; then
        echo "MAC address seems to be incorrect. No changes will be made. MAC address must have exactly 12 hexadecimal characters."
		exit 1
	fi
	echo -n $NEW_MAC > $TARGET_FILE
}

############## End - Function definition ###############################

############## Begin - Main procedure ###############################


if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <mode> [new-mac-address]" >&2
  echo "Where mode" >&2
  echo "\t update: Sets MAC address to be equal to 'new-mac-address'" >&2
  echo "\t backup: Backs-up current MAC-address" >&2
  echo "\t restore: Restores original MAC-address" >&2
  echo "\t clean-backup: [DANGEROUS] Cleans backed-up address (cannot be undone)." >&2
  echo "\t show-current: Displays current MAC address." >&2
  echo "\t show-original: Displays backed-up MAC address, in case it exists." >&2
  exit 1
fi

mode=$1

if [[ "$mode" == "backup" ]];then
	backup
	echo "Current MAC address has been backed-up"
	exit 0
elif [[ "$mode" == "update" ]];then
	if [ "$#" -lt 2 ]; then
		echo "Missing MAC address value" >&2
		exit 1
	fi
	backup
	update $2
elif [[ "$mode" == "clean-backup" ]];then
	if [ -e "$BACKUP_FILE" ];then
		rm -f $BACKUP_FILE
	else
		exit 0
	fi	
elif [[ "$mode" == "show-current" ]];then
	cat $TARGET_FILE
	echo
	exit 0
elif [[ "$mode" == "show-original" ]];then
	if [ -e "$BACKUP_FILE" ];then
		cat $BACKUP_FILE
		echo
	else
		echo "Backup has not been performed yet."
	fi
	exit 0
elif [[ "$mode" == "restore" ]];then
	restore
fi	

echo "Changes have been made. Device needs to be rebooted for them to take effect."
exit 0

############## End - Main procedure ###############################


