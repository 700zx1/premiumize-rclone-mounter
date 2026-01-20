#!/bin/bash

# --- Color Definitions ---
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Starting Premiumize Rclone Removal...${NC}"

# 1. Stop and Disable Service
echo -e "Stopping and disabling systemd service..."
systemctl --user stop premiumize-mount.service 2>/dev/null
systemctl --user disable premiumize-mount.service 2>/dev/null

# 2. Remove Service File
echo -e "Removing service file..."
rm -f "$HOME/.config/systemd/user/premiumize-mount.service"
systemctl --user daemon-reload

# 3. Unmount the directory
MOUNT_DIR="$HOME/Premiumize"
echo -e "Unmounting $MOUNT_DIR..."
fusermount -u "$MOUNT_DIR" 2>/dev/null || umount "$MOUNT_DIR" 2>/dev/null

# 4. Remove Rclone Remote
echo -e "Removing rclone remote configuration..."
rclone config delete premiumize 2>/dev/null

echo -e "------------------------------------------------"
echo -e "${GREEN}CLEANUP COMPLETE!${NC}"
echo -e "The mount and service have been removed."
echo -e "Note: The empty folder at $MOUNT_DIR was left intact."
echo -e "------------------------------------------------"
