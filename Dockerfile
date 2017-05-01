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
    apt-get install -y supervisor
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

CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]

EXPOSE 22 5901
