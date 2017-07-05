# docker-nodejs-xvfb-chrome

[![](https://codeclou.github.io/doc/badges/generated/docker-image-size-46.svg)](https://hub.docker.com/r/codeclou/docker-nodejs/tags/) [![](https://codeclou.github.io/doc/badges/generated/docker-from-alpine-3.6.svg)](https://alpinelinux.org/) [![](https://codeclou.github.io/doc/badges/generated/docker-run-as-non-root.svg)](https://docs.docker.com/engine/reference/builder/#/user)

Docker-Image to run [NodeJS](https://nodejs.org/en/) for dockerized builds and xvfb with chromium.

It provides:
 * yarn version 0.27.5
 * node.js version 7.10.0
 * npm version 5.0.4

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
    codeclou/docker-nodejs:yarn-0.0.27.5-npm-5.0.4-nodejs-7.10.0 \
    npm install
```

-----
&nbsp;

### License

[MIT](https://github.com/codeclou/docker-nodejs-xvfb-chrome/blob/master/LICENSE) © [Bernhard Grünewaldt](https://github.com/clouless)
