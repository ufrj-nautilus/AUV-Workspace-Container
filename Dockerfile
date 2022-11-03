FROM osrf/ros:noetic-desktop-full-focal

# Installing Ubuntu dependencies
RUN apt update && apt install -y vim tmux x11-apps mesa-utils python3-pip htop

# Settings ROS development environment
RUN yes | pip3 install pynput pymap3d dearpygui
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y ros-noetic-rtabmap-ros ros-noetic-robot-localization liburdfdom-tools

# Configure the environment.
RUN echo "set -g mouse on" >> /root/.tmux.conf
RUN echo "set-option -g history-limit 20000" >> /root/.tmux.conf
RUN echo "source /root/catkin_ws/devel/setup.bash" >> /root/.bashrc
RUN mkdir -p /root/catkin_ws/src
COPY ./requirements.txt requirements.txt
RUN pip install -r requirements.txt
WORKDIR /root/catkin_ws