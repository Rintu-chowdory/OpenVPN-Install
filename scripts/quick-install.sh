#!/bin/bash
# Quick installation with common presets.
# Wraps ./openvpn-install.sh install with sensible defaults.
# See ./openvpn-install.sh install --help for all available options.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALLER="$SCRIPT_DIR/../openvpn-install.sh"

BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${BLUE}OpenVPN-Install Quick Setup${NC}\n"

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

if [[ -f /etc/openvpn/server.conf ]]; then
    echo "OpenVPN is already installed - run './openvpn-install.sh' for the management menu." >&2
    exit 1
fi

echo "Choose your setup:"
echo "1) Quick Install (defaults: UDP 1194, IPv4, Cloudflare DNS)"
echo "2) Secure Install (IPv6 enabled, Unbound local DNS resolver, TLS 1.3 min)"
echo "3) Custom Install (full interactive wizard)"

read -rp "Select [1-3]: " -e -i 1 CHOICE

case $CHOICE in
    1)
        echo -e "\n${GREEN}Starting quick installation...${NC}\n"
        "$INSTALLER" install --dns cloudflare
        ;;
    2)
        echo -e "\n${GREEN}Starting secure installation...${NC}\n"
        "$INSTALLER" install --client-ipv6 --dns unbound --tls-version-min 1.3
        ;;
    3)
        echo -e "\n${GREEN}Starting interactive installation...${NC}\n"
        "$INSTALLER" install --interactive
        ;;
    *)
        echo "Invalid choice. Aborting."
        exit 1
        ;;
esac
