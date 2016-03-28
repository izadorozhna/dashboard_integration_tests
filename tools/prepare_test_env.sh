#!/bin/bash -xe

PYTHON_VERSION="${PYTHON_VERSION:-2.7.9}"
PYTHON_LOCATION="https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz"
PIP_LOCATION="https://bootstrap.pypa.io/get-pip.py"

message() {
    printf "\e[33m%s\e[0m\n" "${1}"
}

install_system_requirements() {
    message "Enable default CentOS repo"
    yum -y reinstall centos-release

    message "Installing system requirements"
    yum -y install gcc
    yum -y install zlib-devel
    yum -y install readline-devel
    yum -y install bzip2-devel
    yum -y install libgcrypt-devel
    yum -y install openssl-devel
    yum -y install libffi-devel
    yum -y install libxml2-devel
    yum -y install libxslt-devel
    yum -y install python-devel
    yum -y install python-pip
    yum -y install firefox
    yum -y install xorg-x11-server-Xvfb
}

install_python27_pip_virtualenv() {
    message "Installing Python 2.7"
    if command -v python2.7 &>/dev/null; then
        message "Python 2.7 already installed!"
    else
        local temp_dir="$(mktemp -d)"
        cd ${temp_dir}
        wget ${PYTHON_LOCATION}
        tar xzf Python-${PYTHON_VERSION}.tgz
        cd Python-${PYTHON_VERSION}
        ./configure --prefix=/usr/local --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
        make -j5 altinstall
    fi

    message "Installing Pip 2.7"
    if command -v pip2.7 &>/dev/null; then
        message "Pip 2.7 already installed!"
    else
        message "Installing pip for Python 2.7"
        local get_pip_file="$(mktemp)"
        wget -O ${get_pip_file} ${PIP_LOCATION}
        python2.7 ${get_pip_file}
        pip2.7 install -U tox
    fi

    message "Installing virtualenv"
    if command -v virtualenv &>/dev/null; then
        message "virtualenv already installed!"
    else
        message "Installing virtualenv for Python 2.7"
        pip2.7 install virtualenv
    fi
}

main() {
    install_system_requirements
    install_python27_pip_virtualenv
}

main "$@"


