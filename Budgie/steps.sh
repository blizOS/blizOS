#!/bin/bash

# Revision: 2022.10.01
# (GNU/General Public License version 3.0)
# by blizOS

# ----------------------------------------
# Define Variables
# ----------------------------------------

LCLST="en_US"
# Format is language_COUNTRY where language is lower case two letter code
# and country is upper case two letter code, separated with an underscore

KEYMP="us"
# Use lower case two letter country code

KEYMOD="pc105"
# pc105 and pc104 are modern standards, all others need to be researched

MYUSERNM="blizos"
# use all lowercase letters only

MYUSRPASSWD="blizos"
# Pick a password of your choice

RTPASSWD="blizos"
# Pick a root password

MYHOSTNM="blizos"
# Pick a hostname for the machine

# ----------------------------------------
# Functions
# ----------------------------------------

# Test for root user
rootuser () {
  if [[ "$EUID" = 0 ]]; then
    continue
  else
    echo "Please Run As Root"
    sleep 2
    exit
  fi
}

# Display line error
handlerror () {
clear
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
}

# Clean up working directories
cleanup () {
[[ -d ./ezreleng ]] && rm -r ./ezreleng
[[ -d ./work ]] && rm -r ./work
[[ -d ./out ]] && mv ./out ../
sleep 2
}

# Requirements and preparation
prepreqs () {
pacman -S --noconfirm archlinux-keyring
pacman -S --needed --noconfirm archiso mkinitcpio-archiso
}

# Copy ezreleng to working directory
cpezreleng () {
cp -r /usr/share/archiso/configs/releng/ ./ezreleng
rm -rf ./ezreleng/airootfs/etc/pacman.d/hooks
rm -rf ./ezreleng/airootfs/etc/motd
rm -rf ./ezreleng/grub
rm -rf ./ezreleng/efiboot
rm -rf ./ezreleng/syslinux
}

# Remove auto-login, cloud-init, hyper-v, ied, sshd, & vmware services
rmunitsd () {
rm -rf ./ezreleng/airootfs/etc/systemd/system/getty@tty1.service.d
rm -rf ./ezreleng/airootfs/etc/systemd/system/multi-user.target.wants/qemu-guest-agent.service
rm -rf ./ezreleng/airootfs/etc/systemd/system/multi-user.target.wants/hv_fcopy_daemon.service
rm -rf ./ezreleng/airootfs/etc/systemd/system/multi-user.target.wants/hv_kvp_daemon.service
rm -rf ./ezreleng/airootfs/etc/systemd/system/multi-user.target.wants/hv_vss_daemon.service
rm -rf ./ezreleng/airootfs/etc/systemd/system/multi-user.target.wants/vmware-vmblock-fuse.service
rm -rf ./ezreleng/airootfs/etc/systemd/system/multi-user.target.wants/vmtoolsd.service
rm -rf ./ezreleng/airootfs/etc/systemd/system/multi-user.target.wants/sshd.service
rm -rf ./ezreleng/airootfs/etc/systemd/system/multi-user.target.wants/iwd.service
rm -rf ./ezreleng/airootfs/etc/systemd/system/cloud-init.target.wants
}

# Add cups, haveged, NetworkManager, & lightdm systemd links
addnmlinks () {
mkdir -p ./ezreleng/airootfs/etc/systemd/system/network-online.target.wants
mkdir -p ./ezreleng/airootfs/etc/systemd/system/multi-user.target.wants
mkdir -p ./ezreleng/airootfs/etc/systemd/system/printer.target.wants
mkdir -p ./ezreleng/airootfs/etc/systemd/system/sockets.target.wants
mkdir -p ./ezreleng/airootfs/etc/systemd/system/timers.target.wants
mkdir -p ./ezreleng/airootfs/etc/systemd/system/sysinit.target.wants
ln -sf /usr/lib/systemd/system/NetworkManager-wait-online.service ./ezreleng/airootfs/etc/systemd/system/network-online.target.wants/NetworkManager-wait-online.service
ln -sf /usr/lib/systemd/system/NetworkManager-dispatcher.service ./ezreleng/airootfs/etc/systemd/system/dbus-org.freedesktop.nm-dispatcher.service
ln -sf /usr/lib/systemd/system/NetworkManager.service ./ezreleng/airootfs/etc/systemd/system/multi-user.target.wants/NetworkManager.service
ln -sf /usr/lib/systemd/system/haveged.service ./ezreleng/airootfs/etc/systemd/system/sysinit.target.wants/haveged.service
ln -sf /usr/lib/systemd/system/cups.service ./ezreleng/airootfs/etc/systemd/system/printer.target.wants/cups.service
ln -sf /usr/lib/systemd/system/cups.socket ./ezreleng/airootfs/etc/systemd/system/sockets.target.wants/cups.socket
ln -sf /usr/lib/systemd/system/cups.path ./ezreleng/airootfs/etc/systemd/system/multi-user.target.wants/cups.path
ln -sf /usr/lib/systemd/system/lightdm.service ./ezreleng/airootfs/etc/systemd/system/display-manager.service
}

