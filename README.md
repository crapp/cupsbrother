# cupsbrother

Is a docker configuration file which provides a cups print server with the generic Brother printer drivers preinstalled

## Dockerfile

The docker file is based on the excellent work of (olbat)[https://github.com/olbat/dockerfiles/tree/master/cupsd] 

## Overview
Docker image including CUPS print server and printing drivers (installed from the Debian packages).

## Build the image

```bash
docker build -t mycupsdimg
```

## Run the Cups server
```bash
docker run -d -p 631:631 -v /var/run/dbus:/var/run/dbus --name cupsd mycupsdimg
```

## Add printers to the Cups server
1. Connect to the Cups server at [http://127.0.0.1:631](http://127.0.0.1:631)
2. Add printers: Administration > Printers > Add Printer

__Note__: The admin user/password for the Cups server is `print`/`print`

## Add supported Brother printer

URI: lpd://(printer's IP address)/binary_p1

## Configure Cups client on your machine
1. Install the `cups-client` package
2. Edit the `/etc/cups/client.conf`, set `ServerName` to `127.0.0.1:631`
3. Test the connectivity with the Cups server using `lpstat -r`
4. Test that printers are detected using `lpstat -v`
5. Applications on your machine should now detect the printers!

### Included package
* cups, cups-client, cups-filters
* foomatic-db
* printer-driver-all, printer-driver-cups-pdf
* openprinting-ppds
* hpijs-ppds, hp-ppd
* sudo, whois
* smbclient
* brother brgenml1
