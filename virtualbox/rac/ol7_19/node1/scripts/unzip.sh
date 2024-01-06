. /vagrant_config/install.env

echo "******************************************************************************"
echo "Unzip grid software." `date`
echo "******************************************************************************"
cd ${GRID_HOME}
unzip -oq ${SOFTWARE_DIR}/${GRID_SOFTWARE}



# Optional cluster verification.
#${GRID_HOME}/runcluvfy.sh stage -pre crsinst -n "${NODE1_HOSTNAME},${NODE2_HOSTNAME}"