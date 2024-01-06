echo "******************************************************************************"
echo "Configure shared disks." `date`
echo "******************************************************************************"
echo "******************************************************************************"
echo "Partition disks." `date`
echo "******************************************************************************"
if [ ! -e /dev/sdc1 ]; then
  echo -e "n\np\n1\n\n\nw" | fdisk /dev/sdc
fi
if [ ! -e /dev/sdd1 ]; then
  echo -e "n\np\n1\n\n\nw" | fdisk /dev/sdd
fi
if [ ! -e /dev/sde1 ]; then
  echo -e "n\np\n1\n\n\nw" | fdisk /dev/sde
fi

ls /dev/sd*

echo "******************************************************************************"
echo "Configure udev." `date`
echo "******************************************************************************"
cat > /etc/scsi_id.config <<EOF
options=-g
EOF

ASM_DISK1=`/usr/lib/udev/scsi_id -g -u -d /dev/sdc`
ASM_DISK2=`/usr/lib/udev/scsi_id -g -u -d /dev/sdd`
ASM_DISK3=`/usr/lib/udev/scsi_id -g -u -d /dev/sde`


cat > /etc/udev/rules.d/99-oracle-asmdevices.rules <<EOF
KERNEL=="sd?1", SUBSYSTEM=="block", PROGRAM=="/usr/lib/udev/scsi_id -g -u -d /dev/\$parent", RESULT=="${ASM_DISK1}", SYMLINK+="oracleasm/asm-disk1", OWNER="oracle", GROUP="dba", MODE="0660"
KERNEL=="sd?1", SUBSYSTEM=="block", PROGRAM=="/usr/lib/udev/scsi_id -g -u -d /dev/\$parent", RESULT=="${ASM_DISK2}", SYMLINK+="oracleasm/asm-disk2", OWNER="oracle", GROUP="dba", MODE="0660"
KERNEL=="sd?1", SUBSYSTEM=="block", PROGRAM=="/usr/lib/udev/scsi_id -g -u -d /dev/\$parent", RESULT=="${ASM_DISK3}", SYMLINK+="oracleasm/asm-disk3", OWNER="oracle", GROUP="dba", MODE="0660"

EOF

echo "******************************************************************************"
echo "Reload UDEV Rules." `date`
echo "******************************************************************************"
# Do partx and reload twice.
# Sometimes links don't all appear on first run.
ls -al /dev/sd*1
/sbin/partx -u /dev/sdc1
/sbin/partx -u /dev/sdd1
/sbin/partx -u /dev/sde1

/sbin/udevadm control --reload-rules
sleep 30
/sbin/partx -u /dev/sdc1
/sbin/partx -u /dev/sdd1
/sbin/partx -u /dev/sde1

sleep 20
ls -al /dev/oracleasm/*
