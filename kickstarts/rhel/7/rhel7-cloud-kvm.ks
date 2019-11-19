# Kickstart for provisioning a RHEL 7 KVM VM
#version=RHEL7

# System authorization information
auth --enableshadow --passalgo=sha512

# Use text mode install
text
# Firewall configuration
firewall --disabled

# Do not run the Setup Agent on first boot
firstboot --disable

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=link
network  --hostname=localhost.localdomain

# Root password
rootpw changeme
#rootpw --plaintext "somepassword"
# Root password
#rootpw --iscrypted HarTSZDmT7X/Y

# System services
services --enabled="sshd,dnsmasq,NetworkManager,chronyd"

# System timezone
timezone Etc/UTC --isUtc --ntpservers 0.rhel.pool.ntp.org,1.rhel.pool.ntp.org,2.rhel.pool.ntp.org,3.rhel.pool.ntp.org

# Partition clearing information
clearpart --all --initlabel

# Clear the MBR
zerombr

# Disk partitioning information
part /boot --fstype="xfs" --size=250
part / --fstype="xfs" --size=1 --grow --asprimary

# System bootloader configuration
bootloader --location=mbr

# Firewall configuration
firewall --disabled

# Enable SELinux
selinux --enforcing

# Don't configure X
skipx

# Accept the eula
eula --agreed

# Reboot the machine after successful installation
reboot --eject

%packages
@base
@console-internet
chrony
sudo
parted
deltarpm
openssh-clients
-dracut-config-rescue

%end

%post --log=/var/log/anaconda/post-install.log

#!/bin/bash

# Enable SSH keepalive
sed -i 's/^#\(ClientAliveInterval\).*$/\1 180/g' /etc/ssh/sshd_config

## Configure network
cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
ONBOOT=yes
BOOTPROTO=dhcp
TYPE=Ethernet
USERCTL=no
PEERDNS=yes
IPV6INIT=no
NM_CONTROLLED=no
EOF

cat << EOF > /etc/sysconfig/network
NETWORKING=yes
HOSTNAME=localhost.localdomain
EOF

systemctl enable network

tuned-adm profile virtual-guest
%end

%addon com_redhat_kdump --disable --reserve-mb='auto'

%end
