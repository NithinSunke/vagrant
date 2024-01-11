echo "installing os packages"
echo "+++++++++++++++++++++++"
sh /tmp/vagrant/vsphere/zf_san/script/install_os_packages.sh
systemctl start nfs-server.service
systemctl enable nfs-server.service
systemctl status nfs-server.service

echo "mounting the nfs share"
echo "+++++++++++++++++++++++"

mkdir -p /nfsshare
mount -t nfs 192.168.1.10:/nfsshare /nfsshare
df -kh

echo "192.168.1.10:/nfsshare /nfsshare  nfs 0 0"  >> /etc/fstab

echo "******************************************************************************"
echo "Set root and oracle password and change ownership of /u01." `date`
echo "******************************************************************************"
echo -e "${ROOT_PASSWORD}\n${ROOT_PASSWORD}" | passwd
groupadd -g 5003 admin
useradd -u 6001 -g admin -G wheel nsunke
usermod -aG admin vagrant 
echo -e "${NSUNKE_PASSWORD}\n${NSUNKE_PASSWORD}" | passwd nsunke

echo "modifing sshd_config file"
echo "+++++++++++++++++++++++"

mv /etc/ssh/sshd_config /etc/ssh/sshd_config_org
cp /nfsshare/vagrant/vsphere/zf_san/config/sshd_config /etc/ssh/sshd_config
systemctl restart sshd

. /nfsshare/vagrant/vsphere/zf_san/config/install.env
echo "setting the hostnames"
echo "+++++++++++++++++++++++"
sh /nfsshare/vagrant/vsphere/zf_san/script/configure_hostname.sh

echo "=========================================================="
echo "server build  ${HOSTNAME}.${DOMAIN_NAME} is completed"
echo "=========================================================="



