# Github runner
 
# ubuntu:24.04
FROM ubuntu@sha256:72297848456d5d37d1262630108ab308d3e9ec7ed1c3286a32fe09856619a782

# Install basic commands
RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive TZ=Europe/Madrid apt-get -qq -y --no-install-recommends install ca-certificates \
        curl git iptables libc6 libgcc-s1 libicu74 liblttng-ust1 libssl3 libstdc++6 libunwind8 zlib1g \
        python-is-python3 python3 python3-pip wget && \
    apt-get clean

# Install Jq
ARG JQ_VERSION="1.7.1"

RUN curl --silent --proto '=https' --tlsv1.2 -fOL https://github.com/jqlang/jq/releases/download/jq-${JQ_VERSION}/jq-linux-amd64 && \
    cp jq-linux-amd64 /usr/local/bin/jq && \
    chmod +x /usr/local/bin/jq && \
    rm jq-linux-amd64

# Install Azure CLI
ENV PIP_BREAK_SYSTEM_PACKAGES=1
RUN pip install azure-cli==2.65.0 --no-cache-dir --ignore-installed && \
    pip install --force-reinstall -v "azure-mgmt-rdbms==10.2.0b17" --ignore-installed

# Install Dotnet 6
ARG DOTNET_INSTALL_DIR="/usr/share/dotnet"
 
ADD https://dot.net/v1/dotnet-install.sh dotnet-install.sh
RUN chmod +x ./dotnet-install.sh && \
    ./dotnet-install.sh --version 6.0.428 --install-dir ${DOTNET_INSTALL_DIR} --no-path && \
    rm dotnet-install.sh
 
ENV PATH="${PATH}:${DOTNET_INSTALL_DIR}"
ENV DOTNET_ROOT="${DOTNET_INSTALL_DIR}"

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
    rm actions-runner-linux-x64-${ACTIONS_RUNNER_VERSION}.tar.gz && \
    RUNNER_ALLOW_RUNASROOT=1 ./bin/installdependencies.sh