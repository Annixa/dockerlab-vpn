#!/bin/bash

set -e

if [ `whoami` != "root" ]; then
	echo "Please run this script as root."
	exit 126
fi

read -p "Enter the name of the new client: " CLIENTNAME

# The easyrsa tool will prompt for the CA password. This is
# the password we set above during the ovpn_initpki command.
# Create the client certificate:
docker run --volumes-from ovpn-data \
	--rm \
	-it \
	kylemanna/openvpn \
	easyrsa build-client-full $CLIENTNAME nopass

# The clients need the certificates and a configuration file
# to connect. The embedded scripts automate this task and
# enable the user to write out a configuration to a single
# file that can then be transfered to the client. 
docker run --volumes-from ovpn-data \
	--rm \
	-it kylemanna/openvpn \
	ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn

echo "$CLIENTNAME.ovpn generated."
echo "NOTE: Make sure to remove $CLIENTNAME.ovpn when you're done with it."

