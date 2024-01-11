echo "******************************************************************************"
echo "Prepare yum repos and install base packages." `date`
echo "******************************************************************************"
echo "search c.com" > /etc/resolv.conf
echo "nameserver 192.168.1.10" >> /etc/resolv.conf
chattr +i /etc/resolv.conf
yum install -y yum-utils
yum install -y oracle-epel-release-el7
yum-config-manager --enable ol7_developer_EPEL
yum install -y zip unzip # sshpass 
yum install lvm2 -y
yum install nfs-utils -y
yum -y update
