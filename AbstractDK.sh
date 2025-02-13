#!/bin/bash

# ----------------------------
# Color and Icon Definitions
# ----------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
RESET='\033[0m'

CHECKMARK="✅"
ERROR="❌"
PROGRESS="⏳"
INSTALL="🛠️"
STOP="⏹️"
RESTART="🔄"
LOGS="📄"
EXIT="🚪"
INFO="ℹ️"

# ----------------------------
# Install Docker
# ----------------------------
install_docker() {
    echo -e "${INSTALL} Installing Docker...${RESET}"
    
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    echo -e "${CHECKMARK} Docker installed successfully.${RESET}"
    read -p "Press Enter to return to the main menu."
}

# ----------------------------
# Install Mainnet
# ----------------------------
install_mainnet() {
    echo -e "${INSTALL} Setting up Abstract Mainnet...${RESET}"
    
    if [ -d "abstract-node" ]; then
        echo -e "${INFO} abstract-node directory already exists. Updating...${RESET}"
        cd abstract-node
        git pull
    else
        git clone https://github.com/Abstract-Foundation/abstract-node
        cd abstract-node
    fi
    
    docker compose --file external-node/mainnet-external-node.yml up -d
    echo -e "${CHECKMARK} Abstract Mainnet started successfully.${RESET}"
    cd ..
    read -p "Press Enter to return to the main menu."
}

# ----------------------------
# Install Testnet
# ----------------------------
install_testnet() {
    echo -e "${INSTALL} Setting up Abstract Testnet...${RESET}"
    
    if [ -d "abstract-node" ]; then
        echo -e "${INFO} abstract-node directory already exists. Updating...${RESET}"
        cd abstract-node
        git pull
    else
        git clone https://github.com/Abstract-Foundation/abstract-node
        cd abstract-node
    fi
    
    docker compose --file external-node/testnet-external-node.yml up -d
    echo -e "${CHECKMARK} Abstract Testnet started successfully.${RESET}"
    cd ..
    read -p "Press Enter to return to the main menu."
}

# ----------------------------
# View Logs for a Container
# ----------------------------
view_logs() {
    echo -e "${INFO} Available containers:${RESET}"
    echo "1. testnet-node-external-node-1"
    echo "2. testnet-node-postgres-1"
    echo "3. testnet-node-prometheus-1"
    echo "4. testnet-node-grafana-1"
    echo "5. mainnet-node-external-node-1"
    echo "6. mainnet-node-postgres-1"
    echo "7. mainnet-node-prometheus-1"
    echo "8. mainnet-node-grafana-1"
    
    read -p "Enter container number [1-8]: " num
    case $num in
        1) container="testnet-node-external-node-1";;
        2) container="testnet-node-postgres-1";;
        3) container="testnet-node-prometheus-1";;
        4) container="testnet-node-grafana-1";;
        5) container="mainnet-node-external-node-1";;
        6) container="mainnet-node-postgres-1";;
        7) container="mainnet-node-prometheus-1";;
        8) container="mainnet-node-grafana-1";;
        *) echo -e "${ERROR} Invalid selection${RESET}"; return;;
    esac

    echo -e "${LOGS} Tailing logs for $container...${RESET}"
    docker logs -f $container
    read -p "Press Enter to return to the main menu."
}

# ----------------------------
# Stop Mainnet
# ----------------------------
stop_mainnet() {
    echo -e "${STOP} Stopping Abstract Mainnet...${RESET}"
    cd abstract-node
    docker compose --file external-node/mainnet-external-node.yml down
    cd ..
    echo -e "${CHECKMARK} Mainnet stopped successfully.${RESET}"
    read -p "Press Enter to return to the main menu."
}

# ----------------------------
# Stop Testnet
# ----------------------------
stop_testnet() {
    echo -e "${STOP} Stopping Abstract Testnet...${RESET}"
    cd abstract-node
    docker compose --file external-node/testnet-external-node.yml down
    cd ..
    echo -e "${CHECKMARK} Testnet stopped successfully.${RESET}"
    read -p "Press Enter to return to the main menu."
}

# ----------------------------
# Display ASCII Art
# ----------------------------
display_ascii() {
    clear
    echo -e "    ${RED}    ____  __ __    _   ______  ____  ___________${RESET}"
    echo -e "    ${GREEN}   / __ \\/ //_/   / | / / __ \\/ __ \\/ ____/ ___/${RESET}"
    echo -e "    ${BLUE}  / / / / ,<     /  |/ / / / / / / / __/  \\__ \\ ${RESET}"
    echo -e "    ${YELLOW} / /_/ / /| |   / /|  / /_/ / /_/ / /___ ___/ / ${RESET}"
    echo -e "    ${MAGENTA}/_____/_/ |_|  /_/ |_/\____/_____/_____//____/  ${RESET}"
    echo -e "    ${MAGENTA}🚀 Follow us on Telegram: https://t.me/dknodes${RESET}"
    echo -e "    ${MAGENTA}📢 Follow us on Twitter: https://x.com/dknodes${RESET}"
    echo -e "    ${GREEN}Welcome to the Abstract Node Management System!${RESET}"
    echo -e ""
}

# ----------------------------
# Main Menu
# ----------------------------
show_menu() {
    clear
    display_ascii
    echo -e "    ${YELLOW}Choose an operation:${RESET}"
    echo -e "    ${CYAN}1.${RESET} ${INSTALL} Install Docker"
    echo -e "    ${CYAN}2.${RESET} ${INSTALL} Start Mainnet Node"
    echo -e "    ${CYAN}3.${RESET} ${INSTALL} Start Testnet Node"
    echo -e "    ${CYAN}4.${RESET} ${LOGS} View Container Logs"
    echo -e "    ${CYAN}5.${RESET} ${STOP} Stop Mainnet Node"
    echo -e "    ${CYAN}6.${RESET} ${STOP} Stop Testnet Node"
    echo -e "    ${CYAN}7.${RESET} ${EXIT} Exit"
    echo -ne "    ${YELLOW}Enter your choice [1-7]: ${RESET}"
}

# ----------------------------
# Main Loop
# ----------------------------
while true; do
    show_menu
    read choice
    case $choice in
        1) install_docker;;
        2) install_mainnet;;
        3) install_testnet;;
        4) view_logs;;
        5) stop_mainnet;;
        6) stop_testnet;;
        7)
            echo -e "${EXIT} Exiting...${RESET}"
            exit 0
            ;;
        *)
            echo -e "${ERROR} Invalid option. Please try again.${RESET}"
            read -p "Press Enter to continue..."
            ;;
    esac
done
