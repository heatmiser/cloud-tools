echo "Executing cleanup.sh..."
yum -y erase gtk2 libX11 hicolor-icon-theme avahi bitstream-vera-fonts
yum -y clean all
rm -rf /var/cache/yum
rm -rf VBoxGuestAdditions_*.iso
