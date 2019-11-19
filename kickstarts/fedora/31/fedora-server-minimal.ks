# Minimal Disk Image
#
sshpw --username=root --plaintext randOmStrinGhERE
# Firewall configuration
firewall --enabled
# Use network installation
url --url="https://dl.fedoraproject.org/pub/fedora/linux/releases/31/Server/x86_64/os/"
# Network information
network  --bootproto=dhcp --device=link --activate

# Root password
rootpw --plaintext removethispw
# System keyboard
keyboard --xlayouts=us --vckeymap=us
# System language
lang en_US.UTF-8
# SELinux configuration
selinux --enforcing
# Installation logging level
logging --level=info
# Reboot after installation
reboot --eject
# System timezone
timezone Etc/UTC --isUtc --ntpservers 0.fedora.pool.ntp.org,1.fedora.pool.ntp.org,2.fedora.pool.ntp.org,3.fedora.pool.ntp.org
# System services
services --enabled="sshd,chronyd"
# System bootloader configuration
bootloader --location=mbr
# Partition clearing information
clearpart --all --initlabel
# Disk partitioning information
reqpart
# Disk partitioning information
part /boot --fstype="xfs" --size=250
part / --fstype="xfs" --size=1 --grow --asprimary

%post --log=/var/log/anaconda/post-install.log

#!/bin/bash

# Enable SSH keepalive
sed -i 's/^#\(ClientAliveInterval\).*$/\1 180/g' /etc/ssh/sshd_config

systemctl enable network

tuned-adm profile virtual-guest

#### additional scripts pulled and executed here

%end

%packages
@core
kernel
# Make sure that DNF doesn't pull in debug kernel to satisfy kmod() requires
kernel-modules
kernel-modules-extra

grub2-efi
grub2
shim
syslinux
@console-internet
chrony
sudo
parted
deltarpm
openssh-clients
-dracut-config-rescue

# dracut needs these included
dracut-network
tar
%end
