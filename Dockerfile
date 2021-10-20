FROM ubuntu:20.04
LABEL version="1.0"
LABEL description="Dockerの練習も兼ねたロボット動作環境の構築"
LABEL tag="x_omni_os"

RUN sed -i.org -e 's|ports.ubuntu.com|jp.archive.ubuntu.com|g' /etc/apt/sources.list

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y curl gnupg2 lsb-release

RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

RUN sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'

RUN apt-get update

RUN apt-get install -y ros-foxy-desktop python3-pip python3-colcon-common-extensions

RUN ["/bin/bash", "-c", "source /opt/ros/foxy/setup.bash"]
RUN pip3 install -U argcomplete

RUN apt-get update && apt-get upgrade -y
#robot-localization depends.
RUN apt-get install -y  ros-foxy-geographic-msgs libgeographic-dev ros-foxy-diagnostic-*
#depthai-ros depends.
RUN apt-get install -y libopencv-dev python3-rosdep python3-vcstool wget ros-foxy-vision-msgs ros-foxy-camera-info-manager
RUN rosdep init
RUN rosdep update
RUN wget -qO- https://raw.githubusercontent.com/luxonis/depthai-ros/foxy-devel/install_dependencies.sh | bash

RUN apt-get install -y net-tools iputils-ping iproute2 tcpdump

RUN apt-get install -y ros-foxy-rmw-cyclonedds-cpp
RUN echo -e "net.core.rmem_max=8388608\nnet.core.rmem_default=8388608\n" >> /etc/sysctl.d/60-cyclonedds.conf
RUN echo "export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp" >> ~/.bashrc
RUN echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc
RUN ["/bin/bash", "-c", "source ~/.bashrc"]
RUN echo "source /ros2_ws/install/setup.bash" >> ~/.bashrc
ENTRYPOINT ["/bin/bash", "-c", "/entrypoint_ros.bash"]
