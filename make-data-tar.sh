#!/bin/sh
mkdir -p _dummy
cd _dummy
tar -cf ../data.tar.gz --mtime="Sun Sep 27 16:03:31 UTC 2015" --numeric-owner --owner=root -I "gzip --no-name" --no-recursion ./
cd ..
rmdir _dummy
