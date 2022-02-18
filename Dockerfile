# Uses the Ubuntu 20.04 LTS (Focal Fossa) as the base image.
FROM ubuntu:20.04

# Shell to be used during this Docker build.
SHELL ["/bin/bash", "-c"]

# Update the system and install some essential packages.
RUN apt update && apt upgrade -y
RUN apt update && apt install -y gnupg wget lsb-release vim tmux open-ssh git libglvnd0 libglvnd-dev

# Install ROS noetic
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN wget -q https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc -O- | apt-key add -
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install ros-noetic-desktop-full -y
RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc
RUN source /root/.bashrc
RUN apt update && apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential -y
RUN rosdep init
RUN rosdep update

# Clone and build the auv workspace.
RUN --mount=type=secret,id=AUV_WS_ACCESS                                                                   \
    && mkdir -p ~/auv_ws/src                                                                               \
    && cd ~/auv_ws/src                                                                                     \
    && mkdir -p ~/auv_ws/src/robots                                                                        \
    && mkdir -p ~/auv_ws/src/actuators                                                                     \
    && git clone https://github.com/ufrj-nautilus/gripper.git ~/auv_ws/src/actuators/gripper               \
    && git clone https://github.com/ufrj-nautilus/marker_dropper.git ~/auv_ws/src/actuators/marker_dropper \
    && git clone https://github.com/ufrj-nautilus/torpedo.git ~/auv_ws/src/actuators/torpedo               \
    && git clone https://github.com/ufrj-nautilus/auv_simulator.git                                        \
    && git clone https://github.com/ufrj-nautilus/control.git                                              \
    && git clone https://github.com/ufrj-nautilus/brhue.git ~/auv_ws/src/robots/brhue                      \
    && git clone https://github.com/ufrj-nautilus/lua.git ~/auv_ws/src/robots/lua                          \
    && git clone https://github.com/ufrj-nautilus/utils.git                                                \
    && git clone https://github.com/ufrj-nautilus/auv_messages.git                                         \
    && git clone https://github.com/ufrj-nautilus/localization.git                                         \
    && git clone https://github.com/ufrj-nautilus/smach.git                                                \
    && git clone --branch noetic-devel https://github.com/tdenewiler/uuv_simulator.git

RUN cd ~/auv_ws && catkin_make
RUN echo "source /root/auv_ws/devel/setup.bash" >> /root/.bashrc
