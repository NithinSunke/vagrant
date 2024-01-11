echo "******************************************************************************"
echo "Prepare yum repos and install base packages." `date`
echo "******************************************************************************"
echo "search c.com" > /etc/resolv.conf
echo "nameserver 192.168.1.10" >> /etc/resolv.conf
chattr +i /etc/resolv.conf
yum install -y yum-utils
yum install -y zip unzip # sshpass 
yum install lvm2 -y
yum -y update
