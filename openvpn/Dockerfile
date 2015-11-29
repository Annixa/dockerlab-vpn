FROM ubuntu:14.04
MAINTAINER Adam Kenyon <akenyonpro@gmail.com>

RUN apt-get update && \
    apt-get install -y \
        openvpn \
        easy-rsa \
        openvpn-auth-ldap && \
    apt-get clean

VOLUME ["/etc/openvpn", "/usr/share/easy-rsa"]
WORKDIR /etc/openvpn

# TODO configure DNS server in our conf once we have one running

# the OpenVPN install location
ENV OVPN_DIR /etc/openvpn
# the Easy RSA install location
ENV EASYRSA_DIR /usr/share/easy-rsa

# add our example config files
ADD ./*.example /etc/openvpn/

# add the ldap auth config
RUN mkdir $OVPN_DIR/auth
COPY auth-ldap.conf $OVPN_DIR/auth

EXPOSE 1194/udp
ENTRYPOINT [ "entrypoint" ]
CMD [ "openvpn", "--config", "/etc/openvpn/server.conf" ]

# add our bin last, since it's liable to change
ADD ./bin /usr/local/bin/
RUN chmod +x /usr/local/bin/*

