#!/usr/bin/env bash

PAGESPEED_VERSION=1.11.33.4
NEW_PAGESPEED_VERSION=1.12.34.1

# Create the diff folder.
mkdir -p diff

# Download the tarballs.
curl -L https://dl.google.com/dl/linux/mod-pagespeed/tar/beta/mod-pagespeed-beta-${PAGESPEED_VERSION}-r0.tar.bz2 | tar -jx -C diff
curl -L https://dl.google.com/dl/linux/mod-pagespeed/tar/beta/mod-pagespeed-beta-${NEW_PAGESPEED_VERSION}-r0.tar.bz2 | tar -jx -C diff

# Diff the versions.
diff -rq diff/modpagespeed-${PAGESPEED_VERSION} diff/modpagespeed-${NEW_PAGESPEED_VERSION} | grep "Only in diff/modpagespeed-${NEW_PAGESPEED_VERSION}/" > diff/diff.txt
cat diff/diff.txt
printf "Please find the above diff in the 'diff/diff.txt' file.\n"
