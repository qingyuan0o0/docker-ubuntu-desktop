FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive
ENV USER root
ENV TZ Asia/Shanghai

RUN apt-get update && \
    apt-get install -y --no-install-recommends ubuntu-desktop && \
    apt-get install -y gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal && \
    apt-get install -y tightvncserver && \
    mkdir /root/.vnc
##
RUN apt-get install -y openssh-server supervisor vim make gcc git firefox ttf-wqy-microhei libnet1-dev libpcap0.8-dev

RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
##
COPY supervisord.conf /etc/supervisord.conf
##
COPY reset.sh /root/reset.sh
COPY check.sh /root/check.sh
COPY vnc.sh /root/vnc.sh
COPY rinetd_install.sh /root/rinetd_install.sh
COPY port.sh /root/port.sh
RUN chmod +x /root/*.sh

RUN git clone https://github.com/snooda/net-speeder.git net-speeder
WORKDIR net-speeder
RUN sh build.sh
RUN mv net_speeder /usr/local/bin/

ADD xstartup /root/.vnc/xstartup
ADD passwd /root/.vnc/passwd

RUN chmod 600 /root/.vnc/passwd
ADD entrypoint.sh /usr/sbin
RUN chmod +x /usr/sbin/entrypoint.sh /usr/local/bin/net_speeder

EXPOSE 22 5901 443 80
ENTRYPOINT ["entrypoint.sh"]


