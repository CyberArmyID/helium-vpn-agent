## How Setup Helium VPN Agent

### Linux/macOS
```
git clone https://github.com/CyberArmyID/helium-vpn-agent.git
cd helium-vpn-agent
docker build -t helium-vpn-agent:latest .
UUID={xxxx-xxx-xx-xxxx} docker compose up -d
```

### Windows (PowerShell)
```
git clone https://github.com/CyberArmyID/helium-vpn-agent.git
cd helium-vpn-agent
docker build -t helium-vpn-agent:latest .
$env:UUID = "{xxxx-xxx-xx-xxxx}"
docker compose up -d
```

### Windows (CMD)
```
git clone https://github.com/CyberArmyID/helium-vpn-agent.git
cd helium-vpn-agent
docker build -t helium-vpn-agent:latest .
set UUID={xxxx-xxx-xx-xxxx}
docker compose up -d
```
