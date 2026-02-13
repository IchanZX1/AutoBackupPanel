#!/bin/bash

VOLUME_PATH="/var/lib/pterodactyl/volumes"
LOG_FILE="/var/log/ichanzxTools.log"

# ===============================
# COLORS
# ===============================
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BOLD=$(tput bold)
RESET=$(tput sgr0)

# ===============================
# LOGGING
# ===============================
log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> $LOG_FILE
}

# ===============================
# PROGRESS BAR
# ===============================
progress_bar() {
    echo ""
    echo -ne "Processing: "
    for i in {1..30}; do
        echo -ne "${GREEN}█${RESET}"
        sleep 0.03
    done
    echo " ${GREEN}Done!${RESET}"
}

# ===============================
# ===============================
# AUTO CLEANUP IF DISK > 80%
# ===============================
check_disk_auto() {
    USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
    if [ "$USAGE" -ge 80 ]; then
        echo "${YELLOW}⚠ Disk $USAGE% - Auto Cleanup...${RESET}"
        log_action "Auto cleanup triggered ($USAGE%)"
        docker container prune -f > /dev/null 2>&1
        docker image prune -a -f > /dev/null 2>&1
        progress_bar
    fi
}

# ===============================
# MONITOR DISK
# ===============================
monitor_disk() {
    log_action "Monitoring disk"
    while true; do
        clear
        echo "${CYAN}${BOLD}Disk Monitoring (CTRL+C to exit)${RESET}"
        echo ""
        df -h /
        sleep 2
    done
}

# ===============================
# BANNER
# ===============================
draw_banner() {
clear
echo "${CYAN}${BOLD}"
echo "╔══════════════════════════════════════════════╗"
echo "║            ZxcoderID Tools PRO+             ║"
echo "║          Interactive System Manager         ║"
echo "╚══════════════════════════════════════════════╝"
echo "     By: IchanZX-Informatics "
echo "${RESET}"
}

# ===============================
# MENU OPTIONS
# ===============================
options=(
"Scan node_modules semua UUID"
"Hapus node_modules semua UUID"
"Lihat docker system df"
"Docker image prune -a -f"
"Docker container prune -f"
"Restart Wings"
"Monitor Disk Real-Time"
"Exit"
)

selected=0

# ===============================
# DRAW MENU
# ===============================
draw_menu() {
draw_banner
echo ""
for i in "${!options[@]}"; do
    if [ $i -eq $selected ]; then
        echo "  ${GREEN}➤ ${options[$i]}${RESET}"
    else
        echo "    ${options[$i]}"
    fi
done
}

# ===============================
# EXECUTE MENU
# ===============================
execute_option() {
case $selected in

0)
    log_action "Scan node_modules"
    clear
    for dir in /var/lib/pterodactyl/volumes/*; do
  if [ -d "$dir/node_modules" ]; then
    echo "ADA node_modules di: $dir"
  fi
done
    read -p "Press Enter..."
    ;;

1)
    log_action "Delete node_modules"
    clear
    rm -rf /var/lib/pterodactyl/volumes/*/node_modules
    progress_bar
    read -p "Press Enter..."
    ;;

2)
    log_action "Docker system df"
    clear
    docker system df
    read -p "Press Enter..."
    ;;

3)
    log_action "Docker image prune"
    clear
    docker image prune -a -f
    progress_bar
    read -p "Press Enter..."
    ;;

4)
    log_action "Docker container prune"
    clear
    docker container prune -f
    progress_bar
    read -p "Press Enter..."
    ;;

5)
    log_action "Restart Wings"
    clear
    systemctl restart wings
    progress_bar
    echo "${GREEN}Wings restarted.${RESET}"
    read -p "Press Enter..."
    ;;

6)
    monitor_disk
    ;;

7)
    clear
    exit
    ;;

esac
}

# ===============================
# MAIN LOOP
# ===============================
check_disk_auto

while true; do
draw_menu
read -rsn1 key
if [[ $key == $'\x1b' ]]; then
    read -rsn2 key
    if [[ $key == "[A" ]]; then
        ((selected--))
        [ $selected -lt 0 ] && selected=$((${#options[@]}-1))
    elif [[ $key == "[B" ]]; then
        ((selected++))
        [ $selected -ge ${#options[@]} ] && selected=0
    fi
elif [[ $key == "" ]]; then
    execute_option
fi
done
