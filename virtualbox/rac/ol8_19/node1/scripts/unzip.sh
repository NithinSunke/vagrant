. /vagrant_config/install.env

echo "******************************************************************************"
echo "Unzip grid software." `date`
echo "******************************************************************************"
cd ${SOFTWARE_DIR}
mkdir -p ${GRID_HOME}
unzip "${GRID_SOFTWARE}" -d ${GRID_HOME}

# Optional cluster verification.
#${GRID_HOME}/runcluvfy.sh stage -pre crsinst -n "${NODE1_HOSTNAME},${NODE2_HOSTNAME}"