# Copy files to customize the ISO
cpmyfiles () {
cp pacman.conf ./ezreleng/
cp profiledef.sh ./ezreleng/
cp packages.x86_64 ./ezreleng/
cp -r grub ./ezreleng/
cp -r efiboot ./ezreleng/
cp -r syslinux ./ezreleng/
cp -r etc ./ezreleng/airootfs/
cp -r root ./ezreleng/airootfs/
cp -r opt ./ezreleng/airootfs/
cp -r usr ./ezreleng/airootfs/
}

# Set hostname
sethostname () {
echo "${MYHOSTNM}" > ./ezreleng/airootfs/etc/hostname
}

# Create passwd file
crtpasswd () {
echo "root:x:0:0:root:/root:/usr/bin/bash
"${MYUSERNM}":x:1010:1010::/home/"${MYUSERNM}":/bin/bash" > ./ezreleng/airootfs/etc/passwd
}

# Create group file
crtgroup () {
echo "root:x:0:root
sys:x:3:"${MYUSERNM}"
adm:x:4:"${MYUSERNM}"
wheel:x:10:"${MYUSERNM}"
log:x:18:"${MYUSERNM}"
network:x:90:"${MYUSERNM}"
floppy:x:94:"${MYUSERNM}"
scanner:x:96:"${MYUSERNM}"
power:x:98:"${MYUSERNM}"
uucp:x:810:"${MYUSERNM}"
audio:x:820:"${MYUSERNM}"
lp:x:830:"${MYUSERNM}"
rfkill:x:840:"${MYUSERNM}"
video:x:850:"${MYUSERNM}"
storage:x:860:"${MYUSERNM}"
optical:x:870:"${MYUSERNM}"
sambashare:x:880:"${MYUSERNM}"
users:x:985:"${MYUSERNM}"
autologin:x:1000:"${MYUSERNM}"
"${MYUSERNM}":x:1010:" > ./ezreleng/airootfs/etc/group
}

# Create shadow file
crtshadow () {
usr_hash=$(openssl passwd -6 "${MYUSRPASSWD}")
root_hash=$(openssl passwd -6 "${RTPASSWD}")
echo "root:"${root_hash}":14871::::::
"${MYUSERNM}":"${usr_hash}":14871::::::" > ./ezreleng/airootfs/etc/shadow
}

# create gshadow file
crtgshadow () {
echo "root:!*::root
sys:!*::"${MYUSERNM}"
adm:!*::"${MYUSERNM}"
wheel:!*::"${MYUSERNM}"
log:!*::"${MYUSERNM}"
network:!*::"${MYUSERNM}"
floppy:!*::"${MYUSERNM}"
scanner:!*::"${MYUSERNM}"
power:!*::"${MYUSERNM}"
uucp:!*::"${MYUSERNM}"
audio:!*::"${MYUSERNM}"
lp:!*::"${MYUSERNM}"
rfkill:!*::"${MYUSERNM}"
video:!*::"${MYUSERNM}"
storage:!*::"${MYUSERNM}"
optical:!*::"${MYUSERNM}"
sambashare:!*::"${MYUSERNM}"
autologin:!::"${MYUSERNM}"
"${MYUSERNM}":!*::" > ./ezreleng/airootfs/etc/gshadow
}

# Set the keyboard layout
setkeylayout () {
echo "KEYMAP="${KEYMP}"" > ./ezreleng/airootfs/etc/vconsole.conf
}

# Create 00-keyboard.conf file
crtkeyboard () {
mkdir -p ./ezreleng/airootfs/etc/X11/xorg.conf.d
echo "Section \"InputClass\"
        Identifier \"system-keyboard\"
        MatchIsKeyboard \"on\"
        Option \"XkbLayout\" \""${KEYMP}"\"
        Option \"XkbModel\" \""${KEYMOD}"\"
EndSection" > ./ezreleng/airootfs/etc/X11/xorg.conf.d/00-keyboard.conf
}

# Fix 40-locale-gen.hook and create locale.conf
crtlocalec () {
sed -i "s/en_US/"${LCLST}"/g" ./ezreleng/airootfs/etc/pacman.d/hooks/40-locale-gen.hook
echo "LANG="${LCLST}".UTF-8" > ./ezreleng/airootfs/etc/locale.conf
}

# Start mkarchiso
runmkarchiso () {
mkarchiso -v -w ./work -o ./out ./ezreleng
}

# ----------------------------------------
# Run Functions
# ----------------------------------------

rootuser
handlerror
prepreqs
cleanup
cpezreleng
addnmlinks
rmunitsd
cpmyfiles
sethostname
crtpasswd
crtgroup
crtshadow
crtgshadow
setkeylayout
crtkeyboard
crtlocalec
runmkarchiso


# Disclaimer:
#
# THIS SOFTWARE IS PROVIDED BY BLIZOS “AS IS” AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
# EVENT SHALL EZNIX BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# END
#
