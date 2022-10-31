FROM osrf/ros:noetic-desktop-full-focal

# Installing Ubuntu dependencies
RUN apt update && apt install -y vim tmux x11-apps mesa-utils python3-pip htop

# Settings ROS development environment
RUN yes | pip3 install pynput pymap3d dearpygui
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y ros-noetic-rtabmap-ros ros-noetic-robot-localization liburdfdom-tools

# auv_gnc dependencies.
COPY ./install_deps.sh /install_deps.sh
RUN chmod +x /install_deps.sh
RUN bash /install_deps.sh
RUN rm -rf /install_deps.sh

# Configure the environment.
RUN echo "set -g mouse on" >> /root/.tmux.conf
RUN echo "set-option -g history-limit 20000" >> /root/.tmux.conf
RUN echo "source /root/catkin_ws/devel/setup.bash" >> /root/.bashrc
RUN mkdir -p /root/catkin_ws/src
WORKDIR /root/catkin_ws