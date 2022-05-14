###
###
### WARNING : THIS IMAGE IS PUBLISHED PUBLICLY - DO NOT PUT SECRETS IN IT
###
###

# Salesforce documentaton used to create this Dockerfile
# Installation: https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_install_cli.htm#sfdx_setup_install_cli_linux
# CI-friendly configuration: https://trailhead.salesforce.com/en/content/learn/projects/automate-cicd-with-gitlab/package-your-app-and-automate-cicd
# Sample CI project from SF: https://trailhead.salesforce.com/en/content/learn/modules/sfdx_travis_ci/sfdx_travis_ci_setup

FROM debian:stable-slim AS builder

WORKDIR /tmp

ENV NODE_VERSION=v17.7.1
ENV NODEJS_DOWNLOAD_URL=https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.gz

ENV SALESFORCE_CLI_URL=https://developer.salesforce.com/media/salesforce-cli/sfdx/channels/stable/sfdx-linux-x64.tar.xz
ENV SFDX_HIDE_RELEASE_NOTES=true

RUN apt-get update && apt-get install -y curl xz-utils

RUN curl -sLO ${SALESFORCE_CLI_URL} \
    && mkdir /tmp/sfdx-cli \
    && tar -xJf sfdx-linux-x64.tar.xz -C sfdx-cli --strip-components 1 \
    && /tmp/sfdx-cli/bin/sfdx update 

RUN curl -sLO ${NODEJS_DOWNLOAD_URL} \
    && tar -xzf node-${NODE_VERSION}-linux-x64.tar.gz \
    && mkdir node \
    && tar -xzf node-${NODE_VERSION}-linux-x64.tar.gz -C node --strip-components=1

RUN apt-get -y install git

RUN which git

FROM debian:stable-slim AS installer

WORKDIR /root

ENV SFDX_AUTOUPDATE_DISABLE=true
ENV SFDX_USE_GENERIC_UNIX_KEYCHAIN=true
ENV SFDX_DOMAIN_RETRY=180
ENV SFDX_LOG_LEVEL=INFO

COPY --from=builder /tmp/node /opt/node
RUN ln -s /opt/node/bin/node /usr/bin/node \
    && ln -s /opt/node/bin/npm /usr/bin/npm

COPY --from=builder /tmp/sfdx-cli/ /opt/sfdx-cli
RUN mkdir -p  /root/.local/share/sfdx/ \
    && ln -s /opt/sfdx-cli/bin/sfdx /usr/local/bin/sfdx \
    && echo "This image SFDX version and plugin versions are:" \
    && sfdx --version \
    && echo "y" | sfdx plugins:install sfdx-git-delta \
    && sfdx plugins --core \
    && sfdx plugins

COPY --from=builder /usr/bin/git /usr/bin/git
