#!/bin/bash

XOMNI_PATH=/dev/serial/by-path/platform-fd500000.pcie-pci-0000:01:00.0-usb-0:1.4:1.0-port0
RPLIDAR_PATH=/dev/serial/by-path/platform-fd500000.pcie-pci-0000:01:00.0-usb-0:1.3:1.0-port0

if [ ! -e /dev/ttyXOmni ] && [ -e ${XOMNI_PATH} ]; then
    echo "linked /dev/ttyXOmni"
    ln -s ${XOMNI_PATH} /dev/ttyXOmni
fi
if [ ! -e /dev/ttyRPLidar ] && [ -e ${RPLIDAR_PATH} ]; then
    echo "linked /dev/ttyRPLidar"
    ln -s ${RPLIDAR_PATH} /dev/ttyRPLidar
fi

cd /ros2_ws
source install/setup.bash
source /opt/ros/foxy/setup.bash
#colcon build   #起動の高速化のためビルドをコメントアウトする
source install/setup.bash
source /opt/ros/foxy/setup.bash
ros2 launch x_omni_components nodes.launch.py &
ros2 launch ros2_x_omni_imu_filter pose_merger_ekf.launch.py
#while :; do sleep 2073600; done
