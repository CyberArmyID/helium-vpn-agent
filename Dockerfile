FROM alpine:3.22

RUN apk add --no-cache \
    bash \
    iproute2 \
    iptables \
    wireguard-tools \
    curl \
    jq \
    sudo \
    ca-certificates \
    libstdc++ \
    libffi \
    openssl \
    procps \
    openresolv \
    docker-cli

WORKDIR /app

COPY vpn-agent .

RUN chmod +x ./vpn-agent

ENTRYPOINT ["./vpn-agent"]
