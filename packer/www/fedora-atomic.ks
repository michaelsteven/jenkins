install
reboot
lang en_US.UTF-8
keyboard us
timezone --utc America/Chicago
selinux --enforcing
zerombr
clearpart --all --initlabel
bootloader --location=mbr --boot-drive=sda
reqpart --add-boot
#part /boot --size=300 --fstype="ext4" --ondisk=sda
part pv.01 --grow --ondisk=sda
volgroup atomicos pv.01
logvol / --size=57000 --fstype="xfs" --name=root --vgname=atomicos
logvol swap --fstype swap --name=lv_swap --vgname=atomicos --size=2048
services --enabled="systemd-timesyncd" --enabled="sshd"
ostreesetup --osname="fedora-atomic" --remote="fedora-atomic-26" --url="file:///ostree/repo" --ref="fedora/26/x86_64/atomic-host" --nogpg
#network --device=link --bootproto=static --ip=192.168.1.101 --netmask=255.255.255.0 --hostname=node1.projectatomic.rocks --gateway=192.168.1.1 --nameserver=192.168.1.100
rootpw --iscrypted $6$iob1rEnM6BTD2v9Z$OgSIy3JZ0.N1c0xO9dIdvqiuyGFistscqneGnaWu6K5e9FftL.QR/V4LVYkLTFx7lZzmEoPIeEev5ZvTHonsU1
user --groups=wheel --name=devuser --password=$6$Gsw7kxe9ndMW6y.P$qP.n9BUa8.FrOB2RXzdBlGsEB9dSsJ.8q8w7R3UeoJ5xS8omPXRle0r1t63eFPEXDobbx40Rs/2coV0/CGzmB1 --iscrypted --gecos="devuser"


%post --erroronfail

echo "devuser  ALL=(ALL)   NOPASSWD:ALL" >> /etc/sudoers.d/devuser

rm -f /etc/ostree/remotes.d/fedora-atomic.conf

ostree remote add --if-not-exists --set=gpgkeypath=/etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-26-primary fedora-atomic-26 https://kojipkgs.fedoraproject.org/atomic/26

echo -e "\nSTORAGE_DRIVER='overlay2'\nCONTAINER_ROOT_LV_MOUNT_PATH=''\n" >> /etc/sysconfig/docker-storage-setup

# Override udev net-rules
mkdir -p /etc/udev/rules.d/60-net.rules

# Add ^?"net.ifnames=0" and "biosdevname=0"
sed -i -e 's/quiet/net.ifnames=0 biosdevname=0 quiet/' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

# Clear out bad ifcfg scripts
rm -f /etc/sysconfig/network-scripts/ifcfg-e*

# Turn off requiretty for sudo
sed -i -e 's/requiretty/!requiretty/' /etc/sudoers
%end