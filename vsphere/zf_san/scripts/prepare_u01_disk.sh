function prepare_disk {
  MOUNT_POINT=$1
  DISK_DEVICE=$2
  VG_NAME=$3
  LV_NAME=$4

  echo "******************************************************************************"
  echo "Prepare ${MOUNT_POINT} disk." `date`
  echo "******************************************************************************"
  # New partition for the whole disk.
  echo -e "n\np\n1\n\n\nw" | fdisk ${DISK_DEVICE}

 # create phyical volume
    pvcreate ${DISK_DEVICE}1
 # create the volume group
   vgcreate ${VG_NAME} ${DISK_DEVICE}1
 # create logical volume
   lvcreate --size 99.9g --name ${LV_NAME}  ${VG_NAME}

  # Add file system.
  mkfs.xfs -f /dev/${VG_NAME}/${LV_NAME}

  # Mount it.
  UUID=`blkid -o value /dev/${VG_NAME}/${LV_NAME} | grep -v xfs`
  mkdir ${MOUNT_POINT}
  echo "UUID=${UUID}  ${MOUNT_POINT}    xfs    defaults 1 2" >> /etc/fstab
  mount ${MOUNT_POINT}
}

prepare_disk /u01 /dev/sdb wl_vg wl_lv

