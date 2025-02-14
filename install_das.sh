#!/bin/bash -e

install_multicorn2() {
    local -r version=$1
    rm -rf /build/multicorn2
    mkdir -p /build/multicorn2
    cd /build/multicorn2
    git clone https://github.com/raw-labs/multicorn2.git
    cd multicorn2
    git checkout $version
    apt install -y build-essential libreadline-dev zlib1g-dev flex bison libxml2-dev libxslt-dev libssl-dev libxml2-utils xsltproc
    apt install -y python3 python3-dev python3-setuptools python3-pip
    make
    make install
}

install_multicorn_das() {
    local -r version=$1
    rm -rf /build/multicorn-das
    mkdir -p /build/multicorn-das
    cd /build/multicorn-das
    git clone https://github.com/raw-labs/multicorn-das.git
    cd multicorn-das
    git checkout $version
    pip3 install --break-system-packages .
}

main() {
    original_dir=$(pwd)
    install_multicorn2 $1
    install_multicorn_das $2
    cd $original_dir
}

# $1 is multicorn2, $2 is multicorn-das
main $1 $2