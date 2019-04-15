FROM node:8-stretch
MAINTAINER Valentin Mayer

#ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin

RUN apt-get update -y && apt-get upgrade -y \
	&& apt-get install -y sudo apt-utils build-essential libavahi-compat-libdnssd-dev libudev-dev libpam0g-dev \
	acl libcap2-bin \
	vim bash python \
	git \ 
 	tzdata 
	
ADD bin/* /usr/local/bin/
RUN chmod +x /usr/local/bin/*

# iobrokre needs npm > 6.4.1
RUN npm install -g npm@6

# Install iobroker
RUN curl -sL https://raw.githubusercontent.com/ioBroker/ioBroker/master/installer.sh | bash -

# Deescalate permissions from root to user "iobroker", otherwise iobroker will be started as root, leading to errors during adaptor installation with npm
USER iobroker

EXPOSE 8081 
ENTRYPOINT ["run.sh"]
CMD ["start"]
