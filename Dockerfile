FROM ubuntu:16.04

#
# BASE PACKAGES
#
RUN apt-get -qqy update \
    && apt-get -qqy --no-install-recommends install \
    bzip2 \
    ca-certificates \
    unzip \
    wget \
    curl \
    jq \
    xvfb \
    pulseaudio \
    dbus \
    dbus-x11 \
    build-essential && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

#
# NODEJS
#
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get update -qqy && apt-get -qqy install -y nodejs && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

#
# CHROME
#
ARG CHROME_VERSION="google-chrome-stable"
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update -qqy && apt-get -qqy install ${CHROME_VERSION:-google-chrome-stable} && \
    rm /etc/apt/sources.list.d/google-chrome.list && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* && \
    ln -s /usr/bin/google-chrome /usr/bin/chromium-browser

#
# YARN
#
RUN wget -q -O - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qqy && apt-get -qqy install yarn && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

#
# INSTALL AND CONFIGURE
#
COPY docker-entrypoint.sh /opt/docker-entrypoint.sh
RUN chmod u+rx,g+rx,o+rx,a-w /opt/docker-entrypoint.sh && \
    addgroup --gid 10777 worker && \
    adduser --gecos "" --disabled-login --disabled-password --gid 10777 --uid 10777 worker && \
    mkdir /work/ && \
    mkdir /work-private/ && \
    mkdir /work-bin/ && \
    mkdir /data/ && \
    mkdir /tmp/.X11-unix && \
    chown -R root:root /tmp/.X11-unix && \
    chmod 1777 /tmp/.X11-unix && \
    chown -R worker:worker /work/ && \
    chmod -R u+rwx,g+rwx,o-rwx /work/ && \
    chown -R worker:worker /work-private/ && \
    chown -R worker:worker /work-bin/ && \
    chown -R worker:worker /data/ && \
    chmod -R u+rwx,g+rwx,o-rwx /work-private/


#
# DBUS
#
COPY dbus-system.conf /work-bin/dbus-system.conf
RUN mkdir /var/run/dbus/ && \
    chown -R worker:worker /var/run/dbus/


#
# RUN
#
USER worker

WORKDIR /work/
VOLUME ["/work"]
VOLUME ["/work-private"]
VOLUME ["/work-bin"]
VOLUME ["/data"]
ENTRYPOINT ["/opt/docker-entrypoint.sh"]
CMD ["yarn", "--version"]
