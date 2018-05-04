FROM openjdk:8u121-alpine
MAINTAINER Remon Lam [remon@containerstack.io]

# Setting environment variables

ENV BITBUCKET_VERSION=5.4.0

ENV JVM_MINIMUM_MEMORY="512m"
ENV JVM_MAXIMUM_MEMORY="4G"
# NOTE: depending on the deployment size JVM memory settings should be tuned
ENV RUN_USER daemon
ENV RUN_GROUP daemon
# https://confluence.atlassian.com/display/BitbucketServer/Bitbucket+Server+home+directory
ENV BITBUCKET_HOME /var/atlassian/application-data/bitbucket
ENV BITBUCKET_INSTALL_DIR /opt/atlassian/bitbucket
ENV CONF_VERSION 6.3.0

# Setting variables used at container build
ARG DOWNLOAD_URL=https://downloads.atlassian.com/software/stash/downloads/atlassian-bitbucket-${BITBUCKET_VERSION}.tar.gz

# Installing dependencies
RUN apk update -qq \
    && update-ca-certificates \
    && apk add ca-certificates wget curl git openssh bash procps openssl perl ttf-dejavu tini \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*

# Copy the entryfile and rename it to 'entrypoint'
# NOTE: entrypoint needs to be executable...
COPY entrypoint.sh /entrypoint

# Install Bitbucket
RUN mkdir -p ${BITBUCKET_INSTALL_DIR} \
    && curl -L --silent ${DOWNLOAD_URL} | tar -xz --strip-components=1 -C "$BITBUCKET_INSTALL_DIR" \
    && chown -R ${RUN_USER}:${RUN_GROUP} ${BITBUCKET_INSTALL_DIR}/

VOLUME ["${BITBUCKET_HOME}"]

# Expose the HTTP and SSH ports
EXPOSE 7990
EXPOSE 7999

# Set working directory
WORKDIR $BITBUCKET_HOME

CMD ["/entrypoint", "-fg"]
ENTRYPOINT ["/sbin/tini", "--"]
