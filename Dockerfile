FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive
ENV USER root
ENV TZ Asia/Shanghai

RUN locale-gen zh_CN.UTF-8
ENV LANG zh_CN.UTF-8

RUN apt-get update && \
    apt-get install -y xorg lxde-core && \
    apt-get install -y tightvncserver wget && \
    apt-get clean && \
    mkdir /root/.vnc 
##
RUN apt-get update && apt-get install -y openssh-server supervisor vim git autocutsel firefox firefox-locale-zh-hans ttf-wqy-microhei libnet1-dev libpcap0.8-dev && \
    apt-get install -y language-pack-zh-hans-base language-pack-zh-hans language-pack-gnome-zh-hans language-pack-gnome-zh-hans-base && \
    mkdir /var/run/sshd && \
    echo 'root:root' |chpasswd && \
    sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config  && \
    apt-get clean
    
COPY supervisord.conf /etc/supervisord.conf

COPY reset.sh /root/reset.sh
COPY check.sh /root/check.sh
COPY vnc.sh /root/.vnc/vnc.sh
RUN chmod +x /root/*.sh /root/.vnc/vnc.sh && \
    git clone https://github.com/snooda/net-speeder.git net-speeder && \
    git clone https://github.com/novnc/noVNC.git
WORKDIR net-speeder
RUN sh build.sh && \
    mv net_speeder /usr/local/bin/

ADD xstartup /root/.vnc/xstartup
ADD passwd /root/.vnc/passwd

ADD entrypoint.sh /usr/sbin
RUN chmod 600 /root/.vnc/passwd && \
    chmod +x /usr/sbin/entrypoint.sh /usr/local/bin/net_speeder
WORKDIR /root

EXPOSE 6080
ENTRYPOINT ["entrypoint.sh"]


