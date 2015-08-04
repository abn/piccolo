FROM cloudrouter/base-fedora:latest
MAINTAINER Arun Neelicattu <arun.neelicattu@gmail.com>

RUN dnf -y upgrade

ENV BUILDROOT /buildroot

ADD loadbins /usr/bin/loadbins

RUN dnf -y install java-1.8.0-openjdk-headless

RUN mkdir -p ${BUILDROOT}

RUN dnf -y install which findutils

WORKDIR ${BUILDROOT}

RUN mkdir -p ./rootfs/usr/lib
RUN cp -R /usr/lib/jvm* ./rootfs/usr/lib/.
RUN cp $(which java) ./rootfs/.

ENV DEST rootfs
RUN loadbins $(which java)
RUN find ./rootfs -name "*.so" -exec loadbins {} \;

COPY Dockerfile.final ./Dockerfile

CMD docker build -t alectolytic/piccolo ${BUILDROOT}
