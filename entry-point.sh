#!/bin/sh
MODE=$1
SSR=/usr/local/share/shadowsocksr
URL=https://codeload.github.com/shadowsocksrr/shadowsocksr/tar.gz/3.2.2
CONF=/etc/shadowsocksr/config.json
if [ "$MODE" = "server" ]; then
  BIN=shadowsocks/server.py
elif [ "$MODE" = "client" ]; then
  BIN=shadowsocks/local.py
else
  echo "Usage: $0 <mode>"
  exit 1
fi
if [ ! -f $CONF ]; then
  echo "Config file not loaded. Please map using docker volume - /path/to/your/file:$CONF"
  exit 2
fi
if [ ! -f $SSR/$BIN ]; then
  apk --no-cache add libsodium
  wget -O shadowsocksr.tar.gz $URL
  mkdir -p $SSR
  tar -zxf shadowsocksr.tar.gz -C $SSR --strip 1
fi
$SSR/$BIN -c $CONF
