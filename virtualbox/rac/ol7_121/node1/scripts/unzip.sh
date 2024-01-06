. /vagrant_config/install.env

echo "******************************************************************************"
echo "Unzip grid software." `date`
echo "******************************************************************************"
mkdir -p ${SOFTWARE_DIR}
cd ${SOFTWARE_DIR}
unzip "${GRID_SOFTWARE}"
cd grid

# Optional cluster verification.
${SOFTWARE_DIR}/grid/runcluvfy.sh stage -pre crsinst -n "${NODE1_HOSTNAME},${NODE2_HOSTNAME}"
