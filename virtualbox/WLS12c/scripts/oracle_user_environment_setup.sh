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
export MW_HOME=${MW_HOME}
export WLS_HOME=$MW_HOME/wlserver
export WL_HOME=$WLS_HOME
export JAVA_HOME=/u01/oracle/jdk1.8.0_391
export PATH=$JAVA_HOME/bin:$PATH
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
