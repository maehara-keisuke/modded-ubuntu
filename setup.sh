#!/bin/bash

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
B="$(printf '\033[1;34m')"
C="$(printf '\033[1;36m')"
W="$(printf '\033[1;37m')" 

banner() {
    clear
    printf "\033[33m    _  _ ___  _  _ _  _ ___ _  _    _  _ ____ ___  \033[0m\n"
    printf "\033[36m    |  | |__] |  | |\ |  |  |  |    |\/| |  | |  \ \033[0m\n"
    printf "\033[32m    |__| |__] |__| | \|  |  |__|    |  | |__| |__/ \033[0m\n"
    printf "\033[0m\n"
    printf "     \033[32mA modded gui version of ubuntu for Termux\033[0m\n"
    printf "\033[0m\n"

}

package() {
    echo -e "${R} [${W}-${R}]${C} Checking required packages..."${W}
    termux-setup-storage
    if [[ `command -v pulseaudio` && `command -v proot-distro` && `command -v wget` ]]; then
        echo -e "\n${R} [${W}-${R}]${G} Packages already installed."${W}
    else
        packs=(pulseaudio proot-distro wget)
        for hulu in "${packs[@]}"; do
            type -p "$hulu" &>/dev/null || {
                echo -e "\n${R} [${W}-${R}]${G} Installing package : ${Y}$hulu${C}"${W}
                apt update -y
                apt upgrade -y
                apt install "$hulu" -y
            }
        done
    fi
}

distro() {
    echo -e "\n${R} [${W}-${R}]${C} Checking for Distro..."${W}
    termux-reload-settings
    
    if [[ -d "$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu" ]]; then
        echo -e "\n${R} [${W}-${R}]${G} Distro already installed."${W}
        exit 0
    else
        sed -e 's|https://github.com/termux/proot-distro/releases/download/v2.3.1/ubuntu-aarch64-pd-v2.3.1.tar.xz|https://github.com/termux/proot-distro/releases/download/v2.2.0/ubuntu-aarch64-pd-v2.2.0.tar.xz|g' /data/data/com.termux/files/usr/etc/proot-distro/ubuntu.sh
        sed -e 's|599a0af87b110a9eab9f6f84b43243e497a73403397aeddb0d0b3cdb4ea54aa6|486de37668963c1b6a0d131e33b91486be8eb1919b0813ad03726885753feba6|g' /data/data/com.termux/files/usr/etc/proot-distro/ubuntu.sh
        proot-distro install ubuntu
        termux-reload-settings
    fi
    
    if [[ -d "$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu" ]]; then
        echo -e "\n${R} [${W}-${R}]${G} Installed Successfully !!"${W}
    else
        echo -e "\n${R} [${W}-${R}]${G} Error Installing Distro !\n"${W}
        exit 0
    fi
}

sound() {
    echo -e "\n${R} [${W}-${R}]${C} Fixing Sound Problem..."${W}
    if [[ ! -e "$HOME/.bashrc" ]]; then
        touch $HOME/.bashrc
    fi
    
    echo "pulseaudio --start --exit-idle-time=-1" >> $HOME/.bashrc
    echo "pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" >> $HOME/.bashrc
}

permission() {
    banner
    echo -e "${R} [${W}-${R}]${C} Setting up Environment..."${W}

    if [[ -e "$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu/root/user.sh" ]]; then
        chmod +x $PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu/root/user.sh
    else
        wget https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/user.sh
        mv -f user.sh $PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu/root/user.sh
        chmod +x $PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu/root/user.sh
    fi
    
    echo "proot-distro login ubuntu" > $PREFIX/bin/ubuntu

    if [[ -e "$PREFIX/bin/ubuntu" ]]; then
        chmod +x $PREFIX/bin/ubuntu
        termux-reload-settings
        banner
        echo -e "\n${R} [${W}-${R}]${G} Ubuntu-20.04.3(CLI) is now Installed on your Termux"${W}
        echo -e "\n${R} [${W}-${R}]${G} Restart your Termux to Prevent Some Issues."${W}
        echo -e "\n${R} [${W}-${R}]${G} Type ${C}ubuntu${G} to run Ubuntu CLI."${W}
        echo -e "\n${R} [${W}-${R}]${G} If you Want to Use UBUNTU in GUI MODE then ,"${W}
        echo -e "\n${R} [${W}-${R}]${G} Run ${C}ubuntu${G} first & then type ${C}bash user.sh "${W}
        echo -e "\n"
        exit 0
    else
        echo -e "\n${R} [${W}-${R}]${G} Error Installing Distro !"${W}
        exit 0
        fi
}

banner
package
distro
sound
permission
