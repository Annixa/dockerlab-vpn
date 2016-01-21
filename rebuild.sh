#!/bin/bash

if [ "`whoami`" != "root" ]; then
	echo Please run this script as root.
	exit 1
fi

# stop and rebuild
docker-compose stop
docker-compose rm -fv
docker-compose build
docker rmi `docker images -qf dangling=true`

# run the container once to initialize the volumes
# it should complain about not having an ovpn_env.sh
docker-compose up -d

# run the initpki script
docker run --rm --volumes-from vpn -it vpn_vpn ovpn_initpki
# create a new client
client=sk4bs
docker run --rm --volumes-from vpn -it vpn_vpn easyrsa build-client-full $client nopass
# generate the client config
docker run --rm --volumes-from vpn vpn_vpn ovpn_getclient $client > ${client}.ovpn

# bring the vpn container back up
docker-compose up -d
docker-compose logs

