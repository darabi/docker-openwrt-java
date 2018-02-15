#!/bin/sh
docker run -v"$(pwd)"/sample-certs:/data/ssl --rm mcreations/openwrt-java

# The above produces the output:
# Certificate was added to keystore
# Certificate was added to keystore
# Certificate was added to keystore
# java version "1.8.0_141"
# Java(TM) SE Runtime Environment (build 1.8.0_141-b15)
# Java HotSpot(TM) 64-Bit Server VM (build 25.141-b15, mixed mode)
