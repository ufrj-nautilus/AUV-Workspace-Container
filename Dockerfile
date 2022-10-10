FROM ros:noetic-ros-base-focal

# Update the system and install some essential packages.
RUN apt update && apt install -y vim tmux  x11-apps mesa-utils python3-pip htop
RUN yes | pip3 install pynput pymap3d dearpygui

# Settings ROS develepment environment
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install ros-noetic-desktop-full ros-noetic-rtabmap-ros ros-noetic-robot-localization liburdfdom-tools -y
RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc
RUN echo "source /usr/share/gazebo/setup.sh" >> /root/.bashrc
RUN apt update && apt install python3-rosinstall-generator python3-wstool python3-serial meshlab -y


# Configure the environment.
RUN echo "set -g mouse on" >> /root/.tmux.conf
RUN echo "set-option -g history-limit 20000" >> /root/.tmux.conf
RUN echo "source /root/catkin_ws/devel/setup.bash" >> /root/.bashrc
RUN mkdir -p /root/catkin_ws/src
WORKDIR /root/catkin_ws

