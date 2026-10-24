# syntax=docker/dockerfile:1
#
# ORB_SLAM3 on Ubuntu 20.04 (GCC 9, OpenCV 4.2, Eigen 3.3, Pangolin 0.6)
# This is the most battle-tested base for ORB_SLAM3 v1.0.
#
# Build:
#   docker build -t orbslam3 --build-arg JOBS=4 .
#
# Run (with GUI via X11, plus a mounted dataset folder):
#   xhost +local:docker
#   docker run -it --rm \
#     -e DISPLAY=$DISPLAY \
#     -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
#     -v /path/to/datasets:/datasets \
#     --device /dev/dri \
#     orbslam3

FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
# Parallel build jobs. ORB_SLAM3 is memory-hungry: lower this if the build is OOM-killed.
ARG JOBS=4
ARG ORB_SLAM3_REF=master
ARG PANGOLIN_REF=v0.6

ENV TZ=Etc/UTC \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# ---------------------------------------------------------------------------
# System dependencies
# ---------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        wget \
        unzip \
        pkg-config \
        ca-certificates \
        libeigen3-dev \
        libopencv-dev \
        libboost-all-dev \
        libssl-dev \
        libglew-dev \
        libgl1-mesa-dev \
        libgl1-mesa-dri \
        libglu1-mesa-dev \
        libegl1-mesa-dev \
        libwayland-dev \
        libxkbcommon-dev \
        wayland-protocols \
        libepoxy-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        x11-apps \
        mesa-utils \
    && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------------
# Pangolin (viewer)
# ---------------------------------------------------------------------------
WORKDIR /opt
RUN git clone --recursive --branch ${PANGOLIN_REF} --depth 1 \
        https://github.com/stevenlovegrove/Pangolin.git \
    && cd Pangolin \
    && mkdir build && cd build \
    && cmake .. -DCMAKE_BUILD_TYPE=Release \
    && make -j${JOBS} \
    && make install \
    && ldconfig \
    && cd /opt && rm -rf Pangolin/build

# ---------------------------------------------------------------------------
# ORB_SLAM3
# ---------------------------------------------------------------------------
WORKDIR /opt
RUN git clone https://github.com/UZ-SLAMLab/ORB_SLAM3.git \
    && cd ORB_SLAM3 \
    && git checkout ${ORB_SLAM3_REF}

WORKDIR /opt/ORB_SLAM3

# Patches for building on Ubuntu 20.04:
#  - Accept the apt OpenCV 4.2 (the CMake file asks for >= 4.4 but works with 4.x)
#  - Use C++14 (needed by newer Pangolin / avoids std errors)
#  - Respect our JOBS setting instead of the hardcoded -j4
#  - Add missing <limits> include seen on some compilers
RUN sed -i 's/find_package(OpenCV 4.4)/find_package(OpenCV 4)/g' CMakeLists.txt \
    && sed -i 's/find_package(OpenCV 3.0)/find_package(OpenCV 4)/g' CMakeLists.txt \
    && sed -i 's/-std=c++11/-std=c++14/g' CMakeLists.txt \
    && sed -i 's/c++11/c++14/g' CMakeLists.txt Thirdparty/DBoW2/CMakeLists.txt Thirdparty/g2o/CMakeLists.txt \
    && sed -i "s/make -j[0-9]*/make -j${JOBS}/g" build.sh \
    && sed -i '1i #include <limits>' include/CameraModels/GeometricCamera.h || true \
    && chmod +x build.sh \
    && ./build.sh

# Make sure the shared libs are discoverable at runtime
ENV LD_LIBRARY_PATH=/opt/ORB_SLAM3/lib:/opt/ORB_SLAM3/Thirdparty/DBoW2/lib:/opt/ORB_SLAM3/Thirdparty/g2o/lib:/usr/local/lib:${LD_LIBRARY_PATH}
ENV ORB_SLAM3_ROOT=/opt/ORB_SLAM3

# ---------------------------------------------------------------------------
# Convenience: mount point for datasets, results land in /output
# ---------------------------------------------------------------------------
RUN mkdir -p /datasets /output
VOLUME ["/datasets", "/output"]

WORKDIR /opt/ORB_SLAM3

# Drops you into a shell. Example invocation inside the container (EuRoC mono):
#   ./Examples/Monocular/mono_euroc \
#       Vocabulary/ORBvoc.txt \
#       Examples/Monocular/EuRoC.yaml \
#       /datasets/MH01 \
#       Examples/Monocular/EuRoC_TimeStamps/MH01.txt \
#       dataset-MH01_mono
CMD ["/bin/bash"]