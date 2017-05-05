FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive
ENV USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends ubuntu-desktop && \
    apt-get install -y gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal && \
    apt-get install -y tightvncserver && \
    mkdir /root/.vnc
##
RUN apt-get install -y openssh-server && \
    apt-get install -y supervisor && \
    apt-get install -y make && \
    apt-get install -y gcc && \
    apt-get install -y git
RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
##
COPY supervisord.conf /etc/supervisord.conf
##
COPY reset.sh /root/reset.sh
COPY check.sh /root/check.sh
RUN chmod +x /root/*.sh

ADD xstartup /root/.vnc/xstartup
ADD passwd /root/.vnc/passwd

RUN chmod 600 /root/.vnc/passwd
ADD entrypoint.sh /usr/sbin
RUN chmod +x /usr/sbin/entrypoint.sh

EXPOSE 22 5901 25 3000 443 4000/udp 53 53/udp 3306 13389 23389 33389 43389 53389 80 8080 138
ENTRYPOINT ["entrypoint.sh"]


