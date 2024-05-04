#!/bin/bash

set -e
set -o xtrace

export DEBIAN_FRONTEND=noninteractive

echo root:mackie | chpasswd
rm /root/.not_logged_in_yet
export LANG=C LC_ALL="en_US.UTF-8"

apt-get update
apt-get install xinit

cat <<EOF >~/.profile
#Startx Automatically
if [[ -z "\$DISPLAY" ]] && [[ \$(tty) = /dev/ttyS0 ]]; then
. startx
logout
fi
EOF

echo '* libraries/restart-without-asking boolean true' | debconf-set-selections

cat <<EOF >/etc/default/cpufrequtils
ENABLE=true
MIN_SPEED=1510000
MAX_SPEED=1510000
GOVERNOR=performance
EOF

rm -rf /etc/netplan/*

cat <<EOF >/etc/netplan/eth0.conf
network:
  version: 2
  renderer: networkd
  ethernets:
   eth0:
    dhcp4: yes
EOF

chmod 600 /etc/netplan/eth0.conf

systemctl enable systemd-networkd || true
netplan generate || true

systemctl unmask systemd-networkd
systemctl start  systemd-networkd 

#systemctl disable armbian-ramlog
#systemctl disable armbian-zram-config
#systemctl disable getty@tty1
systemctl disable armbian-hardware-optimize
#systemctl disable armbian-hardware-monitor
systemctl disable armbian-led-state
systemctl disable cpufrequtils
systemctl disable loadcpufreq
systemctl disable keyboard-setup
systemctl disable apt-daily-upgrade
systemctl disable apt-daily
systemctl disable apt-daily-upgrade.timer
systemctl disable apt-daily.timer
systemctl disable e2scrub_all.timer
systemctl disable fstrim.timer
systemctl disable logrotate.timer
systemctl disable systemd-tmpfiles-clean.timer
systemctl disable e2scrub_reap

#rm -rf /usr/lib/armbian/armbian-hardware-optimization
#rm -rf /usr/lib/armbian/armbian-apt-updates
#rm -rf /usr/lib/armbian/armbian-hardware-monitor

rm -rf /etc/cron.d/*
rm -rf /etc/cron.daily/*
rm -rf /etc/cron.hourly/*

sync

apt-get install -f -y

apt-get -y clean

# add development keys for SSH access
mkdir -p /root/.ssh
chmod 700 /root/.ssh
chown root.root /root/.ssh
cat >/root/.ssh/authorized_keys <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQClJsdX5sn1EhGyMxYT+RG/G4LAsn1fkKcb5E7tCmvrZ5rn3i/VPp+3udc8OFCi+Eem11P+uu/Z/F+1nlCWNWICNDngq70gjwzlAJSHTx2qatsdPPk2p/vM/Fnz3WY8B5GcSjVHURrrihLOwZkHNtOERiURmDzreic6i5pJ7nhQ42Y6TNJKVMx6gi80dEEoSM3hZGI2TT8ODehkuxOyR0Nh415evNxb4o0PRzZ6e1PtmTcIbmyJEcUgaXrisPoXv9Iu1YYC+KW/SqzdgajPfdvYnLzmBthbpXLgB88Vx25Cq4kW5w4GpNqW6rbwM0I7Tsgqzj0UuW/DWFP65EcNqUKx7KECP7nc1o1RL/vevbc7kc03DqR0gZY4kBOerrdi6C88ETwMu1ZRfvZl7BEUlDDfRlE5tagTV3nH/KRQxHpTq/d2ZiPuMkfQVpHOATYw21SyhD8m8r8bsdjoUUlPAwy0HvYUiLzzX6H3l27MXjcR4Xn3s0ev3y4yz0nTpLQ06KU= user@user-virtual-machine
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCklKMeigNMxSyl3Ll4vmVrFb+OxmVCoT3F9LfW3mCLGB0TvnBp5bTGkpQQD3IjcUtp9lrb5gKpAMlwXvC8CS3aXBKYpIAM5C9C0Ggfnjd0rRanZM+TDYTBPuiiTTiF9kjj5Pcnnd06kFimE6BtbvtQBGYwHx3Ct8wIlxRFQXrkfLfERmQe7/31dg4fEaOZkrewHnm3aQF85/qEBCyfKjQ0Dep8zm2NDgkCmW6/bVv9YpkeEH3cnKPd3T3FzIzsDeKPiOjx0YLzEw38R+v8WXd10gZJMlziAeBTVOPxJz4euJnELqwwBAkigp4d1RIWQbqwO8eVRxrjauWVr+bmENuxZwCRiEQpaZMrZAZkChKcktfYf/VwuIkrs+p3HwBkPJbUzE5g5xssxc+0TWRfjWuOJPmXEpZMfzRxIr8HEDKejB3zxj79EAe9GEFjc2MAZZYiTtuyu4LK18zFwUthtQFJfmd6wmxL16HZUXwh3cIodM3tkne2gooSyJ5WDjhhvOM= jeffrey@virtual-machine
EOF
chmod 600 /root/.ssh/authorized_keys
chown root.root /root/.ssh/authorized_keys

# Additional setup (development, wifi, etc)
if [ -f /tmp/overlay/setup.sh ]; then
    bash /tmp/overlay/setup.sh
fi
