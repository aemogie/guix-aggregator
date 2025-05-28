#!/usr/bin/env sh

USERNAME=$(whoami)
HOSTNAME=$(hostname)
RESTIC_REPOSITORY="rclone:proton:backups/$HOSTNAME"
RESTIC_PASSWORD="$(pass show restic)"
LOG_FILE="/home/$USERNAME/backup.log"

# Exclude patterns
EXCLUDED_PATTERNS="
    --exclude '.cache/**' 
    --exclude '.local/share/Trash/**' 
    --exclude '.thumbnails/**' 
    --exclude '*.iso' 
    --exclude '*.tmp'
"

export RESTIC_REPOSITORY
export RESTIC_PASSWORD

echo "$(date): Starting Google Drive sync" | tee -a "$LOG_FILE"

# Sync using rclone with excluded patterns
rclone sync -vv --progress /home/$USERNAME/Documents gdrive:/Backups/$USERNAME/Documents $EXCLUDED_PATTERNS | tee -a "$LOG_FILE"
rclone sync -vv --progress /home/$USERNAME/Documents proton:/backups/$USERNAME/Documents $EXCLUDED_PATTERNS | tee -a "$LOG_FILE"
rclone sync -vv --progress /home/$USERNAME/Downloads proton:/backups/$HOSTNAME/Downloads $EXCLUDED_PATTERNS | tee -a "$LOG_FILE"

echo "$(date): Starting Restic backup" | tee -a "$LOG_FILE"

# Backup to Proton Drive using restic with excludes
restic -r "$RESTIC_REPOSITORY" backup -vv \
    /home/"$USERNAME" \
    /etc \
    $EXCLUDED_PATTERNS | tee -a "$LOG_FILE"

echo "$(date): Backup completed" | tee -a "$LOG_FILE"
