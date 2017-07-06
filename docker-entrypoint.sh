#!/bin/bash

set -e

umask u+rxw,g+rwx,o-rwx

export CHROME_BIN="/usr/bin/google-chrome"
export DISPLAY=:0

Xvfb -ac :0 -screen 0 1280x1024x16 &

exec "$@"
