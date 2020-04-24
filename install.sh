#!/bin/bash
# -----------------------------------------------------------------------------------
# [Author] Raeseok, Lee(https://github.com/vivars7)
#		   Ubuntu JDK Install Script
# -----------------------------------------------------------------------------------
if [ $EUID -ne 0 ]; then
	echo -e "\033[31mPlease run as root or sudo ($(basename $0))\033[0m"
	exit
fi

if [ $# -lt 1 ]; then
	echo -e "\033[31mJDK file path(compressed with tar.gz) missing!!\033[0m"
	echo "Usage : sudo ./install.sh (jdk file path)"
	exit 1
fi

if [ -f $1 ]; then
	if [[ ! $1 =~ \.t?gz$ ]]; then
		echo -e "\033[31mThis script requires a file compressed with tar.gz!!\033[0m"
		exit 1
	fi
else
	echo -e "\033[31mInvalid JDK file path!!\033[0m"
	echo "Usage : sudo ./install.sh (jdk file path)"
	exit 1
fi

cp $1 /opt

jdk_dir=`tar -tzf /opt/$1 | head -1 | cut -f1 -d"/"`
if [ -f $jdk_dir ]; then
	echo -e "\033[31mJDK already was exist (/opt/$jdk_dir)\033[0m"
	exit 1
fi

tar xvfpz /opt/$1 -C /opt/
rm /opt/$1
chown -R root:root /opt/$jdk_dir

profile="/etc/profile.d/java-sdk-env.sh"
echo "export JAVA_HOME=/opt/$jdk_dir" >> $profile
echo -e "export CLASSPATH=.:\$JAVA_HOME/jre/lib/rt.jar:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> $profile
echo -e "export PATH=\$PATH:\$JAVA_HOME/bin" >> $profile

source $profile
