
echo "******************************************************************************"
echo "Set Hostname." `date`
echo "******************************************************************************"
hostnamectl set-hostname ${HOSTNAME}.${DOMAIN_NAME}
hostname  ${HOSTNAME}.${DOMAIN_NAME}
cat > /etc/hostname <<EOF
 ${HOSTNAME}.${DOMAIN_NAME}
EOF
