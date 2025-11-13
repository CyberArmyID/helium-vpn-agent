## How Setup Helium VPN Agent

### Linux
```
git clone https://github.com/CyberArmyID/helium-vpn-agent.git && cd helium-vpn-agent && bash ./scrape_ifaces.sh && UUID={xxxx-xxx-xx-xxxx} docker compose -f docker-compose-host.yaml up -d --build
```

### Windows (PowerShell)
```
git clone https://github.com/CyberArmyID/helium-vpn-agent.git; cd helium-vpn-agent; powershell -ExecutionPolicy Bypass -File .\scrape_ifaces.ps1; $env:UUID="{xxxx-xxx-xx-xxxx}"; docker compose up -d --build
```

### macOS
```
git clone https://github.com/CyberArmyID/helium-vpn-agent.git && cd helium-vpn-agent && bash ./scrape_ifaces.sh && UUID={xxxx-xxx-xx-xxxx} docker compose up -d --build
```
