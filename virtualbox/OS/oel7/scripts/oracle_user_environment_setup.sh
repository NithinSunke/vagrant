. /vagrant_config/install.env

echo "******************************************************************************"
echo "Create environment scripts." `date`
echo "******************************************************************************"
mkdir -p /home/oracle/scripts

cat > /home/oracle/scripts/setEnv.sh <<EOF
# Oracle Settings
export TMP=/tmp
export TMPDIR=\$TMP

export ORACLE_HOSTNAME=${HOSTNAME}
EOF

cat >> /home/oracle/.bash_profile <<EOF
. /home/oracle/scripts/setEnv.sh
EOF

echo "******************************************************************************"
echo "Create directories." `date`
echo "******************************************************************************"
. /home/oracle/scripts/setEnv.sh
#mkdir -p ${ORACLE_HOME}
#mkdir -p ${DATA_DIR}
