. /vagrant_config/install.env

echo "******************************************************************************"
echo "Passwordless SSH Setup for oracle." `date`
echo "******************************************************************************"
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cd ~/.ssh
rm -f *
cat /dev/zero | ssh-keygen -t dsa -q -N "" > /dev/null
cat id_dsa.pub >> authorized_keys
ssh-keyscan -H ${NODE1_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_HOSTNAME} >> ~/.ssh/known_hosts
ssh ${NODE1_HOSTNAME} date

cat >/tmp/ssh_rm_root.sh <<EOF
cd ~/.ssh
rm -rf *
EOF

cat >/tmp/ssh_create_root.sh <<EOF
#!/bin/bash
. /vagrant_config/install.env
cd /home/oracle/.ssh
cat /dev/zero | ssh-keygen -t dsa -q -N "" > /dev/null
cat id_dsa.pub >> authorized_keys
ssh-keyscan -H ${NODE1_HOSTNAME} >> ~/.ssh/known_hosts
ssh-keyscan -H ${NODE2_HOSTNAME} >> ~/.ssh/known_hosts
ssh ${NODE2_HOSTNAME} date
EOF

cat >/tmp/ssh_setup_root.sh <<EOF
sshpass -p "${ROOT_PASSWORD}" ssh-copy-id ${NODE1_HOSTNAME}
EOF

sshpass -p "${ROOT_PASSWORD}" scp /tmp/*.sh root@rac2:/tmp
sshpass -p "${ROOT_PASSWORD}" ssh root@rac2 "chmod 777 /tmp/*.sh && sh /tmp/ssh_rm_root.sh"
sshpass -p "${ROOT_PASSWORD}" ssh root@rac2 "sh /tmp/ssh_create_root.sh"
sshpass -p "${ROOT_PASSWORD}" ssh-copy-id ${NODE2_HOSTNAME}
sshpass -p "${ROOT_PASSWORD}" ssh root@rac2 "sh /tmp/ssh_setup_root.sh"


