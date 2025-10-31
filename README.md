## How Setup Helium VPN Agent

### Linux
```
git clone https://github.com/CyberArmyID/helium-vpn-agent.git && cd helium-vpn-agent && docker build -t helium-vpn-agent:latest . && BASEDIR=/opt/helium-agent UUID={xxxx-xxx-xx-xxxx} docker compose up -d
```

### Windows (CMD)
```
git clone https://github.com/CyberArmyID/helium-vpn-agent.git && cd helium-vpn-agent && docker build -t helium-vpn-agent:latest . && set BASEDIR=%APPDATA%\helium-agent && set UUID={xxxx-xxx-xx-xxxx} && docker compose up -d

```

### macOS
```
git clone https://github.com/CyberArmyID/helium-vpn-agent.git && cd helium-vpn-agent && docker build -t helium-vpn-agent:latest . && BASEDIR=$HOME/.helium-agent UUID={xxxx-xxx-xx-xxxx} docker compose up -d
```
