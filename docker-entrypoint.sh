#!/bin/bash

set -e

umask u+rxw,g+rwx,o-rwx

export PATH="$HOME/.yarn/bin:$PATH"
export CHROME_BIN="/usr/bin/chromium-browser"

Xvfb -ac :99 -screen 0 1280x1024x16 &

export DISPLAY=:99

exec "$@"
