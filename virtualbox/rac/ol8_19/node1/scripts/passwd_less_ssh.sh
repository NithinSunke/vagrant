. /vagrant_config/install.env

echo "******************************************************************************"
echo "Passwordless SSH Setup for oracle." `date`
echo "******************************************************************************"
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cd ~/.ssh
rm -f *
cat /dev/zero | ssh-keygen -t rsa -q -N "" > /dev/null
cat id_rsa.pub >> authorized_keys
ssh-keyscan -H ${NODE1_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE1_FQ_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE1_PUBLIC_IP} >> ~/.ssh/known_hosts
ssh-keyscan -H localhost >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_FQ_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_PUBLIC_IP} >> ~/.ssh/known_hosts
chmod -R 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
ssh ${NODE1_HOSTNAME} date


cat >/tmp/ssh_rm.sh <<EOF
cd ~/.ssh
rm -rf *
EOF

cat >/tmp/ssh_create.sh <<EOF
#!/bin/bash
. /vagrant_config/install.env
cd /home/oracle/.ssh
cat /dev/zero | ssh-keygen -t rsa -q -N "" > /dev/null
cat id_rsa.pub >> authorized_keys
ssh-keyscan -H ${NODE2_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_FQ_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_PUBLIC_IP} >> ~/.ssh/known_hosts
ssh-keyscan -H localhost >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE1_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE1_FQ_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE1_PUBLIC_IP} >> ~/.ssh/known_hosts
ssh ${NODE2_HOSTNAME} date
EOF
#
cat >/tmp/ssh_setup.sh <<EOF
sshpass -p "${ORACLE_PASSWORD}" ssh-copy-id ${NODE1_HOSTNAME}
sshpass -p "${ORACLE_PASSWORD}" ssh-copy-id ${NODE2_HOSTNAME}
EOF
#
sshpass -p "${ORACLE_PASSWORD}" scp /tmp/*.sh oracle@rac2:/tmp
sshpass -p "${ORACLE_PASSWORD}" ssh oracle@rac2 "chmod 777 /tmp/*.sh && sh /tmp/ssh_rm.sh"
sshpass -p "${ORACLE_PASSWORD}" ssh oracle@rac2 "sh /tmp/ssh_create.sh"
sshpass -p "${ORACLE_PASSWORD}" ssh-copy-id ${NODE2_HOSTNAME}
sshpass -p "${ORACLE_PASSWORD}" ssh oracle@rac2 "sh /tmp/ssh_setup.sh"


