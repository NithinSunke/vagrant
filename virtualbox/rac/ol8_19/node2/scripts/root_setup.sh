echo "******************************************************************************"
echo "Setup Start." `date`
echo "******************************************************************************"

. /vagrant_config/install.env

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

echo "******************************************************************************"
echo "Set Hostname." `date`
echo "******************************************************************************"
hostnamectl set-hostname ${NODE2_HOSTNAME}

su - oracle -c 'sh /vagrant/scripts/oracle_user_environment_setup.sh'
. /home/oracle/scripts/setEnv.sh

echo "******************************************************************************"
echo "Setup End." `date`
echo "******************************************************************************"
