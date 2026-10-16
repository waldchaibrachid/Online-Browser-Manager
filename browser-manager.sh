#!/bin/bash

Red='\e[0;31m'; Green='\e[0;32m'; Yellow='\e[0;33m'
Blue='\e[0;34m'; Purple='\e[0;35m'; Cyan='\e[0;36m'; White='\e[0;37m'
BRed='\e[1;31m'; BGreen='\e[1;32m'; BYellow='\e[1;33m'; BWhite='\e[1;37m'
NC='\e[0m'

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
    echo -e "     |                                                                                                               ${BCyan} v3.1${Yellow}    |"
    echo -e "${Cyan}    +${Yellow}--------------------------------------------------------------------------------------------------------------------------${Cyan}+${NC}"
    echo ""
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${BRed}[ERROR]${NC} Docker is not installed."
        exit 1
    fi
}

install_browser() {
    local name=$1
    local image=$2
    local port=6080
    local internal_port=3000
    
    echo -e "${BYellow}[*]${NC} Installing ${BGreen}$name${NC}..."
    echo -e "${BCyan}[i]${NC} Downloading image and starting container (this may take a few minutes)...\n"
    
    # FIX: Automatically remove old stopped containers with the same name
    if docker ps -a --format '{{.Names}}' | grep -q "^${name}$"; then
        echo -e "${BYellow}[!]${NC} Container '$name' already exists. Removing old version..."
        docker rm -f "$name" > /dev/null 2>&1
    fi

    # Download progress is now visible!
    docker run -d \
        --name="$name" \
        --shm-size="3gb" \
        --memory="3g" \
        --ulimit nofile=65536:65536 \
        -p "$port:$internal_port" \
        -v "$HOME/$name-config":/config \
        -e PUID=1000 \
        -e PGID=1000 \
        -e TZ=UTC \
        --security-opt seccomp=unconfined \
        --restart unless-stopped \
        "$image"

    if [ $? -eq 0 ]; then
        echo -e "\n${BGreen}[✔]${NC} $name installed successfully!"
        echo -e "${BCyan}[i]${NC} Access via Web Preview on port ${BYellow}6080${NC}"
    else
        echo -e "${BRed}[✖]${NC} Failed to install $name."
    fi
}

manage_browser() {
    local name=$1
    local action=$2
    
    case $action in
        "1")
            docker start "$name" > /dev/null && echo -e "${BGreen}[✔]${NC} Started $name" || echo -e "${BRed}[✖]${NC} Failed"
            ;;
        "2")
            docker stop "$name" > /dev/null && echo -e "${BYellow}[✔]${NC} Stopped $name" || echo -e "${BRed}[✖]${NC} Failed"
            ;;
        "3")
            docker stop "$name" > /dev/null 2>&1
            docker rm "$name" > /dev/null 2>&1
            rm -rf "$HOME/$name-config"
            echo -e "${BRed}[✔]${NC} Removed $name and its config."
            ;;
        "4")
            docker logs --tail 20 "$name"
            ;;
    esac
}

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
                
                echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
                echo -e "${White}     | ${Yellow} ID ${White} |                   ${BPurple}   Select Browser                       ${White}   |"
                echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
                echo -e "${White}     | ${Red}[${Yellow}1${Red}]${White}  | ${BGreen}Chromium${White}                                                  |"
                echo -e "${White}     | ${Red}[${Yellow}2${Red}]${White}  | ${BGreen}Firefox${White}                                                   |"
                echo -e "${White}     | ${Red}[${Yellow}3${Red}]${White}  | ${BGreen}Opera${White}                                                     |"
                echo -e "${White}     | ${Red}[${Yellow}4${Red}]${White}  | ${BGreen}Mullvad Browser${White}                                           |"
                echo -e "${White}     | ${Red}[${Yellow}0${Red}]${White}  | ${BRed}Back to Main Menu${White}                                         |"
                echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
                echo ""
                echo -e -n "${White}    ${Red}[${Cyan}!${Red}]${White} Enter browser number: ${NC}"
                read -r b_choice
                
                case $b_choice in
                    1) b_name="chromium" ;;
                    2) b_name="firefox" ;;
                    3) b_name="opera" ;;
                    4) b_name="mullvad-browser" ;;
                    0) continue ;;
                    *) 
                        echo -e "${BRed}[!] Invalid choice.${NC}"
                        sleep 1
                        continue 
                        ;;
                esac
                
                echo ""
                echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
                echo -e "${White}     | ${Yellow} ID ${White} |                   ${BPurple}   Select Action                        ${White}   |"
                echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
                echo -e "${White}     | ${Red}[${Yellow}1${Red}]${White}  | ${BGreen}Start${White}                                                     |"
                echo -e "${White}     | ${Red}[${Yellow}2${Red}]${White}  | ${BYellow}Stop${White}                                                      |"
                echo -e "${White}     | ${Red}[${Yellow}3${Red}]${White}  | ${BRed}Remove (Deletes all data)${White}                                 |"
                echo -e "${White}     | ${Red}[${Yellow}4${Red}]${White}  | ${BCyan}View Logs${White}                                                 |"
                echo -e "${White}     | ${Red}[${Yellow}0${Red}]${White}  | ${BRed}Back to Main Menu${White}                                         |"
                echo -e "${Yellow}     +${White}-------------------------------------------------------------------${Yellow}+"
                echo ""
                echo -e -n "${White}    ${Red}[${Cyan}!${Red}]${White} Choose action number: ${NC}"
                read -r action
                
                if [[ "$action" == "0" ]]; then continue; fi
                manage_browser "$b_name" "$action"
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

check_docker
main_menu
