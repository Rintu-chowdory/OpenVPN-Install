#!/bin/bash
# Quick installation script with common presets

set -e

# Color codes
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${BLUE}OpenVPN-Install Quick Setup${NC}\n"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Preset configurations
echo "Choose your setup:"
echo "1) Quick Install (defaults, no IPv6, system DNS)"
echo "2) Secure Install (IPv6 enabled, Unbound DNS)"
echo "3) Custom Install (answer all questions)"

read -p "Select [1-3]: " -e -i 1 CHOICE

case $CHOICE in
    1)
        echo -e "\n${GREEN}Starting quick installation...${NC}\n"
        export AUTO_INSTALL=y
        export APPROVE_INSTALL=y
        export APPROVE_IP=y
        export IPV6_SUPPORT=n
        export PORT_CHOICE=1
        export PROTOCOL_CHOICE=1
        export DNS=1
        export COMPRESSION_ENABLED=n
        export CUSTOMIZE_ENC=n
        export CLIENT=client
        export PASS=1
        ;;
    2)
        echo -e "\n${GREEN}Starting secure installation...${NC}\n"
        export AUTO_INSTALL=y
        export APPROVE_INSTALL=y
        export APPROVE_IP=y
        export IPV6_SUPPORT=y
        export PORT_CHOICE=3
        export PROTOCOL_CHOICE=1
        export DNS=2
        export COMPRESSION_ENABLED=n
        export CUSTOMIZE_ENC=n
        export CLIENT=client
        export PASS=1
        ;;
    3)
        echo -e "\n${GREEN}Starting custom installation...${NC}\n"
        # No exports - manual mode
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

# Run the main installer
/home/rintu-chowdory/openvpn-install.sh
