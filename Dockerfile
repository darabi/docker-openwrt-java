# OpenWrt with a Java installation
#
# Many thanks to the original author:
#
# Jean Blanchard <jean@blanchard.io>
#
# cf. https://github.com/jeanblanchard/docker-java
#

FROM mcreations/openwrt-x64:17.01.2
MAINTAINER Kambiz Darabi <darabi@m-creations.net>

# Java Version
ENV JAVA_VERSION_MAJOR 8
ENV JAVA_VERSION_MINOR 161
ENV JAVA_VERSION_BUILD 12
ENV JAVA_URL_TOKEN 2f38c3b165be4555a1fa6e98c45e0808
ENV JAVA_PACKAGE       server-jre
ENV JNA_VERSION 4.5.1

# Runtime environment
ENV JAVA_HOME /opt/jre
ENV PATH ${PATH}:${JAVA_HOME}/bin

# Download and unarchive Java
RUN curl -kLOH "Cookie: oraclelicense=accept-securebackup-cookie" \
    http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_URL_TOKEN}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz &&\
    mkdir /opt &&\
    tar -xzf ${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz -C /opt &&\
    cp -r /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR}/jre /opt/ &&\
    curl -jkLH "Cookie: oraclelicense=accept-securebackup-cookie" -o jce_policy-8.zip http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip &&\
    unzip jce_policy-8.zip -d /tmp &&\
    cp /tmp/UnlimitedJCEPolicyJDK8/*.jar /opt/jre/lib/security/ &&\
    rm -rf jce_policy-8.zip /tmp/UnlimitedJCEPolicyJDK8 &&\
    curl -kL -o /opt/jre/lib/ext/jna.jar https://github.com/twall/jna/raw/${JNA_VERSION}/dist/jna.jar &&\
    echo "export PATH=\$PATH:${JAVA_HOME}/bin" >> /etc/profile &&\
    rm -rf ${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz \
           /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR}/ \
           /opt/jre/lib/plugin.jar \
           /opt/jre/lib/ext/jfxrt.jar \
           /opt/jre/bin/javaws \
           /opt/jre/lib/javaws.jar \
           /opt/jre/lib/desktop \
           /opt/jre/plugin \
           /opt/jre/lib/deploy* \
           /opt/jre/lib/*javafx* \
           /opt/jre/lib/*jfx* \
           /opt/jre/lib/amd64/libdecora_sse.so \
           /opt/jre/lib/amd64/libprism_*.so \
           /opt/jre/lib/amd64/libfxplugins.so \
           /opt/jre/lib/amd64/libglass.so \
           /opt/jre/lib/amd64/libgstreamer-lite.so \
           /opt/jre/lib/amd64/libjavafx*.so \
           /opt/jre/lib/amd64/libjfx*.so

RUN mkdir -p /usr/local/bin
ADD scripts/import-certs.sh /usr/local/bin
RUN chmod u+x /usr/local/bin/import-certs.sh

ADD scripts/rc.local /etc/rc.local
RUN chmod 775 /etc/rc.local

ADD scripts/S99certs /etc/rc.d/S99certs
RUN chmod 777 /etc/rc.d/S99certs

CMD [ "java", "-version" ]
