#!/bin/bash
# Copyright 2014 Clustertech Limited. All rights reserved.
# Clustertech Cloud Management Platform.
#
# Author: Dong LIN (dlin@clustertech.com)

# This script is used to help the ccmp cloud server to configure the environment
# automatically at boot. This script should be copied as the /root/ccmp.sh file
# of the cloud server.

CCMP_DNS_SERVER_IP=192.168.3.250

# Restart the network in case the bug in ubuntu startup didn't config the
# network devices properly.
/etc/init.d/networking stop
/etc/init.d/networking start 2>&1 | logger

# Start a http server for distributing rootfs to resource nodes when they boot.
# This implements http://bug.clustertech.com/redmine/issues/12490.
screen -dm sh -c "cd /home/tftpboot/casper/; busybox httpd -p 9999"

# Update the owner and group of the folder /home/tftpboot/casper.
# If we don't do this, we'll encounter errors like "vmlinuz.centos not found"
# when carrying out network boot of resource nodes.
chown -R dnsmasq:nogroup /home/tftpboot/casper

# Restore database if necessary
if [ -f /root/mysql.sql ]; then
  mysql -uroot -proot < /root/mysql.sql
  mv /root/mysql.sql /root/sql.bak
fi

echo "# Stopping drbd ..."
/etc/init.d/drbd stop 2>&1
echo "# Stopping keepalived ..."
/etc/init.d/keepalived stop 2>&1

echo "# Starting nfs-kernel-server ..."
service nfs-kernel-server restart 2>&1

echo "# Updating DNS forwarder IP to $GW"
GW=$(ip route show default 2>/dev/null | grep default | head -n1 | awk '{print $3}')
Br0IP=$(ip  -f inet addr show br0 | tail -n1 | grep -o '\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}/' | sed -e 's/\///')
Eth1IP=$(ip  -f inet addr show eth1 | tail -n1 | grep -o '\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}/' | sed -e 's/\///')
echo "nameserver 127.0.0.1" >/etc/resolv.conf
echo "nameserver $CCMP_DNS_SERVER_IP" >>/etc/resolv.conf

echo "# Enabling firewall ... "
/sbin/iptables -P FORWARD ACCEPT
/sbin/iptables --table nat -A POSTROUTING -o eth1 -j MASQUERADE
# Prevent user guest from accessing unauthorized network
Uid=$(id -u guest)
/sbin/iptables -A OUTPUT -o eth1 -m owner --uid-owner $Uid  -j DROP
/sbin/iptables -A OUTPUT -d $Br0IP/24 -m owner --uid-owner $Uid  -j DROP

# Enable port 123 for UDP to accept NTP requests from clients
# Ref: https://docs.google.com/a/clustertech.com/document/d/1oM0f2aw9-qfKJT1EsrvRQI2LEk8yfXeKf48-6CCJJQc/edit
/sbin/iptables -t filter -A INPUT -p udp --dport 123 -j ACCEPT

# Protect $Br0IP/24 network
/sbin/iptables -A INPUT -s $Br0IP/24 -d $Br0IP/24 -j ACCEPT
/sbin/iptables -A INPUT -s $Br0IP/16 -d $Br0IP/24 -j DROP
/sbin/iptables -A OUTPUT -s $Br0IP/24 -o eth1 -j DROP

echo "# Configuring networks ..."
# Configure vlans on br0
NET1=`echo $Br0IP | awk -F "." '{print $1}'`
NET2=`echo $Br0IP | awk -F "." '{print $2}'`
for i in {1..254}
do
  vconfig add br0 $i
  ifconfig br0.$i $NET1.$NET2.$i.254 netmask 255.255.255.0 up
done

# Update the Intranet definition
nics=`ifconfig -a -s | cut -d ' ' -f1 | grep "eth*" | grep -v "eth[0-1]$" | grep -v "eth[0-9]*\.[0-9]*" | tr "\n" " "`
IFS=" "
nicAry=("$nics")
unset IFS

extraIntranetNicDefinitions=""
for i in ${nicAry[@]}
do
  # bring up $i (e.g., eth2, eth3) first.
  ifconfig $i up
  newNicDefinition="auto $i
iface $i inet manual"
  extraIntranetNicDefinitions="$extraIntranetNicDefinitions
$newNicDefinition
"
done

extraIntranetSectionStart="#___CCMP_EXTRA_INTRANET_DEFINITION_START___"
extraIntranetSectionStop="#___CCMP_EXTRA_INTRANET_DEFINITION_STOP___"
extraIntranetNicDefinitions="$extraIntranetSectionStart
$extraIntranetNicDefinitions
$extraIntranetSectionStop"

# Delete the previous extra Intranet definition first and then update the
# definition using $extraIntranetNicDefinitions
sed -i "/^[\t ]*$extraIntranetSectionStart[\t ]*$/,/^[\t ]*$extraIntranetSectionStop[\t ]*$/d" /etc/network/interfaces
echo -e "$extraIntranetNicDefinitions" >> /etc/network/interfaces

# Bridge the extra Intranet NICs (besides eth0) to br0 so that resource nodes
# can connect to any Intranet NIC port in the head node.
if [ ! -z "$nics" ]; then
  brctl addif br0 $nics
fi

# Start ntp server. It may take 5 minutes to finish configuration. Please
# follow steps in https://docs.google.com/a/clustertech.com/document/d/1oM0f2aw9-qfKJT1EsrvRQI2LEk8yfXeKf48-6CCJJQc/edit
# to configure ntp so that ntp can function well after running this command.
service ntp start

echo "# Setting up environment ... "
# As this script is now triggered in /etc/rc.local, if we do not export the
# environmental variable PATH, errors like "Command qemu-img is not found" will
# be reported, ref: http://bug.clustertech.com/redmine/issues/12218.
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export GOPATH=/home/ccmp/ccmp_bins
export CCMP_ROOT=/home/ccmp/ccmp_bins

echo "# Starting openssh server ... "
service ssh restart 2>&1 &

echo "# Starting vnc proxy server ... "
mkdir -p /var/run/guacd 2>&1
chmod 777 /var/run/guacd 2>&1
service guacd restart 2>&1

echo "# Starting cloud server ... "
cd $GOPATH
export LC_CTYPE="en_US.UTF-8"
./ccmp-cloud >> /root/log/cloud.log 2>&1 &
sleep 10

echo "# Starting admin portal and user portal ..."
cd $GOPATH
./ccmp-admin-httpd -port=8088 >> /root/log/httpdAdmin.log 2>&1 &
./ccmp-httpd -c=/home/ccmp/ccmp_bins/etc/frontend/ccmp.json &

echo "# Configuring kernel parameters ..."
/sbin/sysctl -p /etc/sysctl.conf

echo "# Starting HA related scripts ..."
/root/HA/periodical-check.sh &
