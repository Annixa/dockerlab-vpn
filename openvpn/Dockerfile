FROM debian:jessie
MAINTAINER Adam Kenyon <akenyonpro@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      openvpn \
      openvpn-auth-ldap \
      iptables \
      wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /usr/local/share/easy-rsa && \
    wget -O - https://github.com/OpenVPN/easy-rsa/archive/v3.0.0.tar.gz | tar xzf - --strip=1 -C /usr/local/share/easy-rsa easy-rsa-3.0.0/easyrsa3 && \
    ln -s /usr/local/share/easy-rsa/easyrsa3/easyrsa /usr/local/bin

# TODO configure DNS server in our conf once we have one running
ENV OPENVPN /etc/openvpn
ENV EASYRSA /usr/local/share/easy-rsa/easyrsa3
ENV EASYRSA_PKI $OPENVPN/pki
ENV EASYRSA_VARS_FILE $OPENVPN/vars
ENV HOSTNAME dev.dockerlab.net

# mount the openvpn and easyrsa dirs as volumes so they can be used
# in other containers for configuration
VOLUME $OPENVPN $EASYRSA
WORKDIR $OPENVPN

# add our example config files
#ADD ./*.example /etc/openvpn/
# add the ldap auth config
#RUN mkdir $OPENVPN/auth
#COPY auth-ldap.conf $OPENVPN/auth

EXPOSE 1194/udp
ENTRYPOINT ["entrypoint"]
#CMD ["openvpn", "--config", "$OPENVPN/server.conf"]
CMD ["ovpn_run"]

# add our bin last, since it's liable to change
ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

