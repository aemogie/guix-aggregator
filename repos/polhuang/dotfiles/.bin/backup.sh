#!/usr/bin/env sh

USERNAME=$(whoami)
HOSTNAME=$(hostname)
RESTIC_REPOSITORY="rclone:proton:backups/$HOSTNAME"
LOG_FILE="/home/$USERNAME/backup.log"

export RESTIC_REPOSITORY

echo "$(date): Starting Google Drive sync" | tee -a "$LOG_FILE"

# sync using rclone with excludes
rclone sync -vv -P /home/$USERNAME/Documents gdrive:/Backups/$HOSTNAME/Documents \
       --exclude "*.tmp" | tee -a "$LOG_FILE"

echo "$(date): Starting Restic backup" | tee -a "$LOG_FILE"

# backup to proton drive using restic with excludes
restic -r "$RESTIC_REPOSITORY" \
       --password-file ~/.restic_password \
       backup -vv /home/"$USERNAME" \
       --exclude ".cache/**" \
       --exclude "**/*[Cc]ache*/**" \
       --exclude ".local/share/**" \
       --exclude "**.lock" \
       --exclude ".thumbnails/**" \
       --exclude "**/.DS_Store" \
       --exclude "*.iso" \
       --exclude "*.tmp" \
       --exclude ".config/discord/**" \
       --exclude ".config/BraveSoftware/**" \
       --exclude ".config/Cursor/**" \
       --exclude ".config/google-chrome/**" \
       --exclude ".config/libreoffice/**" \
       --exclude ".config/Slack/**" \
       --exclude ".config/Windsurf/**" \
       --exclude ".npm/**" \
       --exclude ".mozilla/**" \
       --exclude ".zoom/**" \
       --exclude ".rustup/**" \
       --exclude ".cargo/**" \
       --exclude ".cursor/**" \
       /etc \
echo "$(date): Backup completed" | tee -a "$LOG_FILE"
