. /vagrant_config/install.env

sh /vagrant_scripts/prepare_u01_disk.sh

sh /vagrant_scripts/install_os_packages.sh

mkdir -p /nfsshare
mount -t nfs 192.168.1.10:/nfsshare /nfsshare
echo "******************************************************************************"
echo "Set root and oracle password and change ownership of /u01." `date`
echo "******************************************************************************"
echo -e "${ROOT_PASSWORD}\n${ROOT_PASSWORD}" | passwd
echo -e "${ORACLE_PASSWORD}\n${ORACLE_PASSWORD}" | passwd oracle
chown -R oracle:oinstall /u01
chmod -R 775 /u01

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

su - oracle -c 'sh /vagrant/scripts/oracle_user_environment_setup.sh'
. /home/oracle/scripts/setEnv.sh
sh /vagrant_scripts/configure_hostname.sh



echo "******************************************************************************"
echo "Create /etc/oraInst.loc - BUG:9015869." `date`
echo "******************************************************************************"
cat > /etc/oraInst.loc <<EOF
inventory_loc=/u01/app/oraInventory
inst_group=oinstall
EOF
