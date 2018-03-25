FROM ruby:2.5.0

RUN apt update && apt install -y lsb-release software-properties-common
RUN cat > /etc/apt/sources.list && \
    add-apt-repository "deb http://ftp.jp.debian.org/debian/ $(lsb_release -s -c) main" &&\
    apt update &&\
    apt upgrade -y && apt install -y vim-nox emacx-nox jq curl git less
RUN curl -L 'https://cdn.rawgit.com/harelba/q/1.7.1/bin/q?source=install_page&table=1' > /usr/bin/q && chmod +x /usr/bin/q

RUN mkdir /app
WORKDIR /app
ADD . /app
