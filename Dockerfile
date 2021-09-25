FROM debian:stable

ENV TERM=xterm

RUN apt-get update -y && \
    apt-get upgrade -y

RUN apt-get update && \
    apt-get install -y apt-utils && \
    apt-get install -y  postgresql-client   \
                        nginx               \
                        sudo                \
                        procps              \
                        php

RUN groupadd -g 500 server
RUN useradd -m -g server -c "Web" -s /bin/bash web
RUN usermod -aG sudo web

RUN echo "web:web" | chpasswd

RUN mkdir -p /home/web/server/
RUN chown -R web:server /home/web/server/
RUN chmod +s /usr/sbin/nginx

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

USER web
WORKDIR /home/web

COPY . /home/web/server/
WORKDIR /home/web/server/

ENTRYPOINT ["/home/web/server/entrypoint.sh"]
