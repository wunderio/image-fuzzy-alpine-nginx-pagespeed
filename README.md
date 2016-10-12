# alpine-nginx-pagespeed

Nginx compiled with PageSpeed optimisation library on Alpine Linux. Is meant to be extended to application specific images by adding custom configuration.

Versioning is based on Nginx releases. Please see the release notes for detailed information about the versions. After pulling the version of the image you want you can also inspect the version values by running:
~~~
docker inspect quay.io/wunder/alpine-nginx-pagespeed
...
"Env": [
  "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  "LIBPNG_VERSION=1.2.56",
  "PAGESPEED_VERSION=1.11.33.4",
  "NGINX_VERSION=1.11.5"
],
...
~~~
