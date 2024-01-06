. /vagrant_config/install.env
mkdir -p /nfsshare
mount -t nfs 192.168.1.10:/nfsshare /nfsshare
sh /vagrant_scripts/prepare_u01_disk.sh

sh /vagrant_scripts/install_os_packages.sh

echo "******************************************************************************"
echo "Set root and oracle password and change ownership of /u01." `date`
echo "******************************************************************************"
echo -e "${ROOT_PASSWORD}\n${ROOT_PASSWORD}" | passwd
echo -e "${ORACLE_PASSWORD}\n${ORACLE_PASSWORD}" | passwd oracle
chown -R oracle:oinstall /u01
chmod -R 775 /u01
usermod -aG vagrant oracle

sh /vagrant_scripts/configure_hosts_base.sh
sh /vagrant_scripts/configure_hosts_scan.sh

cat > /etc/resolv.conf <<EOF
search scs.com
nameserver ${DNS_PUBLIC_IP}
EOF

# Stop NetworkManager altering the /etc/resolve.conf contents.
sed -i -e "s|\[main\]|\[main\]\ndns=none|g" /etc/NetworkManager/NetworkManager.conf
systemctl restart NetworkManager.service

sh /vagrant_scripts/configure_chrony.sh

sh /vagrant_scripts/configure_shared_disks.sh
#
su - oracle -c 'sh /vagrant/scripts/oracle_user_environment_setup.sh'
 . /home/oracle/scripts/setEnv.sh
sh /vagrant_scripts/configure_hostname.sh
echo "******************************************************************************"
echo "Passwordless SSH Setup for oracle." `date`
echo "******************************************************************************"
su - oracle -c 'sh /vagrant/scripts/passwd_less_ssh.sh'
echo "******************************************************************************"
echo "Passwordless SSH Setup for root." `date`
echo "******************************************************************************"
sh /vagrant/scripts/passwd_less_ssh_root.sh

su - oracle -c 'sh /vagrant/scripts/unzip.sh'
echo "******************************************************************************"
echo "Create /etc/oraInst.loc - BUG:9015869." `date`
echo "******************************************************************************"
cat > /etc/oraInst.loc <<EOF
inventory_loc=/u01/app/oraInventory
inst_group=oinstall
EOF
echo "******************************************************************************"
echo "Install cvuqdisk package." `date`
echo "******************************************************************************"
yum install -y ${GRID_HOME}/cv/rpm/cvuqdisk-1.0.10-1.rpm
scp -pr ${GRID_HOME}/cv/rpm/cvuqdisk-1.0.10-1.rpm root@${NODE2_HOSTNAME}:/tmp
ssh root@${NODE2_HOSTNAME} yum install -y /tmp/cvuqdisk-1.0.10-1.rpm

su - oracle -c 'sh /vagrant/scripts/oracle_grid_software_installation.sh'
echo "******************************************************************************"
echo "Run grid root scripts." `date`
echo "******************************************************************************"
sh ${ORA_INVENTORY}/orainstRoot.sh
ssh root@${NODE2_HOSTNAME} sh ${ORA_INVENTORY}/orainstRoot.sh
cd ${GRID_HOME};sh ${GRID_HOME}/root.sh
ssh root@${NODE2_HOSTNAME} "cd ${GRID_HOME};sh ${GRID_HOME}/root.sh"

su - oracle -c 'sh /vagrant/scripts/oracle_grid_software_config.sh'

su - oracle -c 'sh /vagrant/scripts/oracle_db_software_installation.sh'


echo "******************************************************************************"
echo "Run DB root scripts." `date` 
echo "******************************************************************************"
sh ${ORACLE_HOME}/root.sh
ssh root@${NODE2_HOSTNAME} sh ${ORACLE_HOME}/root.sh

su - oracle -c 'sh /vagrant/scripts/oracle_create_database.sh'
