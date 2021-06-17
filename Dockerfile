#===================================================
# https://github.com/P3TERX/ubuntu-plus
# Description: Ubuntu image with some extra packages
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#===================================================
ARG IMAGE_TAG=latest
FROM ubuntu:$IMAGE_TAG

LABEL maintainer cat

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -qq && apt upgrade -qqy && \
    apt install -qqy sudo vim git zsh openssh-server cmake cmake-curses-gui clang zip unzip libopencv-dev protobuf-compiler libprotobuf-dev tldr python3-pip python3-dev python3-venv gdb ffmpeg htop icdiff&& \
    apt clean && \
    pip3 install -U pip && \
    pip3 install pandas mxnet-cu102 opencv-python numpy pillow onnx-simplifier autopep8 && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache/pip && \
    mkdir /var/run/sshd && \
    useradd -m -G sudo -s /usr/bin/zsh user && \
    echo 'user:1' | chpasswd && \
    echo 'user ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/user && \
    chmod 440 /etc/sudoers.d/user

USER user
WORKDIR /home/user

RUN mkdir -p ~/.ssh && \
    chmod 700 ~/.ssh

ENV TZ=Asia/Shanghai \
    LANG=C.UTF-8

EXPOSE 22

CMD [ "sudo", "/usr/sbin/sshd", "-D" ]
