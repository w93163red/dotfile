#/bin/sh
# dnf configure
echo "fastestmirror=1" >> /etc/dnf/dnf.conf
echo "max_parallel_downloads=20" >> /etc/dnf/dnf.conf

sudo dnf upgrade --refresh
sudo dnf install dnf-plugin-system-upgrade
sudo dnf system-upgrade download --releasever=37
sudo dnf system-upgrade reboot
