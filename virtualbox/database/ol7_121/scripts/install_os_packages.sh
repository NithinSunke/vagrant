echo "******************************************************************************"
echo "Install OS Packages." `date`
echo "******************************************************************************"
echo "nameserver 192.168.1.10" >> /etc/resolv.conf

yum install -y yum-utils zip unzip

yum install -y oracle-rdbms-server-12cR1-preinstall


echo "******************************************************************************"
echo "Firewall." `date`
echo "******************************************************************************"
systemctl stop firewalld
systemctl disable firewalld


echo "******************************************************************************"
echo "SELinux." `date`
echo "******************************************************************************"
sed -i -e "s|SELINUX=enabled|SELINUX=permissive|g" /etc/selinux/config
setenforce permissive
