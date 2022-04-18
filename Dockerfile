# Uses the Ubuntu 20.04 LTS (Focal Fossa) as the base image.
FROM ubuntu:20.04

# Shell to be used during the build process and the container's default.
SHELL ["/bin/bash", "-c"]

# Update the system and install some essential packages.
RUN apt update && apt upgrade -y
RUN apt update && apt install -y gnupg wget lsb-release vim tmux libglvnd0 libglvnd-dev x11-apps mesa-utils python3-pip
RUN yes | pip3 install pynput pymap3d

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

# auv_gnc dependencies.
RUN eigen_version="3.3.7" \
&& wget --no-check-certificate https://bitbucket.org/eigen/eigen/get/$eigen_version.tar.bz2 \
&& tar -xf $eigen_version.tar.bz2 \
&& mv eig* eigen \
&& mkdir eigen/build_dir \
&& cd eigen/build_dir \
&& cmake .. \
&& sudo make install \
&& cd ../../ \
&& rm -rf eigen/ $eigen_version.tar.bz2 \
&& ceres_version="ceres-solver-1.14.0" \
&& sudo apt-get -y install cmake \
&& sudo apt-get -y install libgoogle-glog-dev \
&& sudo apt-get -y install libatlas-base-dev \
&& sudo apt-get -y install libsuitesparse-dev \
&& wget http://ceres-solver.org/$ceres_version.tar.gz \
&& tar zxf $ceres_version.tar.gz \
&& rm $ceres_version.tar.gz \
&& mkdir ceres-bin \
&& cd ceres-bin \
&& cmake ../$ceres_version \
&& make \
&& sudo make install \
&& cd .. \
&& rm -rf $ceres_version/ ceres-bin/ \
&& git clone https://github.com/coin-or/CppAD.git cppad \
&& cd cppad \
&& mkdir build \
&& cd build/ \
&& cmake .. \
&& sudo make install \
&& cd ../../ \
&& rm -rf cppad/

# Configure the environment.
RUN echo "set -g mouse on" >> /root/.tmux.conf
RUN echo "set-option -g history-limit 20000" >> /root/.tmux.conf
RUN echo "source /root/catkin_ws/devel/setup.bash" >> /root/.bashrc
RUN mkdir -p /root/catkin_ws/src
WORKDIR /root/catkin_ws