#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y \
  build-essential \
  cmake \
  git \
  libsdl2-dev \
  libsdl2-mixer-dev \
  libpng-dev

if [ ! -d /home/vagrant/openclaw/.git ]; then
  sudo -u vagrant git clone https://github.com/opentheclaw/openclaw.git /home/vagrant/openclaw
fi

cd /home/vagrant/openclaw
sudo -u vagrant mkdir -p build
cd build
sudo -u vagrant cmake ..
sudo -u vagrant cmake --build . -j"$(nproc)"
