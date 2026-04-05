#!/usr/bin/env bash
# Mount second disk (sda1, ext4) at /mnt/games via fstab. Run: sudo bash "$0"
set -euo pipefail

UUID="1e3988cf-aa6c-4594-86bc-e21f5bbfeee8"
MOUNT="/mnt/games"
FSTAB_LINE="UUID=${UUID} ${MOUNT} ext4 defaults,nofail 0 2"
TARGET_USER="${SUDO_USER:-kayon}"

if [[ "$(id -u)" -ne 0 ]]; then
	echo "Run with sudo: sudo bash $0" >&2
	exit 1
fi

# Udisks mount (if present)
udisks_path="/run/media/${TARGET_USER}/${UUID}"
if mountpoint -q "$udisks_path" 2>/dev/null; then
	echo "Unmounting $udisks_path ..."
	umount "$udisks_path"
fi

mkdir -p "$MOUNT"

if grep -qF "$UUID" /etc/fstab; then
	echo "fstab already references this UUID; skipping append."
else
	echo "Adding fstab entry ..."
	printf '%s\n' "$FSTAB_LINE" >>/etc/fstab
fi

systemctl daemon-reload
mount "$MOUNT" || mount -a

chown -R "${TARGET_USER}:${TARGET_USER}" "$MOUNT"

echo "Done. $MOUNT is mounted:"
findmnt -n -o SOURCE,TARGET,FSTYPE "$MOUNT"
echo "Add your Steam library folder under ${MOUNT} (e.g. ${MOUNT}/SteamLibrary)."
echo "Flatpak Steam: flatpak override --user --filesystem=${MOUNT} com.valvesoftware.Steam"
