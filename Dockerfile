# Original credit: https://github.com/jpetazzo/dockvpn

# Leaner build then Ubunutu
FROM phusion/baseimage:latest

MAINTAINER John Cappiello <john@johncappiello.com>

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y openvpn iptables git-core && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Update checkout to use tags when v3.0 is finally released
RUN git clone --depth 1 https://github.com/OpenVPN/easy-rsa.git /usr/local/share/easy-rsa && \
    ln -s /usr/local/share/easy-rsa/easyrsa3/easyrsa /usr/local/bin

# Needed by scripts
ENV OPENVPN /etc/openvpn
ENV EASYRSA /usr/local/share/easy-rsa/easyrsa3
ENV EASYRSA_PKI $OPENVPN/pki
ENV EASYRSA_VARS_FILE $OPENVPN/vars

VOLUME ["/etc/openvpn"]

# Internally uses port 1194/udp, remap using `docker run -p 443:1194/tcp`
EXPOSE 1194/udp

WORKDIR /etc/openvpn

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

CMD ["/sbin/my_init"]
