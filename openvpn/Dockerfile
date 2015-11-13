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

# add the ldap auth mod
RUN mkdir /etc/openvpn/auth
COPY auth-ldap.conf /etc/openvpn/auth

# initialize some installation variables
ENV OVPN_DIR /etc/openvpn

# run the OpenVPN daemon on UDP 1194, the default port
EXPOSE 1194/udp
ENTRYPOINT [ "entrypoint" ]
CMD [ "openvpn", "--config", "/etc/openvpn/server.conf" ]

# add our bin last, since it's liable to change
ADD ./bin /usr/local/bin/
RUN chmod +x /usr/local/bin/*

