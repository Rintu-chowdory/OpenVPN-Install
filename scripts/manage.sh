#!/bin/bash
# OpenVPN-Install - Helper script to manage OpenVPN configuration
# Usage: ./manage.sh [add-client|revoke-client|status|restart|logs]

set -e

OPENVPN_CONF="/etc/openvpn/server.conf"
LOG_FILE="/var/log/openvpn/status.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

function check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}Error: This script must be run as root${NC}"
        exit 1
    fi
}

function check_openvpn() {
    if [[ ! -f "$OPENVPN_CONF" ]]; then
        echo -e "${RED}Error: OpenVPN is not installed${NC}"
        exit 1
    fi
}

function add_client() {
    echo -e "${YELLOW}Adding new OpenVPN client...${NC}"
    /home/rintu-chowdory/openvpn-install.sh
}

function revoke_client() {
    echo -e "${YELLOW}Revoking OpenVPN client...${NC}"
    /home/rintu-chowdory/openvpn-install.sh
}

function status() {
    echo -e "${GREEN}OpenVPN Status:${NC}"
    systemctl status openvpn-server@server 2>/dev/null || systemctl status openvpn@server 2>/dev/null || echo "OpenVPN not running"
    
    if [[ -f "$LOG_FILE" ]]; then
        echo -e "\n${GREEN}Recent connections:${NC}"
        tail -20 "$LOG_FILE"
    fi
}

function restart_openvpn() {
    echo -e "${YELLOW}Restarting OpenVPN...${NC}"
    systemctl restart openvpn-server@server 2>/dev/null || systemctl restart openvpn@server 2>/dev/null
    echo -e "${GREEN}OpenVPN restarted${NC}"
}

function show_logs() {
    echo -e "${GREEN}OpenVPN Logs:${NC}"
    if [[ -f "$LOG_FILE" ]]; then
        tail -f "$LOG_FILE"
    else
        echo "Log file not found"
    fi
}

function show_config() {
    echo -e "${GREEN}Current OpenVPN Configuration:${NC}"
    grep -E "^(port|proto|cipher|auth|tls-)" "$OPENVPN_CONF" || echo "Could not read configuration"
}

function usage() {
    cat << EOF
OpenVPN-Install Management Script

Usage: $(basename "$0") [COMMAND]

Commands:
    add-client      Add a new client certificate
    revoke-client   Revoke a client certificate
    status          Show OpenVPN status
    restart         Restart the OpenVPN service
    logs            Tail the OpenVPN logs
    config          Show current configuration
    help            Show this help message

Examples:
    sudo $(basename "$0") add-client
    sudo $(basename "$0") status
    sudo $(basename "$0") logs

EOF
}

# Main logic
check_root
check_openvpn

case "${1:-help}" in
    add-client)
        add_client
        ;;
    revoke-client)
        revoke_client
        ;;
    status)
        status
        ;;
    restart)
        restart_openvpn
        ;;
    logs)
        show_logs
        ;;
    config)
        show_config
        ;;
    help)
        usage
        ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        usage
        exit 1
        ;;
esac
