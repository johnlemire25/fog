#!/bin/bash
##

yum update -y
yum install firewalld -y
systemctl start firewalld
systemctl enable firewalld
for service in http https tftp ftp mysql nfs mountd rpc-bind proxy-dhcp samba; do firewall-cmd --permanent --zone=public --add-service=$service; 
done

echo "Open UDP port 49152 through 65532, the possible used ports for fog multicast" 
firewall-cmd --permanent --add-port=49152-65532/udp
echo "Allow IGMP traffic for multicast"
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -p igmp -j ACCEPT
systemctl restart firewalld.service
echo "Done."

sed -i.bak 's/^.*\SELINUX=enforcing\b.*$/SELINUX=permissive/' /etc/selinux/config

setenforce 0

yum install git -y
cd ~
mkdir git
cd git
git clone https://github.com/FOGProject/fogproject.git
~/fogproject/bin/installfog.sh
echo "Now you should have fog installed."
