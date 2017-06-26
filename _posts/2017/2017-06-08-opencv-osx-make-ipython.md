---
layout: post
title: "Install OpenCV on OSX, supporting ipython"
description: "OpenCV 提供了許多電腦視覺的工具。本文在 macOS 上使用 make install 编译安装 OpenCV 3.2.0，支持 python 3.6.x 接口的呼叫，并在 jupyter notebook (ipython) 中演示一個簡單的面部辨識程序。建立起在 macOS 上的 OpenCV 開發環境。"
category: computer-vision
tags: [computer-vision, homepage]
image-url: /assets/img/icon/icon-opencv.png
---

# make install OpenCV on OSX, supporting python3, pyenv, ipython

使用源码编译的方式，将 OpenCV 安装到 Mac OSX 上，可以用 pyenv virtualenv 的虚拟隔离环境 python3 呼叫。并连结到 jupyter notebook 上。

- python: 3.6.1
- OpenCV: 3.2.0
- macOS: Sierra 10.12.5

参考:  
Adam Gradzki : [Python 3.6, OpenCV 3.2, and PyEnv on macOS Sierra](https://medium.com/@nszceta/python-3-6-opencv-3-2-and-pyenv-on-macos-sierra-6ebcebd6193e)  
Alfredo Motta : [Create isolated Jupyter ipython kernels with pyenv and virtualenv](http://www.alfredo.motta.name/create-isolated-jupyter-ipython-kernels-with-pyenv-and-virtualenv/)  
pyimagesearch : [macOS: Install OpenCV 3 and Python 3.5](http://www.pyimagesearch.com/2016/12/05/macos-install-opencv-3-and-python-3-5/)

### STEP 1 : 建立 python 3.6.1 环境

```
# install python 3.6.1 with pyenv
$ env PYTHON_CONFIGURE_OPTS="--enable-shared" CFLAGS="-O2" pyenv install 3.6.1
$ pip install -U pip setuptools wheel cython numpy
```

先把 [pyenv + virtualenv](/programming/2015/04/19/python-pyenv-virtualenv.html) 安装好，接着在使用 pyenv install 安装新的 python 版本 `3.6.1` 的时候，需要使用 `--enable-shared` 的方式，才会有后面编译 OpenCV 时候需要的 dynamic library : `libpython3.6m.dylib`。

接着先将 pyenv 的默认环境 (global) 转到 3.6.1 上，pip 安装几个必要的 python packages

### STEP 2 : 安装 macOS 上需要的工具和函式库

```
# OpenCV prerequisites:
$ brew install cmake pkg-config
$ brew install jpeg  libpng libtiff openexr
$ brew install eigen tbb
$ brew install hdf5 libjpeg-turbo tesseract
```

检查一下 macOS 上有没有上述的工具，没有的话，利用 brew 安装上。之后编译 OpenCV 时候需要用到。

### STEP 3 : 下载 OpenCV &amp; contrib 源代码

```
$ cd /opt/src
$ git clone git@github.com:opencv/opencv.git
$ git clone git@github.com:opencv/opencv_contrib.git

# 接着转到 3.2.0 的版本 tag, 然后建立本地的分支
$ cd opencv
# git tag -l
$ git checkout tags/3.2.0 && git checkout -b 3.2.0

$ cd /opt/src/opencv_contrib
$ git checkout tags/3.2.0 && git checkout -b 3.2.0
```

接下来的源码编译操作，使用 git 将 opencv 下载到路径 `/opt/src` 之下，另外有个 repository:opencv_contrib 也需要一起，才能够支持 python 的呼叫。

### STEP 4 : 编译 OpenCV

先找到 pyenv 安装的 python 3.6.1 动态函式库在哪里，名称类似: libpython3.x.dylib  
`/Users/larrysu/.pyenv/versions/3.6.1/lib/libpython3.6m.dylib`

使用 cmake 完成 makefile 的设定；以下几个路径要改成符合自己环境，下面的值仅供参考，应该不难找到自己环境对应的路径：

- OPENCV_EXTRA_MODULES_PATH=/opt/src/opencv_contrib/modules
- PYTHON3_LIBRARY=/Users/larrysu/.pyenv/versions/3.6.1/lib/libpython3.6m.dylib
- PYTHON3_INCLUDE_DIR=/Users/larrysu/.pyenv/versions/3.6.1/include/python3.6m
- PYTHON3_EXECUTABLE=/Users/larrysu/.pyenv/versions/3.6.1/bin/python
- PYTHON3_PACKAGES_PATH=/Users/larrysu/.pyenv/versions/3.6.1/lib/python3.6/site-packages

```
$ mkdir /opt/src/opencv/build
$ cd /opt/src/opencv/build
$ cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D OPENCV_EXTRA_MODULES_PATH=/opt/src/opencv_contrib/modules \
    -D PYTHON3_LIBRARY=/Users/larrysu/.pyenv/versions/3.6.1/lib/libpython3.6m.dylib \
    -D PYTHON3_INCLUDE_DIR=/Users/larrysu/.pyenv/versions/3.6.1/include/python3.6m \
    -D PYTHON3_EXECUTABLE=/Users/larrysu/.pyenv/versions/3.6.1/bin/python \
    -D PYTHON3_PACKAGES_PATH=/Users/larrysu/.pyenv/versions/3.6.1/lib/python3.6/site-packages \
    -D BUILD_opencv_python2=OFF \
    -D BUILD_opencv_python3=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D INSTALL_C_EXAMPLES=OFF \
    -D BUILD_TIFF=ON \
    -D BUILD_opencv_java=OFF \
    -D ENABLE_FAST_MATH=1 \
    -D ENABLE_AVX=ON \
    -D WITH_OPENGL=ON \
    -D WITH_OPENCL=ON \
    -D WITH_IPP=OFF \
    -D WITH_TBB=ON \
    -D WITH_EIGEN=ON \
    -D WITH_V4L=OFF \
    -D WITH_VTK=OFF \
    -D WITH_CUDA=OFF \
    -D BUILD_EXAMPLES=ON ..

$ make -j8
$ make install
```

在 cmake 执行完成时候，应该要能看到如下图的画面，python3 相关的设定要能找到才可以。

![img](/assets/img/2017/opencv-cmake.png)

### STEP 5 : 制作 pyenv 的环境

```
# 先将 pyenv 的 默认 global 环境改回原来的 system，避免其他程序版本冲突
$ pyenv global system

$ pyenv virtualenv 3.6.1 p3cv
$ pip install -U pip setuptools wheel numpy
$ pip install ipykernel

# 将 opencv 的 python 函式库链接到 新的 pyenv 环境: p3cv 中。
$ ln -s ~/.pyenv/versions/3.6.1/lib/python3.6/site-packages/cv2.cpython-36m-darwin.so \
        ~/.pyenv/versions/p3cv/lib/python3.6/site-packages/cv2.cpython-36m-darwin.so
# 看看 python3 呼叫到的 opencv 版本
$ python -c "import cv2; print(cv2.__version__)"
```

### STEP 6 : 添加支持 opencv 的 jupyter kernel

```
# 建立 名为 p3cv 的 jupyter notebook kernel
mkdir /Users/larrysu/Library/Jupyter/kernels/p3cv
vim /Users/larrysu/Library/Jupyter/kernels/p3cv/kernel.json

# kernel.json 的内容如下
------------------------
{
 "argv": [ "/Users/larrysu/.pyenv/versions/p3cv/bin/python", "-m", "ipykernel",
          "-f", "{connection_file}"],
 "display_name": "p3cv",
 "language": "python"
}
------------------------

# 启动试试看。
$ jupyter notebook
```

在 jupyter notebook 运行个面部识别程序:

![img](/assets/img/2017/opencv-jupyter.jpg)
