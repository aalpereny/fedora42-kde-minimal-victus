#!/bin/env bash
if ! [ $(id -u) = 0 ]; then
  echo "This script must be run as sudo or root, try again..."
  exit 1
fi

dnf update --refresh

##### ENABLE RPM-FUSION #####
dnf install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf config-manager setopt fedora-cisco-openh264.enabled=1

##### TUXEDO CONTROL CENTER REPO #####
sudo tee /etc/yum.repos.d/tuxedo.repo > /dev/null <<EOF
[tuxedo]
name=tuxedo
baseurl=https://rpm.tuxedocomputers.com/fedora/42/x86_64/base
enabled=1
gpgcheck=1
gpgkey=https://rpm.tuxedocomputers.com/fedora/42/0x54840598.pub.asc
skip_if_unavailable=False
EOF
cat /etc/yum.repos.d/tuxedo.repo
wget https://rpm.tuxedocomputers.com/fedora/42/0x54840598.pub.asc
rpm --import 0x54840598.pub.asc

##### ENABLE COPR-HEROIC #####
dnf copr enable atim/heroic-games-launcher

##### INSTALL PACKAGES #####
dnf install \
  @"base-x" \
  bluedevil \
  breeze-gtk \
  breeze-icon-theme \
  colord-kde \
  cups-pk-helper \
  dolphin \
  glibc-all-langpacks \
  gnome-keyring-pam \
  kcm_systemd \
  kde-gtk-config \
  kde-partitionmanager \
  kde-print-manager \
  kde-settings-pulseaudio \
  kde-style-breeze \
  kdegraphics-thumbnailers \
  kdeplasma-addons \
  kdialog \
  kdnssd \
  kf5-akonadi-server \
  kf5-akonadi-server-mysql \
  kf5-kipi-plugins \
  kmenuedit \
  konsole5 \
  kscreen \
  kscreenlocker \
  ksshaskpass \
  kwalletmanager5 \
  kwebkitpart \
  kwin \
  NetworkManager-config-connectivity-fedora \
  pam-kwallet \
  phonon-qt5-backend-gstreamer \
  pinentry-qt \
  plasma-breeze \
  plasma-desktop \
  plasma-desktop-doc \
  plasma-drkonqi \
  plasma-nm \
  plasma-nm-l2tp \
  plasma-nm-openconnect \
  plasma-nm-openswan \
  plasma-nm-openvpn \
  plasma-nm-pptp \
  plasma-nm-vpnc \
  plasma-pa \
  plasma-user-manager \
  plasma-workspace \
  plasma-workspace-geolocation \
  polkit-kde \
  qt5-qtbase-gui \
  qt5-qtdeclarative \
  sddm \
  sddm-breeze \
  sddm-kcm \
  setroubleshoot \
  sni-qt \
  xorg-x11-drv-libinput \
  mesa-va-drivers \
  mesa-vdpau-drivers \
  libva-utils \
  vdpauinfo \
  amdsmi \
  akmod-nvidia \
  steam \
  heroic-games-launcher-bin \
  plasma-pk-updates \
  plasma-discover \
  spectacle \
  gwenview \
  kcalc \
  ark \
  kate \
  tuxedo-control-center \
  goverlay \
  mangohud \

##### NVIDIA MODUL WAIT #####
while true; do
    version=$(modinfo -F version nvidia 2>/dev/null)

    if [[ -n "$version" ]]; then
        echo "NVIDIA module: $version"
        break
    else
        echo "NVIDIA module is not loaded yet. Waiting..."
        sleep 2
    fi
done

##### SET USER PERMS #####
usermod -aG render,video $USER

##### HYBIRD GPU-APPLET #####
dnf copr enable sunwire/envycontrol
dnf install python3-envycontrol
plymouth-set-default-theme -R bgrt

