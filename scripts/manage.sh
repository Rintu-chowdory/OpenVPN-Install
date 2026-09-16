#!/bin/bash
# OpenVPN-Install - Helper script to manage the OpenVPN server.
# Wraps ./openvpn-install.sh client/server subcommands.
# Usage: ./manage.sh <add-client|list-clients|revoke-client|status|restart>

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALLER="$SCRIPT_DIR/../openvpn-install.sh"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

function check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}Error: This script must be run as root${NC}"
        exit 1
    fi
}

function check_openvpn() {
    if [[ ! -f /etc/openvpn/server.conf ]]; then
        echo -e "${RED}Error: OpenVPN is not installed${NC}"
        echo "Run scripts/quick-install.sh or ./openvpn-install.sh first."
        exit 1
    fi
}

function usage() {
    cat <<USAGE
Usage: $0 <command>

Commands:
  add-client <name>     Add a new client (generates .ovpn in ~/clients)
  list-clients          List all client certificates
  revoke-client <name>  Revoke a client and disconnect it
  status                Show OpenVPN server status
  restart               Restart the OpenVPN service
USAGE
}

COMMAND="${1:-}"
shift || true
case $COMMAND in
    add-client)
        check_root
        check_openvpn
        NAME="${1:?Usage: $0 add-client <name>}"
        "$INSTALLER" client add "$NAME"
        echo -e "${GREEN}Client '$NAME' added. Config written to ~/clients/$NAME.ovpn${NC}"
        ;;
    list-clients)
        check_openvpn
        "$INSTALLER" client list
        ;;
    revoke-client)
        check_root
        check_openvpn
        NAME="${1:?Usage: $0 revoke-client <name>}"
        "$INSTALLER" client revoke "$NAME"
        echo -e "${GREEN}Client '$NAME' revoked and disconnected.${NC}"
        ;;
    status)
        "$INSTALLER" server status
        ;;
    restart)
        check_root
        check_openvpn
        echo -e "${YELLOW}Restarting OpenVPN...${NC}"
        systemctl restart openvpn@server
        systemctl status openvpn@server --no-pager
        ;;
    ""|-h|--help)
        usage
        ;;
    *)
        echo -e "${RED}Unknown command: $COMMAND${NC}"
        usage
        exit 1
        ;;
esac
