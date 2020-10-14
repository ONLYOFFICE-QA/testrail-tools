FROM ubuntu:20.04

ADD . /root
RUN apt-get -y update && \
    apt-get -y install sudo
RUN bash /root/restore-backup.sh
EXPOSE 80
CMD service apache2 start
