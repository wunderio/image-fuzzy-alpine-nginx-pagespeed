#!/usr/bin/env bash

PAGESPEED_VERSION=$1
NEW_PAGESPEED_VERSION=$2

# Download the tarballs.
curl -L https://dl.google.com/dl/linux/mod-pagespeed/tar/beta/mod-pagespeed-beta-${PAGESPEED_VERSION}-r0.tar.bz2 | tar -jx -C diff/pagespeed
curl -L https://dl.google.com/dl/linux/mod-pagespeed/tar/beta/mod-pagespeed-beta-${NEW_PAGESPEED_VERSION}-r0.tar.bz2 | tar -jx -C diff/new_pagespeed
