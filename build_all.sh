# !/bin/bash
apt-get update
apt-get --fix-broken install
apt-get install wget
apt-get install git
# install cuda toolkit and nvidia-prime
# apt-get install nvidia-cuda-dev nvidia-cuda-toolkit nvidia-nsight nvidia-prime
# install git, SuiteSparse, Lapack, BLAS etc
apt-get install libssl-dev libsuitesparse-dev liblapack-dev libblas-dev libgtk2.0-dev pkg-config libopenni-dev libusb-1.0-0-dev wget zip clang

apt-get update
cd /

# Build Cmake
apt autoremove cmake
wget https://github.com/Kitware/CMake/releases/download/v3.26.5/cmake-3.26.5.tar.gz
tar -xvf cmake-3.26.5.tar.gz
cd cmake-3.26.5
./bootstrap
make -j16
make install
cd ..

# Build gflags
git clone https://github.com/gflags/gflags.git
cd gflags
mkdir -p build/ && cd build
cmake -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=ON -DINSTALL_HEADERS=ON -DINSTALL_SHARED_LIBS=ON -DINSTALL_STATIC_LIBS=ON .. && make -j16
make install
cd ../../

# Build glog
git clone https://github.com/google/glog.git
cd glog
mkdir build && cd build
cmake .. && make -j16
make install
cd ../../

# Install Eigen 3.3.4
git clone https://github.com/eigenteam/eigen-git-mirror
#安装
cd eigen-git-mirror
mkdir build && cd build
cmake .. && make install
#安装后,头文件安装在/usr/local/include/eigen3/
#移动头文件
cp -r /usr/local/include/eigen3/Eigen /usr/local/include 
cd ../../


# Build Ceres
git clone https://ceres-solver.googlesource.com/ceres-solver
cd ceres-solver
mkdir -p build/ && cd build/
cmake .. && make -j16
make install
cd ../../


# # Build Boost,下面有更新的，舍弃
# wget -O boost_1_64_0.tar.gz https://sourceforge.net/projects/boost/files/boost/1.64.0/boost_1_64_0.tar.gz/download
# tar xzvf boost_1_64_0.tar.gz
# cd boost_1_64_0
# ./bootstrap.sh
# ./b2
# cd ..



# Get opencv source
mkdir -p opencv/build \
  && mkdir -p opencv/install \
  && cd opencv \
  && git clone https://github.com/opencv/opencv.git \
  && git clone https://github.com/opencv/opencv_contrib.git \
  && cd opencv \
  && git checkout 4.4.0 \
  && cd ../opencv_contrib \
  && git checkout 4.4.0 \
  && cd ../../

# Build opencv，contrib需要对应ceres版本
apt-get install build-essential pkg-config libgtk2.0-dev libavcodec-dev libavformat-dev libjpeg-dev libswscale-dev libtiff5-dev
cd opencv/build \
  && cmake ../opencv CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_GTK=ON -D OPENCV_GENERATE_PKGCONFIG=YES \
  && make -j16 \
  && make install \
  && cd ../../

# Get GTSAM prerequisites
apt-get install -y libboost-all-dev libtbb-dev

# Get GTSAM source
mkdir -p gtsam/build \
  && mkdir -p gtsam/install \
  && cd gtsam \
  && git clone https://github.com/borglab/gtsam.git \
  && cd gtsam \
  && git checkout 4.0.3 \
  && cd ../../

# Build GTSAM
cd gtsam/build \
  && cmake ../gtsam -DCMAKE_INSTALL_PREFIX=../install \
    -DGTSAM_BUILD_TESTS=0 -DGTSAM_BUILD_EXAMPLES_ALWAYS=0 -DGTSAM_ALLOW_DEPRICATED_SINCE_V4=0 -DGTSAM_BUILD_WRAP=0 \
    -DGTSAM_INSTALL_CPPUNITLITE=0 -DTSAM_WRAP_SERIALIZATION=0 \
  && make -j16 \
  && make install \
  && cd ../../

