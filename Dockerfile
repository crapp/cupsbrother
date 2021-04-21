# based on https://github.com/olbat/dockerfiles/tree/master/cupsd

# ARG BASE_USER
# ARG MAINTAINER
FROM debian:testing
# MAINTAINER $MAINTAINER

# Install Packages (basic tools, cups, basic drivers, HP drivers)
RUN apt-get update \
&& apt-get install -y \
  sudo \
  whois \
  cups \
  cups-client \
  cups-bsd \
  cups-filters \
  foomatic-db-compressed-ppds \
  printer-driver-all \
  openprinting-ppds \
  hpijs-ppds \
  hp-ppd \
  hplip \
  smbclient \
  printer-driver-cups-pdf \
  wget \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

# URI: lpd://(printer's IP address)/binary_p1
RUN wget https://download.brother.com/welcome/dlf101123/brgenml1lpr-3.1.0-1.i386.deb \
&&  wget https://download.brother.com/welcome/dlf101125/brgenml1cupswrapper-3.1.0-1.i386.deb \
&&  sudo dpkg --force-all -i brgenml1lpr-3.1.0-1.i386.deb \
&&  sudo dpkg --force-all -i brgenml1cupswrapper-3.1.0-1.i386.deb

# Add user and disable sudo password checking
RUN useradd \
  --groups=sudo,lp,lpadmin \
  --create-home \
  --home-dir=/home/print \
  --shell=/bin/bash \
  --password=$(mkpasswd print) \
  print \
&& sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers

# Configure the service's to be reachable
RUN /usr/sbin/cupsd \
  && while [ ! -f /var/run/cups/cupsd.pid ]; do sleep 1; done \
  && cupsctl --remote-admin --remote-any --share-printers \
  && kill $(cat /var/run/cups/cupsd.pid)

# Patch the default configuration file to only enable encryption if requested
RUN sed -e '0,/^</s//DefaultEncryption IfRequested\n&/' -i /etc/cups/cupsd.conf

# Default shell
CMD ["/usr/sbin/cupsd", "-f"]

