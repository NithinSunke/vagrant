. /vagrant_config/install.env
#echo "mounting the nfs share"
#mkdir -p /nfsshare
#mount -t nfs 192.168.1.10:/nfsshare /nfsshare
df -kh

echo "installing os packages"
sh /vagrant_scripts/install_os_packages.sh

sh /vagrant_scripts/prepare_u01_disk.sh

echo "******************************************************************************"
echo "Set root and oracle password and change ownership of /u01." `date`
echo "******************************************************************************"
echo -e "${ROOT_PASSWORD}\n${ROOT_PASSWORD}" | passwd
groupadd -g 5001 oinstall
groupadd -g 5002  dba
useradd -u 6000 -g oinstall -G dba oracle
echo -e "${ORACLE_PASSWORD}\n${ORACLE_PASSWORD}" | passwd oracle
chown -R oracle:oinstall /u01
chmod -R 775 /u01

su - oracle -c 'sh /vagrant/scripts/oracle_user_environment_setup.sh'
. /home/oracle/scripts/setEnv.sh

sh /vagrant_scripts/configure_hostname.sh
