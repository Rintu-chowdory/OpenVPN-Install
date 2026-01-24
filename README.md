# OpenVPN-Install

A secure and user-friendly OpenVPN server installer for multiple Linux distributions.

## Overview

This project provides an automated installer script for setting up a secure OpenVPN server. It supports multiple Linux distributions and includes optional Unbound DNS resolver integration with IPv6 support.

## Supported Operating Systems

- Debian (>= 9)
- Ubuntu (>= 16.04)
- CentOS (>= 7)
- Amazon Linux 2
- Fedora
- Oracle Linux 8
- Arch Linux
- Rocky Linux
- AlmaLinux

## Features

- ✅ Secure OpenVPN server setup with sensible defaults
- ✅ Support for multiple Linux distributions
- ✅ IPv6 connectivity support
- ✅ Optional Unbound DNS resolver integration
- ✅ Customizable encryption settings (cipher, authentication, key exchange)
- ✅ Easy client certificate generation and revocation
- ✅ Automatic iptables firewall rule configuration
- ✅ SELinux support for compatible systems
- ✅ Interactive and automated installation modes

## Prerequisites

- **Root access** - The script must be run with superuser privileges
- **TUN device** - VPN functionality requires TUN support (`/dev/net/tun`)
- **Internet connectivity** - Required for downloading packages and certificates
- **curl** - For IP address detection and downloads

## Installation

### Quick Start

```bash
# Download and run the installer
curl -O https://raw.githubusercontent.com/saifulislam88/OpenVPN-Install/main/openvpn-install.sh
chmod +x openvpn-install.sh
sudo ./openvpn-install.sh
```

### Automated Installation

For non-interactive setup with default options:

```bash
sudo AUTO_INSTALL=y ./openvpn-install.sh
```

## Usage

### Initial Setup

When you run the script for the first time, it will prompt you for:

1. **IP Address** - The interface IP where OpenVPN will listen
2. **Public IP/Hostname** - For NAT scenarios
3. **IPv6 Support** - Enable IPv6 networking (optional)
4. **Port** - Choose from default (1194), custom, or random
5. **Protocol** - UDP (recommended) or TCP
6. **DNS** - Select from multiple DNS providers or use Unbound
7. **Compression** - Enable optional compression (not recommended)
8. **Encryption** - Use defaults or customize cipher, certificate, and key settings

### Managing Clients

After initial installation, run the script again to:

- **Add new clients** - Generate new client certificates
- **Revoke clients** - Disable existing client certificates
- **Remove OpenVPN** - Completely uninstall the service

## Configuration

### Default Settings

- **Cipher**: AES-128-GCM
- **Certificate Type**: ECDSA
- **Certificate Curve**: prime256v1
- **Key Exchange**: ECDH
- **Authentication**: SHA256
- **TLS Security**: tls-crypt
- **Network**: 10.8.0.0/24 (IPv4), fd42:42:42:42::/112 (IPv6)

### Customization Options

You can customize:

- **Data Channel Ciphers**: AES-128/192/256 (GCM or CBC)
- **Certificate Keys**: ECDSA or RSA (2048-4096 bits)
- **HMAC Algorithms**: SHA-256, SHA-384, SHA-512
- **TLS Security**: tls-crypt (recommended) or tls-auth

## Project Structure

```
.
├── openvpn-install.sh          # Main installation script
├── README.md                   # This file
├── LICENSE                     # Project license
├── scripts/                    # Additional utility scripts
├── config/                     # Configuration templates
├── docs/                       # Documentation
└── .github/
    └── workflows/
        └── ci-cd.yml          # GitHub Actions CI/CD pipeline
```

## DNS Options

The installer supports multiple DNS providers:

- System resolvers (from /etc/resolv.conf)
- Self-hosted Unbound DNS resolver
- Cloudflare (1.1.1.1, 1.0.0.1)
- Quad9 (9.9.9.9, 149.112.112.112)
- FDN, DNS.WATCH, OpenDNS
- Google, Yandex, AdGuard
- NextDNS
- Custom DNS servers

## Security Features

- Strong default encryption settings
- ECDH key exchange with modern curves
- HMAC authentication
- TLS control channel protection (tls-crypt)
- Certificate revocation list (CRL) support
- IP forwarding and firewall rules
- SELinux compatibility

## Firewall Configuration

The script automatically configures:

- iptables NAT rules for VPN traffic
- Input/forward rules for the TUN device
- SELinux policies (if enforcing)
- systemd service for persistent rules

## Client Configuration

Client configuration files (.ovpn) include:

- CA certificate
- Client certificate
- Client private key
- TLS security key/auth
- Server connection details
- All necessary OpenVPN directives

## Troubleshooting

### "TUN is not available"
Ensure your system/container supports TUN devices or check with your VPS provider.

### "Can not detect public interface"
Manually specify the interface or check your network configuration.

### IPv6 not working
Verify IPv6 connectivity:
```bash
ping6 ipv6.google.com
```

### DNS not resolving
Check if Unbound is running:
```bash
systemctl status unbound
```

## Removal

To completely remove OpenVPN:

```bash
sudo ./openvpn-install.sh
# Select option 3 (Remove OpenVPN)
```

This will:
- Stop and disable OpenVPN
- Remove firewall rules
- Clean up certificates and configurations
- Remove Unbound (if selected)
- Delete client configuration files

## Environment Variables

For automated installation, set these variables:

```bash
AUTO_INSTALL=y              # Enable automatic mode
APPROVE_INSTALL=y           # Skip confirmation prompts
APPROVE_IP=y                # Accept detected IP
IPV6_SUPPORT=n              # Disable IPv6
PORT_CHOICE=1               # Default port (1194)
PROTOCOL_CHOICE=1           # UDP
DNS=11                      # AdGuard DNS
COMPRESSION_ENABLED=n       # No compression
CUSTOMIZE_ENC=n             # Use defaults
CLIENT=myclient             # Client name
PASS=1                      # No password on key
```

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Original Repository

Based on: https://github.com/saifulislam88/OpenVPN-Install.git

## Support

For issues and questions:
- Check the GitHub Issues page
- Review the documentation in `/docs`
- See troubleshooting section above

## Security Considerations

- Run the installer on a dedicated server or VPS
- Use strong encryption settings for sensitive environments
- Regularly rotate client certificates
- Monitor OpenVPN logs: `/var/log/openvpn/status.log`
- Keep your system and OpenVPN packages updated

---

**Note**: This script modifies system configurations including network settings, firewall rules, and SSL/TLS certificates. Always review the script before running in production environments.
