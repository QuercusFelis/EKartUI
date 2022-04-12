#!/bin/bash

#EKartUI Startup Script
# Set up CAN interface
sudo ip link set can0 up type can bitrate 500000

# Start up CAN data parser
cd /home/gokart/projects/EKartUI
nohup python ./can_parse.py &
sleep 3

# Start up APD
cd /home/gokart/projects/APD_deploy/yolov5
nohup ./run_it.sh &
sleep 30

# Start up EKartUI
cd /home/gokart/projects/EKartUI
nohup python ./Main.py &
