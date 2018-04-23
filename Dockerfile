FROM ubuntu:14.04

ADD DOCKER_VERSION .

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    openssh-server \
    build-essential \
    libtool \
    cmake \
    libunwind8-dev \
    uuid-dev \
    libxml2-dev \
    libssl-dev \
    libssh2-1-dev \
    lttng-tools \
    lttng-modules-dkms \
    liblttng-ust-dev \
    locales \
    libcgroup-dev \
    libib-util \
    libcurl3 \
    git \
    libtool \
    autoconf \
    automake \
    libglib2.0-0 \
    libglib2.0-dev \
    bison \
    flex \
    libpopt-dev \
    libncurses5-dev \
    libncursesw5-dev \
    swig \
    libedit-dev \
    chrpath \
    curl

# Install the .NET runtime dependency.  Required for running the product.
RUN curl -k https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg && \
    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-trusty-prod trusty main" > /etc/apt/sources.list.d/dotnetdev.list' && \
    apt-key adv --keyserver apt-mo.trafficmanager.net --recv-keys 417A0893 && \
    apt-get install -y apt-transport-https apt-utils && \
    apt-get -y --reinstall install ca-certificates && \
    apt-get update  -o 'Debug::Acquire::https=true' && \
    apt-get install -y dotnet-runtime-2.0.6 cmake3 && \
    apt-get remove -y apt-transport-https apt-utils

RUN curl -k https://www.openssl.org/source/openssl-1.0.2l.tar.gz | tar xz && \
    cd openssl-1.0.2l && \
    ./config && \
    make && \
    make install && \
    ln -sf /usr/local/ssl/bin/openssl /usr/bin/openssl && \
    openssl version -v

RUN apt-get install -y --force-yes apt-transport-https apt-utils software-properties-common python-software-properties && \
    apt-add-repository ppa:lttng/ppa -y && \
    apt-get update && \
    apt-get install lttng-tools lttng-modules-dkms -y

# Add legacy binary dependencies
ADD https://sfossdeps.blob.core.windows.net/binaries/v0.1.tgz /tmp
RUN mkdir -p /external && tar -xvf /tmp/v0.1.tgz -C / && \
     rm /tmp/v0.1.tgz

RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
