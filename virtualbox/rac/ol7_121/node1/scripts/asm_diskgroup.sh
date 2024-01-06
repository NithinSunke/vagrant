#!/bin/bash

# Set Oracle environment variables
export ORACLE_HOME=/u01/app/12.1.0.2/grid
export ORACLE_SID=+ASM1
export PATH=$ORACLE_HOME/bin:$PATH

# Set ASM configuration parameters
ASM_DISKGROUPS=("DATA" "FRA")  # Add the names of your ASM disk groups
DISK_LOCATIONS=("//dev/oracleasm/asm-disk2" "/dev/oracleasm/asm-disk3")  # Add the disk locations for each disk group

# Start ASM Configuration Assistant
asmca -silent -createDiskGroup -diskGroupName ${ASM_DISKGROUPS[0]} -diskList ${DISK_LOCATIONS[0]} -redundancy EXTERNAL
asmca -silent -createDiskGroup -diskGroupName ${ASM_DISKGROUPS[1]} -diskList ${DISK_LOCATIONS[1]} -redundancy EXTERNAL

# Additional disk groups can be added following the same pattern

# Example: asmca -silent -createDiskGroup -diskGroupName <DiskGroupName> -diskList <DiskLocation1>,<DiskLocation2> -redundancy EXTERNAL

# Exit ASM Configuration Assistant
exit
