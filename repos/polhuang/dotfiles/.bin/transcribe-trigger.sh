#!/usr/bin/env sh

# trigger script called by udev when IC recorder is connected
# this script runs as root, so we need to switch to  user context

USER="pol"
PROJECT_DIR="/home/pol/projects/voice-transcribe"
PYTHON_BIN="/home/pol/projects/voice-transcribe/venv/bin/python3"
CONFIG_FILE="/home/pol/projects/voice-transcribe/config.yaml"
LOG_FILE="/home/pol/.local/share/voice-transcribe/udev-trigger.log"

# wait for the source directory to be available
SOURCE_DIR="/run/media/pol/IC RECORDER/REC_FILE/1 - Journal/"
MAX_WAIT=60
WAITED=0

echo "[$(date)] Waiting for source directory..." >> "$LOG_FILE"

while [ ! -d "$SOURCE_DIR" ] && [ $WAITED -lt $MAX_WAIT ]; do
    sleep 1
    WAITED=$((WAITED + 1))
done

if [ ! -d "$SOURCE_DIR" ]; then
    echo "[$(date)] ERROR: Source directory never appeared after ${MAX_WAIT}s" >> "$LOG_FILE"
    exit 1
fi

# wait an additional 2 seconds for the mount to stabilize
sleep 2

# log the trigger
echo "[$(date)] IC Recorder detected and mounted, triggering transcription scan" >> "$LOG_FILE"

# run the transcription script as the user (not root)
# set LD_LIBRARY_PATH for CUDA support
su "$USER" -c "export LD_LIBRARY_PATH=/opt/cuda/lib64:\$LD_LIBRARY_PATH && cd $PROJECT_DIR && $PYTHON_BIN transcribe.py -c $CONFIG_FILE" >> "$LOG_FILE" 2>&1

echo "[$(date)] Transcription scan completed" >> "$LOG_FILE"
