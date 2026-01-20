premiumize-rclone-mounter

A lightweight, automated solution to mount your Premiumize.me cloud storage as a local drive on Linux. 

This project bridges the gap between cloud storage and your local media players (VLC, MPV, Kodi), allowing you to stream files directly without downloading them first.

🚀 Features:

One-Line Installation: Fully automated setup of rclone, API configuration, and system integration.Desktop Toggle: A "Cloud Drive" icon on your desktop to instantly mount/unmount with a single click.

VFS Optimized: Pre-configured with optimal caching (10GB) and read-ahead buffers for smooth 4K video playback.Background Service: Uses systemd to manage the mount, ensuring it stays active and auto-resumes after a reboot.Native Notifications: 

System alerts keep you informed when the drive is ready or disconnected.

🛠️ Prerequisites:

Before you begin, you need to have rclone and fuse installed. 

Use the command for your distribution:

Ubuntu / Debian
sudo apt update && sudo apt install rclone fuse3 -y

Fedora 
sudo dnf install rclone fuse3

Arch Linux
sudo pacman -S rclone fuse3

⚙️ Quick Start

1. Installation: Open your terminal and run the following command to set up the mount and the desktop shortcut:

Bash

curl -sSL https://raw.githubusercontent.com/700zx1/premiumize-rclone-mounter/main/install.sh | bash

2. Post-Install: (GNOME Users)  If you are using the GNOME desktop environment, you will see the Premiumize Cloud icon appear on your desktop. Right-click the icon.Select "Allow Launching" to enable the shortcut.

📂 How to Use

Mounting: Double-click the Premiumize Cloud icon on your desktop. A notification will confirm the drive is ready.

Browsing: Open your File Manager and navigate to ~/Premiumize.Streaming: Right-click any video file and select Open with VLC.

Unmounting: Double-click the icon again to safely disconnect the cloud drive.

🗑️ Uninstallation:

To remove the background service, the desktop shortcut, and the rclone configuration, run:

Bash

curl -sSL https://raw.githubusercontent.com/700zx1/premiumize-rclone-mounter/main/uninstall.sh | bash

⚙️ Customization

You can fine-tune the streaming performance by editing the service file:

nano ~/.config/systemd/user/premiumize-mount.service

Cache Size: Change --vfs-cache-max-size 10G to fit your available disk space.

Read Ahead: Increase --vfs-read-ahead if you have a very fast fiber connection but encounter buffering on large 4K files. 

Contributing: Feel free to open issues or submit pull requests to improve the caching logic or support more desktop environments.

Disclaimer: This project is not officially affiliated with Premiumize.me.
