#!/bin/bash
. /vagrant_config/install.env
. /home/oracle/scripts/setEnv.sh

# Set variables
WL_HOME=${WLS_HOME}
DOMAIN_NAME=${WEB_DOMAIN_NAME}
DOMAIN_HOME="$MW_HOME/user_project/domains/$DOMAIN_NAME"
ADMIN_SERVER_NAME="AdminServer"
ADMIN_USERNAME="weblogic"
ADMIN_PASSWORD="Nithin#0712"
LISTEN_ADDRESS=""
LISTEN_PORT=${LISTEN_PORT}
MS_NAME=${MS_NAME}
MS_PORT=${MS_PORT}
# Create domain
$MW_HOME/oracle_common/common/bin/wlst.sh -skipWLSModuleScanning <<EOF
# Open default domain template
# ============================
readTemplate("${WLS_HOME}/common/templates/wls/wls.jar")
set('Name', "${DOMAIN_NAME}")
setOption('DomainName', '${DOMAIN_NAME}')

# Configure the Administration Server
# =================================================
cd('/Servers/AdminServer')
set('Name', '${ADMIN_SERVER_NAME}')
set('Listenaddress','${LISTEN_ADDRESS}')
set('ListenPort', ${LISTEN_PORT})

# Define the user password for weblogic
# =====================================
cd(('/Security/%s/User/weblogic') % '${DOMAIN_NAME}')
cmo.setName("${ADMIN_USERNAME}")
cmo.setPassword("${ADMIN_PASSWORD}")

# Create Machine
# ================
cd('/')
mn = create('${HOSTNAME}','Machine')
machine_name = '${HOSTNAME}'
if (machine_name != ""):
	print "\tSetting Machine Name",machine_name
	mn.setName(machine_name)

# Create Managed Servers
# =======================
cd ('/')
sobj = create('${MS_NAME}','Server')
sobj.setName('${MS_NAME}')
sobj.setListenPort(${MS_PORT}))
# Listen on all available IPs and channels
sobj.setListenAddress('')

# Write the domain and close the domain template
# ==============================================
setOption('OverwriteDomain', 'true')
setOption('ServerStartMode', 'prod')

# Write Domain
# ============
writeDomain('${DOMAIN_HOME}')
closeTemplate()

# Exit WLST
# =========
exit()
EOF

mkdir -p ${DOMAIN_HOME}/servers/AdminServer/security/
echo "username="${ADMIN_USERNAME} > $DOMAIN_HOME/servers/AdminServer/security/boot.properties
echo "password="${ADMIN_PASSWORD} >> $DOMAIN_HOME/servers/AdminServer/security/boot.properties
${DOMAIN_HOME}/bin/setDomainEnv.sh


echo "WebLogic Server domain creation completed."
echo "Admin Server URL: http://${HOSTNAME}:${LISTEN_PORT}/console"