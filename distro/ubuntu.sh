# This is a default distribution plug-in.
# Do not modify this file as your changes will be overwritten on next update.
# If you want customize installation, please make a copy.
DISTRO_NAME="Ubuntu (focal)"

TARBALL_URL['aarch64']="https://github.com/termux/proot-distro/releases/download/v2.2.0/ubuntu-aarch64-pd-v2.2.0.tar.xz"
TARBALL_SHA256['aarch64']="486de37668963c1b6a0d131e33b91486be8eb1919b0813ad03726885753feba6"

distro_setup() {
	# Don't update gvfs-daemons and udisks2
	run_proot_cmd apt-mark hold gvfs-daemons udisks2
}