# Github runner
 
# alpine:3.16.9
FROM alpine@sha256:0db9d004361b106932f8c7632ae54d56e92c18281e2dd203127d77405020abf6

# Install basic commands
RUN apk add busybox=1.35.0-r18 && \
    apk add bash=5.1.16-r2 && \
    apk add curl=8.5.0-r0 && \
    apk add gettext=0.21-r2 && \
    apk add grep=3.7-r0 && \
    apk add tar=1.34-r1 && \
    apk add iptables=1.8.8-r1 && \
    rm -rf /var/cache/apk/*

# Install Jq
ARG JQ_VERSION="1.7.1"

RUN curl --silent --proto '=https' --tlsv1.2 -fOL https://github.com/jqlang/jq/releases/download/jq-${JQ_VERSION}/jq-linux-amd64 && \
    cp jq-linux-amd64 /usr/local/bin/jq && \
    chmod +x /usr/local/bin/jq && \
    rm jq-linux-amd64

# Install Python
RUN apk add alpine-sdk=1.0-r1 && \
    apk add ca-certificates=20240226-r0 && \
    apk add libssl1.1=1.1.1w-r1 && \
    apk add gdbm=1.23-r0 && \
    apk add readline=8.1.2-r0 && \
    apk add libbz2=1.0.8-r1 && \
    apk add ncurses-libs=6.3_p20220521-r1 && \
    apk add sqlite-libs=3.40.1-r1 && \
    apk add zlib-dev=1.2.12-r3 && \
    apk add bzip2=1.0.8-r1 && \
    apk add libffi=3.4.2-r1 && \
    apk add openssl-dev=1.1.1w-r1 && \
    apk add ethtool=5.17-r0 && \
    apk add python3-dev=3.10.14-r1 && \
    apk add py3-pip=22.1.1-r0 && \
    apk add musl-dev=1.2.3-r3 && \
    apk add linux-headers=5.16.7-r1 && \
    rm -rf /var/cache/apk/*

# Install Azure CLI
RUN pip install azure-cli==2.65.0 --no-cache-dir --ignore-installed && \
    pip install --force-reinstall -v "azure-mgmt-rdbms==10.2.0b17" --ignore-installed

# Install docker
ARG DOCKER_VERSION="27.3.1"

RUN curl --silent --proto '=https' --tlsv1.2 -fOL https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz && \
    tar -xzf docker-${DOCKER_VERSION}.tgz -C /tmp && \
    mv /tmp/docker/* /usr/bin/ && \
    rm docker-${DOCKER_VERSION}.tgz

# Install Actions Runner
ARG ACTIONS_RUNNER_VERSION="2.322.0"
 
RUN mkdir actions-runner && \
    cd actions-runner && \
    curl --silent --proto '=https' --tlsv1.2 -fOL https://github.com/actions/runner/releases/download/v${ACTIONS_RUNNER_VERSION}/actions-runner-linux-x64-${ACTIONS_RUNNER_VERSION}.tar.gz -o actions-runner-linux-x64-${ACTIONS_RUNNER_VERSION}.tar.gz && \
    tar xzf actions-runner-linux-x64-${ACTIONS_RUNNER_VERSION}.tar.gz && \
    rm actions-runner-linux-x64-${ACTIONS_RUNNER_VERSION}.tar.gz