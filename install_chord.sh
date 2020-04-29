#!/usr/bin/env bash
#
# Installs chord_singularity on an ubuntu machine
#
set -euo pipefail

export GO_VERSION=1.13
export SINGULARITY_VERSION=3.5.2
export KEYCLOAK_VERSION=9.0.3
export OS=linux ARCH=amd64

function ubuntu_packages() {
    echo "### Installing ubuntu packages"

    apt-get update && sudo apt-get install -y \
        build-essential \
        libssl-dev \
        uuid-dev \
        libgpgme11-dev \
        squashfs-tools \
        libseccomp-dev \
        wget \
        pkg-config \
        git \
        cryptsetup

    apt-get -y install python3 python-dev python3-pip python3-venv
}

function install_go() {
    echo "### Installing Go"

    local install_path=${1:-/usr/local}

    wget --no-verbose https://dl.google.com/go/go${GO_VERSION}.$OS-$ARCH.tar.gz \
      && sudo tar -C ${install_path} -xzf go${GO_VERSION}.$OS-$ARCH.tar.gz \
      && rm go${GO_VERSION}.$OS-$ARCH.tar.gz

    export PATH=${install_path}/go/bin:${PATH:-.}
    echo "export PATH=${install_path}/go/bin:$PATH" >> ~/.bashrc
}

function install_singularity() {
    if [[ $( type go ) ]];
    then
        echo "## Found go - installing singularity"
    else
        echo "## Could not find go; aborting"
        exit 1;
    fi

    wget --no-verbose https://github.com/sylabs/singularity/releases/download/v${SINGULARITY_VERSION}/singularity-${SINGULARITY_VERSION}.tar.gz \
        && tar -xzf singularity-${SINGULARITY_VERSION}.tar.gz \
        && cd singularity \
        && ./mconfig \
        && make -C builddir \
        && sudo make -C builddir install
}

function install_chord_singularity() {
    echo "## Installing chord_singularity from git"
    cd
    git clone https://github.com/c3g/chord_singularity.git
    cd chord_singularity

    python3 -m venv ~/env
    source ~/env/bin/activate

    echo "## Building singularity image"
    ./dev_utils.py build
}

function install_certbot() {
    echo "# Installing certbot"
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository universe
    sudo add-apt-repository ppa:certbot/certbot
    sudo apt-get update
    sudo apt-get install -y certbot python-certbot-nginx
}

function install_nginx() {
    echo "# Installing nginx"
    sudo apt-get install -y nginx
}

function install_keycloak() {
    echo "# Installing keycloak"
    sudo apt-get install -y default-jdk \
        && cd /opt \
        && sudo wget --no-verbose https://downloads.jboss.org/keycloak/${KEYCLOAK_VERSION}/keycloak-${KEYCLOAK_VERSION}.tar.gz \
        && sudo tar -xvzf keycloak-${KEYCLOAK_VERSION}.tar.gz \
        && sudo mv keycloak-${KEYCLOAK_VERSION} /opt/keycloak \
        && sudo groupadd keycloak \
        && sudo useradd -r -g keycloak -d /opt/keycloak -s /sbin/nologin keycloak \
        && sudo chown -R keycloak: keycloak \
        && sudo chmod o+x /opt/keycloak/bin/ \
        && cd /etc \
        && sudo mkdir keycloak \
        && sudo cp /opt/keycloak/docs/contrib/scripts/systemd/wildfly.conf /etc/keycloak/keycloak.conf \
        && sudo cp /opt/keycloak/docs/contrib/scripts/systemd/launch.sh /opt/keycloak/bin/ \
        && sudo sed -i -e 's#opt/wildfly#opt/keycloak#' /opt/keycloak/bin/launch.sh \
        && sudo chown keycloak: /opt/keycloak/bin/launch.sh \
        && sudo cp ~/chord_scripts/keycloak.service /etc/systemd/system/keycloak.service

    sudo systemctl daemon-reload
    cd ${HOME}
}

echo "# Setting up VM for CHORD..."
ubuntu_packages
install_go
install_singularity
install_chord_singularity

echo "# Installing nginx, certbot, keycloak"
install_nginx
install_certbot
install_keycloak
