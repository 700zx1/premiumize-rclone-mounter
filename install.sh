#!/bin/bash

# --- Color Definitions ---
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting Premiumize Rclone Auto-Mount Setup...${NC}"

# 1. Check for Dependencies
echo -e "Checking for rclone and fuse3..."
if ! command -v rclone &> /dev/null; then
    echo -e "${RED}rclone not found. Please install it first: sudo apt install rclone${NC}"
    exit 1
fi

if ! command -v fusermount3 &> /dev/null && ! command -v fusermount &> /dev/null; then
    echo -e "${RED}fuse not found. Please install it: sudo apt install fuse3${NC}"
    exit 1
fi

# 2. Get API Key from User
echo -e "${GREEN}You can find your API Key at: https://www.premiumize.me/account${NC}"
read -p "Enter your Premiumize API Key: " API_KEY

if [ -z "$API_KEY" ]; then
    echo -e "${RED}Error: API Key is required.${NC}"
    exit 1
fi

# 3. Create Rclone Config
echo -e "Configuring rclone remote 'premiumize'..."
rclone config create premiumize premiumizeme api_key "$API_KEY" > /dev/null

# 4. Create Mount Directory
MOUNT_DIR="$HOME/Premiumize"
mkdir -p "$MOUNT_DIR"
echo -e "Created mount directory at: $MOUNT_DIR"

# 5. Create Systemd User Service
SERVICE_DIR="$HOME/.config/systemd/user"
mkdir -p "$SERVICE_DIR"

cat <<EOF > "$SERVICE_DIR/premiumize-mount.service"
[Unit]
Description=Rclone Mount Premiumize
After=network-online.target

[Service]
Type=simple
ExecStart=$(which rclone) mount premiumize: $MOUNT_DIR \\
    --vfs-cache-mode full \\
    --vfs-cache-max-size 10G \\
    --vfs-read-chunk-size 64M \\
    --dir-cache-time 1000h \\
    --vfs-read-ahead 256M \\
    --buffer-size 32M
ExecStop=/bin/fusermount -u $MOUNT_DIR
Restart=always
RestartSec=10

[Install]
WantedBy=default.target
EOF

# 6. Enable and Start Service
echo -e "Starting and enabling the background service..."
systemctl --user daemon-reload
systemctl --user enable premiumize-mount.service
systemctl --user start premiumize-mount.service

echo -e "------------------------------------------------"
echo -e "${GREEN}SUCCESS!${NC}"
echo -e "Your Premiumize cloud is now mounted at: ${BLUE}$MOUNT_DIR${NC}"
echo -e "It will automatically mount whenever you log in."
echo -e "------------------------------------------------"

# 7. Setup Icon and Toggle Script
ICON_DIR="$HOME/.local/share/icons"
mkdir -p "$ICON_DIR"
mkdir -p "$HOME/scripts"

# Download the icon
curl -sL -o "$ICON_DIR/premiumize.png" "http://googleusercontent.com/image_collection/image_retrieval/6141867185786353807_0"

# Create the Toggle Script
cat <<'EOF' > "$HOME/scripts/toggle_premiumize.sh"
#!/bin/bash
MOUNT_DIR="$HOME/Premiumize"
# Check if mounted
if mountpoint -q "$MOUNT_DIR"; then
    systemctl --user stop premiumize-mount.service
    notify-send -i "premiumize" "Premiumize" "Cloud Drive Unmounted"
else
    systemctl --user start premiumize-mount.service
    # Small delay to allow mount to register
    sleep 1
    if mountpoint -q "$MOUNT_DIR"; then
        notify-send -i "premiumize" "Premiumize" "Cloud Drive Mounted & Ready"
    else
        notify-send -u critical "Premiumize" "Mount Failed! Check rclone config."
    fi
fi
EOF
chmod +x "$HOME/scripts/toggle_premiumize.sh"

# 8. Create the Desktop Entry
DESKTOP_FILE="$HOME/Desktop/Premiumize.desktop"
cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Version=1.0
Type=Application
Name=Premiumize Cloud
Comment=Toggle Premiumize Rclone Mount
Exec=$HOME/scripts/toggle_premiumize.sh
Icon=$ICON_DIR/premiumize.png
Terminal=false
Categories=Network;FileTransfer;
EOF

# Make the desktop file executable
chmod +x "$DESKTOP_FILE"
