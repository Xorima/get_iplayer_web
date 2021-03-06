FROM centos:7
MAINTAINER Jason Field



WORKDIR /data
WORKDIR /data/config
WORKDIR /data/output
WORKDIR /app

RUN rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
RUN rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-1.el7.nux.noarch.rpm
RUN yum update -y
RUN yum install perl-libwww-perl perl-LWP-Protocol-https perl-XML-Simple perl-XML-LibXML perl-Env perl-CGI atomicparsley rtmpdump wget -y
RUN wget http://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz
RUN tar -xf ffmpeg-release-64bit-static.tar.xz
RUN install -m 777 ffmpeg-*-static/ffmpeg /usr/local/bin
RUN curl -kLO https://raw.github.com/get-iplayer/get_iplayer/master/get_iplayer
RUN install -m 777 ./get_iplayer /usr/local/bin
RUN curl -kLO https://raw.github.com/get-iplayer/get_iplayer/master/get_iplayer.cgi
RUN install -m 777 ./get_iplayer.cgi /usr/local/bin
RUN chmod 777 ./get_iplayer.cgi
RUN chmod 777 ./ffmpeg*
RUN chmod 777 ./get_iplayer

RUN groupadd -r iplayer -g 1000 && useradd -r -g iplayer iplayer -u 1000 -m -d /data/config/home
RUN chown iplayer:iplayer /data -R
RUN chown iplayer:iplayer /app -R
USER iplayer

ENTRYPOINT /bin/bash -c "./get_iplayer.cgi --listen 0.0.0.0 --port 1935"
