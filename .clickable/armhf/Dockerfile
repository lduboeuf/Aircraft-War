FROM clickable/ubuntu-sdk:16.04-armhf
RUN echo set debconf/frontend Noninteractive | debconf-communicate && echo set debconf/priority critical | debconf-communicate

RUN apt-get update && apt-get install -y --force-yes --no-install-recommends qtwebengine5-dev:armhf && apt-get clean