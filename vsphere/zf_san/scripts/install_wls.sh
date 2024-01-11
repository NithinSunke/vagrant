cd /u01
mkdir -p /u01/oraInventory

mkdir -p ${MW_HOME}

. /home/oracle/scripts/setEnv.sh

cd /u01/oracle
tar -xvzf /nfsshare/soft/jdk-8u391-linux-x64.tar.gz

cd /nfsshare/soft
unzip fmw_12.2.1.3.0_wls_Disk1_1of1.zip

java -Xmx1024m -jar /nfsshare/soft/fmw_12.2.1.3.0_wls.jar -silent -responseFile /nfsshare/vagrant/WLS12c/config/wls.rsp -invPtrLoc /nfsshare/vagrant/WLS12c/config/oraInst.loc

. $WLS_HOME/server/bin/setWLSEnv.sh
java weblogic.version