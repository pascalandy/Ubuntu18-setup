#!/usr/bin/env bash
set -eou

# Initial Software
sudo apt update && sudo apt upgrade -y

# Ubuntu (GNOME) 18.04 setup script.
dpkg -l | grep -qw gdebi || sudo apt-get install -yyq gdebi

sudo apt-get install -yy \
  apt-transport-https curl htop git \
  virtualbox virtualbox-guest-additions-iso virtualbox-ext-pack \
  net-tools mc flatpak gnome-tweak-tool qt5-style-plugins spell synaptic \
  openssh-server sshfs gedit-plugin-text-size nano \
  ubuntu-restricted-extras gthumb gnome-tweaks \
  gimp mpv vlc audacity lame simplescreenrecorder

# install Brave
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
source /etc/os-release
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/brave-browser-release-${UBUNTU_CODENAME}.list
sudo apt update
sudo apt install brave-browser

# Add me to any groups I might need to be a part of:
sudo adduser $USER vboxusers

# Remove undesirable packages:
sudo apt purge gstreamer1.0-fluendo-mp3 deja-dup shotwell -yy
# removing "whoopsie" "whoopsie-preferences" crash the setting!

## Remove junk
sudo apt-get remove ubuntu-web-launchers thunderbird rhythmbox -y

# Remove snaps and get packages from apt:
sudo snap remove gnome-characters gnome-calculator gnome-system-monitor && \
sudo apt install gnome-characters gnome-calculator gnome-system-monitor \
  gnome-software-plugin-flatpak -yy

# Don't notify me
gsettings set com.ubuntu.update-notifier show-livepatch-status-icon false
#set icons to minimize on click
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'

## Disable Apport
sudo sed -i 's/enabled=1/enabled=0/g' /etc/default/apport

# clean up
sudo apt-get update -qy && \
apt-get upgrade -qy && \
apt-get autoclean -qy && \
apt-get autoremove -qy && \
apt-get clean -qy && \
apt-get purge -qy

# end / reboot
echo $'\n'$"*** All done! Please reboot now. ***"
reboot
