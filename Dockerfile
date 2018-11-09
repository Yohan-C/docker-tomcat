FROM debian

LABEL maintainer="semoss@semoss.org"

ENV PATH=$PATH:/opt/maven/bin:/opt/tomcat/bin

# Java
# Tomcat
# Maven
# Git
# Nano
RUN apt-get update \
	&& apt-get -y install openjdk-8-jdk \
	&& java -version \
	&& apt-get -y install wget \
	&& wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.41/bin/apache-tomcat-8.0.41.tar.gz \
	&& tar -zxvf apache-tomcat-*.tar.gz \
	&& mkdir /opt/tomcat \
	&& mv apache-tomcat-8.0.41/* /opt/tomcat/ \
	&& rm -r apache-tomcat-8.0.41 \
	&& rm apache-tomcat-8.0.41.tar.gz \
	&& echo 'CATALINA_PID="$CATALINA_BASE/bin/catalina.pid"' > /opt/tomcat/bin/setenv.sh \
	&& wget https://apache.claz.org/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz \
	&& tar -zxvf apache-maven-*.tar.gz \
	&& mkdir /opt/maven \
	&& mv apache-maven-3.5.4/* /opt/maven/ \
	&& rm -r apache-maven-3.5.4 \
	&& rm apache-maven-3.5.4-bin.tar.gz \
	&& apt-get -y install git \
	&& git config --global http.sslverify false \
	&& apt-get -y install nano \
	&& echo '#!/bin/sh' > /opt/tomcat/bin/start.sh \
	&& echo 'catalina.sh start' >> /opt/tomcat/bin/start.sh \
	&& echo 'tail -f /opt/tomcat/logs/catalina.out' >> /opt/tomcat/bin/start.sh \
	&& echo '#!/bin/sh' > /opt/tomcat/bin/stop.sh \
	&& echo 'shutdown.sh -force' >> /opt/tomcat/bin/stop.sh \
	&& chmod 777 /opt/tomcat/bin/*.sh \
	&& chmod 777 /opt/maven/bin/*.cmd

WORKDIR /opt/tomcat/webapps

# Background
CMD ["start.sh"]
