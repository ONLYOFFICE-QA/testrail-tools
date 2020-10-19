FROM ubuntu:18.04
LABEL maintainer="shockwavenn@gmail.com"

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ADD . /root
RUN apt-get -y update && \
    apt-get -y install sudo
EXPOSE 80
CMD bash /root/restore-backup.sh && \
    service apache2 start && \
    bash
