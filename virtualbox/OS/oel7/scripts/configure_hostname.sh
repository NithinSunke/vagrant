
echo "******************************************************************************"
echo "Set Hostname." `date`
echo "******************************************************************************"
hostnamectl set-hostname ${ORACLE_HOSTNAME}
hostname ${ORACLE_HOSTNAME}
cat > /etc/hostname <<EOF
${ORACLE_HOSTNAME}
EOF
