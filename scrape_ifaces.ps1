$OutputDir = "data"
$OutputFile = Join-Path $OutputDir "host_interfaces.json"

if (!(Test-Path $OutputDir)) {
    New-Item -Path $OutputDir -ItemType Directory | Out-Null
}

$ExcludePatterns = @(
    "Hyper-V",
    "Docker",
    "VirtualBox",
    "Loopback",
    "vEthernet",
    "Tailscale",
    "VPN",
    "WireGuard",
    "VMware",
    "hg-"
)

$interfaces = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
    Where-Object { $_.InterfaceAlias -notmatch ($ExcludePatterns -join "|") -and $_.IPAddress -notmatch "169\.254\." } |
    ForEach-Object {
        $ip = $_.IPAddress
        $prefix = $_.PrefixLength
        $iface = $_.InterfaceAlias
        [PSCustomObject]@{
            type   = "host"
            subnet = "$ip/$prefix"
            name   = $iface
        }
    }

$interfaces | ConvertTo-Json -Depth 3 | Out-File -Encoding utf8 $OutputFile

Write-Host "Saved host interfaces to $OutputFile"
