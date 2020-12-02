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
    apt install -qqy sudo git zsh openssh-server gcc g++ cmake cmake-gui make gdb clang unzip libopencv-dev tldr&& \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir /var/run/sshd && \
    useradd -m -G sudo -s /usr/bin/zsh user && \
    echo 'user:1' | chpasswd && \
    echo 'user ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/user && \
    chmod 440 /etc/sudoers.d/user

USER user
WORKDIR /home/user

ARG COMMIT_ID=fcac248b077b55bae4ba5bab613fd6e9156c2f0c
RUN mkdir -p ~/.ssh && \
    chmod 700 ~/.ssh && \
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh && \
    git clone https://github.com/sindresorhus/pure.git "$HOME/.oh-my-zsh/themes/pure" && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && \
    mkdir -p ~/.vscode-server/bin/$COMMIT_ID &&\
    wget https://update.code.visualstudio.com/commit:$COMMIT_ID/server-linux-x64/stable -O  ~/.vscode-server/bin/$COMMIT_ID/vscode-server-linux-x64.tar.gz && \
    cd ~/.vscode-server/bin/$COMMIT_ID && \
    tar -xvzf vscode-server-linux-x64.tar.gz --strip-components 1 && \
    rm ~/.vscode-server/bin/$COMMIT_ID/vscode-server-linux-x64.tar.gz && \
    mkdir -p ~/.tldr && \
    git clone https://github.com/tldr-pages/tldr.git ~/.tldr/tldr


ENV TZ=Asia/Shanghai \
    LANG=C.UTF-8

EXPOSE 22

CMD [ "sudo", "/usr/sbin/sshd", "-D" ]
