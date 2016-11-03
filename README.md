# image-fuzzy-alpine-nginx-pagespeed

Fuzzy as in reference to the https://en.wikipedia.org/wiki/The_Mythical_Man-Month book where Fred describes the approach of "write one to throw away" as the best start.

Nginx compiled with PageSpeed optimisation library on Alpine Linux.

Maintained by: Aleksi Johansson <aleksi.johansson@wunder.io>

## Docker

### Image

This image is available publicly at:

- quay.io/wunder/fuzzy-alpine-nginx-pagespeed : [![Docker Repository on Quay](https://quay.io/repository/wunder/fuzzy-alpine-nginx-pagespeed/status "Docker Repository on Quay")](https://quay.io/repository/wunder/fuzzy-alpine-nginx-pagespeed)

### Base

This image is based on the fuzzy-alpine-base image https://github.com/wunderkraut/image-fuzzy-alpine-base.

### Modifications

This image adds the following files:

#### /etc/nginx/nginx.conf

This is a custom nginx configuration:

1. runs as app;
2. include additional configs from `/etc/nginx/conf.d/*.conf`;
3. limit worker connections to 4096.

## Using this Image

This image is meant to be extended to application specific images by adding custom configuration.

Versioning is based on Nginx releases. Please see the release notes for detailed information about the versions. After pulling the version of the image you want you can also inspect the version values by running:
```
docker inspect quay.io/wunder/fuzzy-alpine-nginx-pagespeed
...
"Env": [
  "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  "LIBPNG_VERSION=1.2.56",
  "PAGESPEED_VERSION=1.11.33.4",
  "NGINX_VERSION=1.11.5"
],
...
```

Run this container as an independent service:

```
$/> docker run -d quay.io/wunder/fuzzy-alpine-nginx-pagespeed
```

map any needed services such as php-fpm and mount any source code volumes to whatever path needed:

```
$/> docker run -d \
      -v "$(pwd):/app/web" \
      -l "my_running_fpm_container:fpm.app" \
      quay.io/wunder/fuzzy-alpine-nginx-pagespeed
```

## TODO

- Create script for automatically diffing structure changes in mod_pagespeed which we have to manually build
  - diff -rq psol psol_from_container >> differences.txt
  - cat differences.txt | grep "Only in psol/"
- Inform the Google team we are using the tarballs to build for Alpine and they save a great deal of time
