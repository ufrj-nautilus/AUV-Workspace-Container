FROM osrf/ros:noetic-ros-base-focal
#Maybe FROM osrf/ros:noetic-perception-focal ... too


#Installing Ubuntu dependencies and quality of life applications
RUN apt update && apt install -y vim tmux x11-apps mesa-utils python3-pip htop


RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y ros-noetic-rtabmap-ros ros-noetic-robot-localization liburdfdom-tools python3-catkin-tools


RUN echo "source /root/catkin_ws/devel/setup.bash" >> /root/.bashrc
WORKDIR /root/catkin_ws
