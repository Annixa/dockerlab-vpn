FROM ubuntu:14.04
MAINTAINER Adam Kenyon <akenyonpro@gmail.com>

RUN apt-get update && \
    apt-get install -y \
        openvpn \
        easy-rsa \
        openvpn-auth-ldap && \
    apt-get clean

VOLUME [ "/etc/openvpn" ]
WORKDIR /etc/openvpn

# TODO configure DNS server in our conf once we have one running

# initialize some installation variables
# the OpenVPN install location
ENV OVPN_DIR /etc/openvpn
# the data container's name
ENV OVPN_DATA vpn-data

# add the ldap auth mod
RUN mkdir $OVPN_DIR/auth
COPY auth-ldap.conf $OVPN_DIR/auth

# run the OpenVPN daemon on UDP 1194, the default port
EXPOSE 1194/udp
ENTRYPOINT [ "entrypoint" ]
CMD [ "openvpn", "--config", "/etc/openvpn/server.conf" ]

# add our bin last, since it's liable to change
ADD ./bin /usr/local/bin/
RUN chmod +x /usr/local/bin/*

