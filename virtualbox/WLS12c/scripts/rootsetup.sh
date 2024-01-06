. /vagrant_config/install.env
echo "mounting the nfs share"
echo "+++++++++++++++++++++++"
mkdir -p /nfsshare
mount -t nfs 192.168.1.10:/nfsshare /nfsshare
df -kh

echo "installing os packages"
echo "+++++++++++++++++++++++"
sh /vagrant_scripts/install_os_packages.sh

echo "preparing disks"
echo "+++++++++++++++++++++++"
sh /vagrant_scripts/prepare_u01_disk.sh

echo "******************************************************************************"
echo "Set root and oracle password and change ownership of /u01." `date`
echo "******************************************************************************"
echo -e "${ROOT_PASSWORD}\n${ROOT_PASSWORD}" | passwd
groupadd -g 5001 oinstall
groupadd -g 5002  dba
groupadd -g 5003 admin
useradd -u 6000 -g oinstall -G dba oracle
useradd -u 6001 -g admin -G wheel nsunke
usermod -aG admin vagrant 
echo -e "${NSUNKE_PASSWORD}\n${NSUNKE_PASSWORD}" | passwd nsunke
echo -e "${ORACLE_PASSWORD}\n${ORACLE_PASSWORD}" | passwd oracle
chown -R oracle:oinstall /u01
chmod -R 775 /u01

echo "modifing sshd_config file"
echo "+++++++++++++++++++++++"

mv /etc/ssh/sshd_config /etc/ssh/sshd_config_org
cp /nfsshare/vagrant/WLS12c/config/sshd_config /etc/ssh/sshd_config
systemctl restart sshd

echo "creating and seting oracle environment varables"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++"
su - oracle -c 'sh /vagrant/scripts/oracle_user_environment_setup.sh'
. /home/oracle/scripts/setEnv.sh

echo "setting the hostnames"
echo "+++++++++++++++++++++++"
sh /vagrant_scripts/configure_hostname.sh

echo "installing the weblogic binaries"
echo "+++++++++++++++++++++++++++++++++"
su - oracle -c 'sh /vagrant/scripts/install_wls.sh'

. /vagrant_config/install.env
echo "create weblogic domain ${DOMAIN_NAME}"
echo "++++++++++++++++++++++++++++++++++++++++++++"
su - oracle -c "sh /nfsshare/vagrant/WLS12c/scripts/wls_domain_create.sh"




