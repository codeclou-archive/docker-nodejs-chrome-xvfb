FROM alpine:3.6

#
# BASE PACKAGES
#
RUN apk add --no-cache \
            bash \
            gnupg \
            git \
            curl \
            jq \
            zip \
            ca-certificates \
            nodejs-current \
            nodejs-npm \
            xvfb \
            chromium && \
            npm install npm@latest -g

#
# INSTALL AND CONFIGURE
#
COPY docker-entrypoint.sh /opt/docker-entrypoint.sh
RUN chmod u+rx,g+rx,o+rx,a-w /opt/docker-entrypoint.sh && \
    addgroup -g 10777 worker && \
    adduser -D -G worker -u 10777 worker && \
    mkdir /work/ && \
    mkdir /work-private/ && \
    mkdir /work-bin/ && \
    mkdir /data/ && \
    chown -R worker:worker /work/ && \
    chmod -R u+rwx,g+rwx,o-rwx /work/ && \
    chown -R worker:worker /work-private/ && \
    chown -R worker:worker /work-bin/ && \
    chown -R worker:worker /data/ && \
    chmod -R u+rwx,g+rwx,o-rwx /work-private/ && \
    rm -rf /tmp/* /var/cache/apk/*

ENV DISPLAY :99.0
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

#
# MAKE FONTCONFIG WORK - SEE: https://github.com/codeclou/docker-oracle-jdk/blob/master/test/fontconfig/README.md
#
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/jdk/jre/lib/amd64/server/:/usr/lib/:/lib/
RUN apk add --no-cache libgcc \
                       ttf-dejavu \
                       fontconfig \
                       libgcc

#
# RUN
#
EXPOSE 2990
USER worker

#
# YARN INSTALL
#
RUN curl -o- -L https://yarnpkg.com/install.sh | bash

WORKDIR /work/
VOLUME ["/work"]
VOLUME ["/work-private"]
VOLUME ["/work-bin"]
VOLUME ["/data"]
ENTRYPOINT ["/opt/docker-entrypoint.sh"]
CMD ["npm", "-version"]
