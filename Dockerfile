Installation on Debian 9 "Stretch"

See https://www.itzgeek.com/how-tos/linux/debian/how-to-install-tomcat-8-5-on-debian-9-ubuntu-16-04-linux-mint-18.html

apt-get update
apt-get -y install openjdk-8-jdk
java -version

# Download Tomcat
apt-get -y install wget
wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.41/bin/apache-tomcat-8.0.41.tar.gz 
tar -zxvf apache-tomcat-*.tar.gz
mkdir /opt/tomcat
mv apache-tomcat-8.0.41/* /opt/tomcat/
rm -r apache-tomcat-8.0.41

# Download maven
wget https://apache.claz.org/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz
tar -zxvf apache-maven-*.tar.gz
mkdir /opt/maven
mv apache-maven-3.5.4/* /opt/maven/
rm -r apache-maven-3.5.4
export PATH=$PATH:/opt/maven/bin
source ~/.profile 

# Download git
apt-get -y install git

# Clone the tomcat service file

# Install tomcat service
apt-get -y install nano
nano /etc/systemd/system/tomcat.service

Place this in file {
[Unit]
Description=Apache Tomcat 8.x Web Application Container
Wants=network.target
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/jre
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1G -Djava.net.preferIPv4Stack=true'
Environment='JAVA_OPTS=-Djava.awt.headless=true'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
SuccessExitStatus=143

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
}

systemctl daemon-reload
systemctl start tomcat
systemctl status tomcat
systemctl enable tomcat

netstat -antup | grep 8080
tcp        0      0 0.0.0.0:8080            0.0.0.0:*               LISTEN      12224/java

# Restart service
systemctl restart tomcat
