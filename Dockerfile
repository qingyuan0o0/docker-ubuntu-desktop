FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Asia/Shanghai

RUN sudo locale-gen zh_CN.UTF-8
ENV LANG zh_CN.UTF-8

RUN useradd -m myuser && echo 'myuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers  
RUN apt-get update && \
    apt-get install -y --no-install-recommends ubuntu-desktop && \
    apt-get install -y gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal && \
    apt-get install -y tightvncserver && \   
    mkdir /home/myuser/.vnc && \
    apt-get install -y openssh-server supervisor vim git firefox firefox-locale-zh-hans ttf-wqy-microhei libnet1-dev libpcap0.8-dev && \
    apt-get install -y language-pack-zh-hans-base language-pack-zh-hans language-pack-gnome-zh-hans language-pack-gnome-zh-hans-base && \
    apt-get clean
##
COPY supervisord.conf /etc/supervisord.conf
##
COPY reset.sh /home/myuser/reset.sh
COPY check.sh /home/myuser/check.sh
COPY vnc.sh /home/myuser/.vnc/vnc.sh
RUN chmod +x /home/myuser/*.sh /home/myuser/.vnc/vnc.sh && \
    git clone https://github.com/snooda/net-speeder.git net-speeder && \
    git clone https://github.com/novnc/noVNC.git
WORKDIR net-speeder
RUN sh build.sh && \
    mv net_speeder /usr/local/bin/

ADD xstartup /home/myuser/.vnc/xstartup
ADD passwd /home/myuser/.vnc/passwd

ADD entrypoint.sh /usr/sbin
RUN chmod 600 /home/myuser/.vnc/passwd && \
    chmod +x /usr/sbin/entrypoint.sh /usr/local/bin/net_speeder
WORKDIR /home/myuser
ENV USER myuser
USER myuser

CMD entrypoint.sh
