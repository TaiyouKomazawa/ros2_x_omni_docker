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
RUN apt-get install -y ros-foxy-diagnostic-updater ros-foxy-geographic-msgs libgeographic-dev

RUN echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc

RUN ["/bin/bash", "-c", "source ~/.bashrc"]

RUN echo "source /ros2_ws/install/setup.bash" >> ~/.bashrc

RUN apt-get update
RUN apt-get install -y net-tools iputils-ping iproute2 tcpdump

ENTRYPOINT ["/bin/bash", "-c", "/entrypoint_ros.bash"]
