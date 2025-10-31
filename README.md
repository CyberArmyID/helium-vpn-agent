## How Setup Helium VPN Agent

### Linux
```
git clone https://github.com/CyberArmyID/helium-vpn-agent.git && cd helium-vpn-agent && docker build -t helium-vpn-agent:latest . && OS_SYSTEM=Linux UUID={xxxx-xxx-xx-xxxx} docker compose -f ./docker-compose-linux.yaml up -d
```

### Windows (CMD)
```
git clone https://github.com/CyberArmyID/helium-vpn-agent.git && cd helium-vpn-agent && docker build -t helium-vpn-agent:latest . && set OS_SYSTEM=Windows && set UUID={xxxx-xxx-xx-xxxx} && docker -f .\docker-compose-windows.yaml compose up -d

```

### macOS
```
git clone https://github.com/CyberArmyID/helium-vpn-agent.git && cd helium-vpn-agent && docker build -t helium-vpn-agent:latest . && OS_SYSTEM=Darwin UUID={xxxx-xxx-xx-xxxx} docker compose -f ./docker-compose-darwin.yaml up -d
```
