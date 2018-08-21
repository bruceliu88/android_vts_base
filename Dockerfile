FROM ubuntu:16.04 

MAINTAINER bruceliu88 <liubos1048021@pku.org.cn> 

ENV HOME /root

#indtall python2.7
RUN apt-get update && \
	apt-get install -y python \
	python-dev \
	python-protobuf \
	protobuf-compiler \
	python-virtualenv \
	python-pip


#install JDK1.8
RUN apt-get install -y python-software-properties  software-properties-common \
	&& add-apt-repository ppa:webupd8team/java -y \
	&& echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
	&& apt-get update \
	&& apt-get install -y --force-yes --no-install-recommends oracle-java8-installer \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set oracle java as the default java 
RUN ln -s /usr/lib/jvm/java-8-oracle /usr/lib/jvm/jdk-8-oracle-latest \ 
	&& update-java-alternatives -s java-8-oracle 

ENV JAVA_HOME /usr/lib/jvm/jdk-8-oracle-latest 

# Install Android SDK 
ENV SDK_VERSION "r24.4.1" 
RUN cd /opt \
	&& wget --output-document=android-sdk.tgz --quiet https://dl.google.com/android/android-sdk_${SDK_VERSION}-linux.tgz \
	&& tar xzf android-sdk.tgz \
	&& rm -f android-sdk.tgz 

RUN	add-apt-repository ppa:nilarimogard/webupd8 \
	&& apt-get update \
        && apt-get install -y android-tools-adb \
	&& apt-get install -y openssh-client \
	&& apt-get install -y usbutils \
	&& apt-get install -y udev

# Setup environment 
ENV ANDROID_HOME /opt/android-sdk-linux 
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
ENV VTS_PYPI_PATH /android-vts

