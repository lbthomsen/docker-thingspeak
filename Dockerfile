FROM debian

MAINTAINER Lars Boegild Thomsen <lth@bright-things.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update 
RUN apt-get upgrade -y
RUN apt-get install -y build-essential libpq-dev ruby git bundler libmysqlclient15-dev mysql-client libsqlite3-dev

WORKDIR /opt/

# thingspeak SETUP
RUN git clone https://github.com/iobridge/thingspeak.git
WORKDIR /opt/thingspeak
RUN bundle install

# DB setup
ADD database.yml config/database.yml

# add user thingspeak to image
RUN groupadd -r thingspeak && useradd -r -g thingspeak thingspeak
RUN chown -R thingspeak /opt/thingspeak
RUN chgrp -R thingspeak /opt/thingspeak

# process run as thingspeak user
USER thingspeak

EXPOSE 3000
