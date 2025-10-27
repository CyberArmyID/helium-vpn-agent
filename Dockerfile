FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    iproute2 \
    iptables \
    wireguard-tools \
    curl \
    jq \
    sudo \
    ca-certificates \
    libstdc++6 \
    libffi8 \
    openssl \
    procps \
    openresolv \
    && rm -rf /var/lib/apt/lists/*

RUN curl https://get.docker.com | sudo sh

WORKDIR /app

COPY vpn-agent .

RUN chmod +x ./vpn-agent

ENTRYPOINT ["./vpn-agent"]

