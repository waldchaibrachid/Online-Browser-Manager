
---

### 📜 File 2: `browser-manager.sh`
*Create this file in your repository. This is the improved, interactive script.*

```bash
#!/bin/bash

# ==========================================
# Color Definitions
# ==========================================
Red='\e[0;31m'; Green='\e[0;32m'; Yellow='\e[0;33m'
Blue='\e[0;34m'; Purple='\e[0;35m'; Cyan='\e[0;36m'; White='\e[0;37m'
BRed='\e[1;31m'; BGreen='\e[1;32m'; BYellow='\e[1;33m'; BWhite='\e[1;37m'
NC='\e[0m' # No Color

# ==========================================
# Helper Functions
# ==========================================
clear_screen() { clear; }

print_header() {
    clear_screen
    echo -e "${Cyan}    +${Yellow}--------------------------------------------------------------------------------------------------------------------------${Cyan}+"
    echo -e "${Yellow}     |                                                                                                                        |"
    echo -e "     |${BGreen}     ██████╗ ███╗   ██╗██╗     ██╗███╗   ██╗███████╗    ${BRed}██████${White}╗${BRed} ██████${White}╗${BRed}  ██████${White}╗${BRed} ██${White}╗${BRed}    ██${White}╗${BRed}███████${White}╗${BRed}███████${White}╗${BRed}██████${White}╗  ${Yellow}    |"
    echo -e "     |${BGreen}    ██╔═══██╗████╗  ██║██║     ██║████╗  ██║██╔════╝    ${BRed}██${White}╔══${BRed}██${White}╗${BRed}██${White}╔══${BRed}██${White}╗${BRed}██${White}╔═══${BRed}██${White}╗${BRed}██${White}║${BRed}    ██${White}║${BRed}██${White}╔════╝${BRed}██${White}╔════╝${BRed}██${White}╔══${BRed}██${White}╗${BRed}    ${Yellow} |"
    echo -e "     |${Green}    ██║   ██║██╔██╗ ██║██║     ██║██╔██╗ ██║█████╗      ${Red}██████${White}╔╝${Red}██████${White}╔╝${Red}██${White}║   ${Red}██${White}║${Red}██${White}║ ${Red}█${White}╗ ${Red}██${White}║${Red}███████${White}╗${Red}█████${White}╗  ${Red}██████${White}╔╝    ${Yellow} |"
    echo -e "     |${Green}    ██║   ██║██║╚██╗██║██║     ██║██║╚██╗██║██╔══╝      ${Red}██${White}╔══${Red}██${White}╗${Red}██${White}╔══${Red}██${White}╗${Red}██${White}║   ${Red}██${White}║${Red}██${White}║${Red}███${White}╗${Red}██${White}║╚════${Red}██${White}║${Red}██${White}╔══╝  ${Red}██${White}╔══${Red}██${White}╗    ${Yellow} |"
    echo -e "     |${BGreen}    ╚██████╔╝██║ ╚████║███████╗██║██║ ╚████║███████╗    ${BRed}██████${White}╔╝${BRed}██${White}║${BRed}  ██${White}║╚${BRed}██████${White}╔╝╚${BRed}███${White}╔${BRed}███${White}╔╝${BRed}███████${White}║${BRed}███████${White}╗${BRed}██${White}║  ${BRed}██${White}║    ${Yellow} |"
    echo -e "     |${Green}     ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝╚═╝  ╚═══╝╚══════╝    ${White}╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚══════╝╚══════╝╚═╝  ╚═╝ ${Yellow}    |"
    echo -e "     |                                                                                                               ${BCyan} v2.0${Yellow}    |"
    echo -e "${Cyan}    +${Yellow}--------------------------------------------------------------------------------------------------------------------------${Cyan}+${NC}"
    echo ""
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${BRed}[ERROR]${NC} Docker is not installed. Please install Docker first."
        exit 1
    fi
}

install_browser() {
    local name=$1
    local image=$2
    local port=6080
    local internal_port=3000
    
    echo -e "${BYellow}[*]${NC} Installing ${BGreen}$name${NC}..."
    
    # Check if already running
    if docker ps --format '{{.Names}}' | grep -q "^${name}$"; then
        echo -e "${BRed}[!]${NC} $name is already running!"
        return
    fi

    docker run -d \
        --name="$name" \
        --shm-size="2gb" \
        -p "$port:$internal_port" \
        -v "$HOME/$name-config":/config \
        -e PUID=1000 \
        -e PGID=1000 \
        -e TZ=UTC \
        --security-opt seccomp=unconfined \
        --restart unless-stopped \
        "$image" > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo -e "${BGreen}[✔]${NC} $name installed successfully!"
        echo -e "${BCyan}[i]${NC} Access it via Web Preview on port ${BYellow}6080${NC} (or http://localhost:6080)"
    else
        echo -e "${BRed}[✖]${NC} Failed to install $name."
    fi
}

manage_browser() {
    local name=$1
    local action=$2
    
    case $action in
        "start")
            docker start "$name" > /dev/null && echo -e "${BGreen}[✔]${NC} Started $name" || echo -e "${BRed}[✖]${NC} Failed to start $name"
            ;;
        "stop")
            docker stop "$name" > /dev/null && echo -e "${BYellow}[✔]${NC} Stopped $name" || echo -e "${BRed}[✖]${NC} Failed to stop $name"
            ;;
        "remove")
            docker stop "$name" > /dev/null 2>&1
            docker rm "$name" > /dev/null 2>&1
            rm -rf "$HOME/$name-config"
            echo -e "${BRed}[✔]${NC} Completely removed $name and its config."
            ;;
        "logs")
            echo -e "${BCyan}--- Last 15 lines of $name logs ---${NC}"
            docker logs --tail 15 "$name"
            echo -e "${BCyan}------------------------------------${NC}"
            ;;
    esac
}

# ==========================================
# Main Menu Loop
# ==========================================
main_menu() {
    while true; do
        print_header
        echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
        echo -e "${White}     | ${Yellow} ID ${White} |                   ${BPurple}   Action / Browser                     ${White}   |"
        echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
        echo -e "${White}     | ${Red}[${Yellow}1${Red}]${White}  | ${BGreen}Install Chromium${White}                                          |"
        echo -e "${White}     | ${Red}[${Yellow}2${Red}]${White}  | ${BGreen}Install Firefox${White}                                           |"
        echo -e "${White}     | ${Red}[${Yellow}3${Red}]${White}  | ${BGreen}Install Opera${White}                                             |"
        echo -e "${White}     | ${Red}[${Yellow}4${Red}]${White}  | ${BGreen}Install Mullvad Browser${White}                                   |"
        echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
        echo -e "${White}     | ${Red}[${Yellow}5${Red}]${White}  | ${BYellow}Manage Existing Browsers (Start/Stop/Remove/Logs)${White}       |"
        echo -e "${White}     | ${Red}[${Yellow}0${Red}]${White}  | ${BRed}Exit${White}                                                       |"
        echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
        echo ""
        echo -e -n "${White}    ${Red}[${Cyan}!${Red}]${White} Enter your choice: ${NC}"
        read -r choice

        case $choice in
            1) install_browser "chromium" "lscr.io/linuxserver/chromium:latest" ;;
            2) install_browser "firefox" "lscr.io/linuxserver/firefox:latest" ;;
            3) install_browser "opera" "lscr.io/linuxserver/opera:latest" ;;
            4) install_browser "mullvad-browser" "lscr.io/linuxserver/mullvad-browser:latest" ;;
            5) 
                clear_screen
                echo -e "${BCyan}--- Currently Installed Browsers ---${NC}"
                docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "chromium|firefox|opera|mullvad" || echo -e "${BYellow}No browsers found.${NC}"
                echo ""
                echo -e -n "${White}Enter browser name to manage (or 'back' to return): ${NC}"
                read -r b_name
                if [[ "$b_name" == "back" ]]; then continue; fi
                
                if [[ -n "$b_name" ]]; then
                    echo -e "${White}Actions: ${Green}start${White}, ${BYellow}stop${White}, ${BRed}remove${White}, ${BCyan}logs${NC}"
                    echo -e -n "Choose action: ${NC}"
                    read -r action
                    manage_browser "$b_name" "$action"
                fi
                ;;
            0) 
                echo -e "${BGreen}Exiting. Happy browsing! ( •̀ ω •́ )✧${NC}"
                exit 0 
                ;;
            *) 
                echo -e "${BRed}[!] Invalid choice. Please try again.${NC}"
                sleep 1
                ;;
        esac
        
        echo ""
        echo -e "${White}Press ${BYellow}Enter${White} to continue...${NC}"
        read -r
    done
}

# ==========================================
# Execution
# ==========================================
check_docker
main_menu
