FROM ubuntu:18.04
LABEL maintainer="shockwavenn@gmail.com"

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ADD . /root
RUN apt-get -y update && \
    apt-get -y install sudo
RUN bash /root/restore-backup.sh
EXPOSE 80
CMD service apache2 start && \
    service mysql start && \
    bash
