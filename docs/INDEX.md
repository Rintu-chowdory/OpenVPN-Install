# OpenVPN-Install Documentation

Welcome to the OpenVPN-Install documentation!

The main documentation lives in the [README](../README.md), which is kept in sync with the installer. The sections below map the most common topics to where they are covered.

## Getting Started

- [Installation](../README.md#getting-started) - Download and run the installer, or use `scripts/quick-install.sh` presets
- [Quick Start](../README.md#usage) - `./openvpn-install.sh install` and the interactive wizard (`install --interactive`)
- [Configuration](../README.md#features) - Network, DNS, and security options for `install`

## Advanced Topics

- [Security and Encryption](../README.md#security-and-encryption) - Ciphers, certificates, TLS settings
- [Client Management](../README.md#usage) - `client add`, `client list`, `client revoke`, `client renew`
- [Server Management](../README.md#usage) - `server status`, `server renew`, `uninstall`
- [DNS Options](../README.md#features) - Providers including Unbound, Cloudflare, Quad9, and custom resolvers
- [Firewall Integration](../README.md#features) - firewalld, nftables, and iptables support

## In This Repository

- [Helper scripts](../scripts/) - `quick-install.sh` (presets) and `manage.sh` (management shortcuts)
- [Configuration examples](../config/) - Example server and client configuration templates
- [CI/CD pipeline](../.github/workflows/ci-cd.yml) - ShellCheck lint, Trivy security scan, releases

## Built-in Help

The installer documents itself — these work on any machine without root:

```bash
./openvpn-install.sh --help
./openvpn-install.sh install --help
./openvpn-install.sh client --help
./openvpn-install.sh server --help
```
