# Uses the Ubuntu 20.04 LTS (Focal Fossa) as the base image.
FROM ubuntu:20.04

# Shell to be used during the build process.
SHELL ["/bin/bash", "-c"]

# Update the system and install some essential packages.
RUN apt update && apt upgrade -y
RUN apt update && apt install -y gnupg wget lsb-release vim tmux libglvnd0 libglvnd-dev x11-apps mesa-utils

# Install ROS noetic
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN wget -q https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc -O- | apt-key add -
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install ros-noetic-desktop-full ros-noetic-rtabmap-ros -y
RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc
RUN echo "source /usr/share/gazebo/setup.sh" >> /root/.bashrc
RUN source /root/.bashrc
RUN apt update && apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential -y
RUN rosdep init
RUN rosdep update
RUN mkdir -p /root/catkin_ws/src
WORKDIR /root/catkin_ws
