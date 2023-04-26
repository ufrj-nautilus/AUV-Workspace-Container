FROM osrf/ros:noetic-ros-base-focal
#Maybe FROM osrf/ros:noetic-perception-focal ... too


#Installing Ubuntu dependencies
RUN apt update && apt install -y vim tmux x11-apps mesa-utils python3-pip htop
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y ros-noetic-rtabmap-ros ros-noetic-robot-localization liburdfdom-tools python3-catkin-tools

#Setting up Teensy
COPY ./49-teensy.rules /etc/udev/rules.d/49-teensy.rules 
RUN sudo cp 49-teensy.rules /etc/udev/rules.d/49-teensy.rules


#Configure the environment
RUN echo "source /root/catkin_ws/devel/setup.bash" >> /root/.bashrc
RUN echo "set -g mouse on" >> /root/.tmux.conf
RUN echo "set-option -g history-limit 20000" >> /root/.tmux.conf
RUN echo "source /root/catkin_ws/devel/setup.bash" >> /root/.bashrc
RUN mkdir -p /root/catkin_ws/src


