#!/bin/bash
# Import all certificates found in /data/ssl
if [ -d "/data/ssl" ]
then
    for i in $(find /data/ssl -type f)
    do
        keytool -import -file $i \
                -keystore $JAVA_HOME/lib/security/cacerts \
                -storepass changeit \
                -noprompt \
                -alias $(basename $i .crt) # we need a unique alias
    done
#    keytool -list -keystore $JAVA_HOME/lib/security/cacerts -storepass changeit
fi

