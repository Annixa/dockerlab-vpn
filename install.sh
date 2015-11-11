#!/bin/bash

set -e

if [ `whoami` != "root" ]; then 
	echo You must run install.sh as root
	exit 126
fi

IMAGE="kylemanna/openvpn"

DATA="ovpn-data"
HOSTNAME="dev.dockerlab.net"
PORT=1194
PROTO=udp

# Create an empty Docker volume container using busybox
docker run --name $DATA \
	-v /etc/openvpn \
	busybox

# Initialize the $OVPN_DATA container that will hold
# config files and certs, and replace vpn.example.com
# with your FQDN. The vpn.example.com value should be
# the fully-qualified domain name you use to communicate
# with the server. This assumes the DNS settings are
# already configured. Alternatively, it's possible
# to use just the IP address of the server, but this is
# not recommended.
docker run --volumes-from $DATA \
	--rm \
	$IMAGE \
	ovpn_genconfig \
	-u $PROTO://$HOSTNAME:$PORT

# Generate the EasyRSA PKI certificate authority. You
# will be prompted for a passphrase for the CA private
# key. Pick a good one and remember it; without the
# passphrase it will be impossible to issue and sign
docker run --volumes-from $DATA \
	--rm \
	-it \
	$IMAGE \
	ovpn_initpki

# Create the upstart config
cat <<EOF > /etc/init/docker-openvpn.conf
description "Docker container for OpenVPN server"
start on filesystem and started docker
stop on runlevel [!2345]
respawn
script
  exec docker run --volumes-from $DATA --rm -p $PORT:$PORT/$PROTO --cap-add=NET_ADMIN $IMAGE
end script
EOF
chmod 644 /etc/init/docker-openvpn.conf

# Finally, start the new service
start docker-openvpn

docker ps -l

