# docker-nodejs-xvfb-chrome

[![](https://codeclou.github.io/doc/badges/generated/docker-image-size-320.svg)](https://hub.docker.com/r/codeclou/docker-nodejs-chrome-xvfb/tags/) [![](https://codeclou.github.io/doc/badges/generated/docker-from-ubuntu-16.04.svg)](https://www.ubuntu.com/) [![](https://codeclou.github.io/doc/badges/generated/docker-run-as-non-root.svg)](https://docs.docker.com/engine/reference/builder/#/user)

Docker-Image to run [NodeJS](https://nodejs.org/en/) for dockerized builds and xvfb with google chrome.

It provides:

| tool | version |
|------|---------|
| yarn | 0.27.5 |
| node.js | 8.1.3 |
| npm | 5.0.3 |
| google-chrome-stable | 59 |
| Xvfb | apt-get |

-----

&nbsp;

### Prerequisites

 * Runs as non-root with fixed UID 10777 and GID 10777. See [howto prepare volume permissions](https://github.com/codeclou/doc/blob/master/docker/README.md).
 * See [howto use SystemD for named Docker-Containers and system startup](https://github.com/codeclou/doc/blob/master/docker/README.md).

-----

&nbsp;

### Usage

Assuming you are currently inside a NodeJS Project containing a `package.json`, you can do an `npm install` like this:

```
docker run \
    -i -t \
    -v $(pwd):/work \
    --shm-size=128M \
    codeclou/docker-nodejs-chrome-xvfb:node-8.1.3-chome-59 \
    npm install
```

Or take a screenshot via:

```
docker run \
    -i -t \
    -v $(pwd):/work \
    --shm-size=128M \
    codeclou/docker-nodejs-chrome-xvfb:node-8.1.3-chome-59 \
    google-chrome --no-sandbox --headless --disable-gpu --window-size=1280,768 \
                  --screenshot=/work/screenshot.png https://codeclou.io
```

-----

&nbsp;

### Usage with Karma.js

Since **Chrome 59** we must use several things, which is handled by docker entrypoint:

 * We need to start pulseaudio, or Chrome will complain about [Audio Managers](https://stackoverflow.com/questions/43943721/error-running-headless-chromium-on-ubuntu)
 * We need to start dbus
 * We need to start xvfb
 * We need some flags for chrome startup
 * We need a symlink to chromium binary

When using with [karma.js](https://github.com/karma-runner/karma):

 * Start docker with a greater `/dev/shm` cache and use `--shm-size=128M` or greater.
 * Configure karma config with Chrome flags:


```
...
  logLevel: config.LOG_DEBUG,
...
  browsers: ['Chrome_without_security'],
  singleRun: false,
  customLaunchers: {
    Chrome_without_security: {
      base: 'Chrome',
      flags: [
        //'--headless', // DO NOT USE headless !!!
        '--disable-gpu',
        '--no-sandbox',
      ]
    }
  }
});
```


-----
&nbsp;

### License

[MIT](https://github.com/codeclou/docker-nodejs-xvfb-chrome/blob/master/LICENSE) © [Bernhard Grünewaldt](https://github.com/clouless)
