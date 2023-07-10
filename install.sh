#!/bin/bash
echo "Choose where you want to store the AUV workspace, leave it blank for $HOME/catkin_ws"
echo -n "mkdir -p $HOME/"
read workspace

mkdir -p $HOME/$workspace/catkin_ws/src
cd $HOME/$workspace/catkin_ws/src
mkdir -p $HOME/$workspace/catkin_ws/src/robots
mkdir -p $HOME/$workspace/catkin_ws/src/actuators
git clone git@github.com:ufrj-nautilus/gripper.git $HOME/$workspace/catkin_ws/src/actuators/gripper
git clone git@github.com:ufrj-nautilus/marker_dropper.git $HOME/$workspace/catkin_ws/src/actuators/marker_dropper
git clone git@github.com:ufrj-nautilus/torpedo.git $HOME/$workspace/catkin_ws/src/actuators/torpedo
git clone git@github.com:ufrj-nautilus/auv_simulator.git
git clone git@github.com:ufrj-nautilus/control.git
git clone git@github.com:ufrj-nautilus/brhue.git $HOME/$workspace/catkin_ws/src/robots/brhue
git clone git@github.com:ufrj-nautilus/lua.git $HOME/$workspace/catkin_ws/src/robots/lua
git clone git@github.com:ufrj-nautilus/utils.git
git clone git@github.com:ufrj-nautilus/auv_messages.git
git clone -b orbslam3 git@github.com:ufrj-nautilus/localization.git
git clone git@github.com:ufrj-nautilus/smach.git
git clone git@github.com:ufrj-nautilus/auv_ws.git
git clone --recursive git@github.com:ufrj-nautilus/darknet_ros.git
git clone --branch noetic-devel git@github.com:tdenewiler/uuv_simulator.git
cd $HOME/$workspace/catkin_ws/src/utils
rm -rf pysdf
git rm --cached pysdf
git submodule add https://github.com/ufrj-nautilus/pysdf
