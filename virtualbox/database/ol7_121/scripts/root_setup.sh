. /vagrant/config/install.env

mkdir -p /nfsshare
mount -t nfs 192.168.1.10:/nfsshare /nfsshare

sh /vagrant/scripts/prepare_disks.sh

sh /vagrant/scripts/install_os_packages.sh

mkdir -p ${SCRIPTS_DIR}
mkdir -p ${DATA_DIR}
chown -R oracle.oinstall ${SCRIPTS_DIR} /u01 /u02

echo "******************************************************************************"
echo "Prepare environment and install the software." `date`
echo "******************************************************************************"
su - oracle -c 'sh /vagrant/scripts/oracle_user_environment_setup.sh'
su - oracle -c 'sh /vagrant/scripts/oracle_software_installation.sh'

echo "******************************************************************************"
echo "Run root scripts." `date`
echo "******************************************************************************"
sh ${ORA_INVENTORY}/orainstRoot.sh
sh ${ORACLE_HOME}/root.sh

echo "******************************************************************************"
echo "Create the database and install the ORDS software." `date`
echo "******************************************************************************"
su - oracle -c 'sh /vagrant/scripts/oracle_create_database.sh'
su - oracle -c 'sh /vagrant/scripts/ords_software_installation.sh'
#
sh /vagrant/scripts/oracle_service_setup.sh
