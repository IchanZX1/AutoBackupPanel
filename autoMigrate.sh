#!/bin/bash

# Colors
BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Display welcome message
display_welcome() {
  echo -e ""
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                                                 [+]${NC}"
  echo -e "${BLUE}[+]          AUTO BACKUP PANEL PTERODACTYL            [+]${NC}"
  echo -e "${BLUE}[+]               © ICHANZX CODERID               [+]${NC}"
  echo -e "${BLUE}[+]                                                 [+]${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  echo -e ""
  echo -e "script ini dibuat untuk mempermudah melakukan migrasi Pterodactyl."
  echo -e "Tidak ada yang harus diperjualbelikan karena script ini khusus untuk pengguna Pterodactyl."
  echo -e ""
  echo -e "𝗪𝗛𝗔𝗧𝗦𝗔𝗣𝗣 :"
  echo -e "NDAK PUNYA"
  echo -e "𝗬𝗢𝗨𝗧𝗨𝗕𝗘 :"
  echo -e "@IchanGaming"
  echo -e "𝗖𝗥𝗘𝗗𝗜𝗧𝗦 :"
  echo -e "@ZxcoderID"
  sleep 4
  clear
}

# Check user token
check_token() {
  echo -e ""
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]               LICENSI BY ICHANZX             [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e ""
  echo -e "${YELLOW}MASUKAN AKSES TOKEN :${NC}"
  read -r USER_TOKEN

  if [ "$USER_TOKEN" = "ichanzxcoderid" ]; then
    echo -e "${GREEN}AKSES BERHASIL${NC}"
  else
    echo -e "${RED}Akses gagal. Hubungi IchanZX di https://t.me/ichanxd${NC}"
    exit 1
  fi
  clear
}

# Backup NodeJS MYSQL PANEL
backup_panel() {
  echo -e ""
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]               MEMULAI BACKUP PANEL                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e ""

  # Backup other necessary directories
  echo -e "[INFO] Masukkan IP VPS sumber:" 
  read -p "IP VPS: " ip_vps
  echo -e "[INFO] Masukkan User VPS:" 
  read -p "USER VPS: " user_vps
  rsync -az --progress "$user_vps"@"$ip_vps":/var/www/pterodactyl /var/www/
  rsync -az --progress "$user_vps"@"$ip_vps":/etc/letsencrypt /etc/
  rsync -az --progress "$user_vps"@"$ip_vps":/var/lib/pterodactyl /var/lib/
  rsync -az --progress "$user_vps"@"$ip_vps":/etc/pterodactyl /etc/
  scp "$user_vps"@"$ip_vps":/etc/nginx/sites-available/pterodactyl.conf /etc/nginx/sites-available/

  #tar -cvpzf backup.tar.gz /etc/letsencrypt /var/www/pterodactyl /etc/nginx/sites-available/pterodactyl.conf
  #tar -cvzf node.tar.gz /var/lib/pterodactyl /etc/pterodactyl

  echo -e ""
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+]               BACKUP PANEL SUKSES             [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e ""
  sleep 2
  clear
  exit 0
}

# Migrate Panel and Set MYSQL
migrate_panel() {
  echo -e ""
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]               MEMULAI MIGRASI PANEL                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e ""

  # Get IP and database name
  echo -e "[INFO] Masukkan IP VPS sumber:" 
  read -p "IP VPS: " ip_vps
  echo -e "[INFO] Masukkan nama database:" 
  read -p "Nama Database: " nama_database
  echo -e "[INFO] Masukkan password MySQL (Tekan Enter jika tidak ada):" 
  read -s -p "Password MySQL: " mysql_password
  echo

  # Get VPS password twice
  echo -e "[INFO] Masukkan password VPS:" 
  read -sp "Password VPS: " vps_password1
  echo
  echo -e "[INFO] Masukkan password VPS lagi:" 
  read -sp "Password VPS Lagi: " vps_password2
  echo

  # Check if both passwords match
  if [ "$vps_password1" != "$vps_password2" ]; then
    echo -e "${RED}[ERROR] Password VPS tidak cocok!${NC}"
    exit 1
  fi

  # Transfer backup files and check if the transfer was successful
  echo -e "${BLUE}[INFO] Mentransfer file backup dari $ip_vps ...${NC}"
  scp -o StrictHostKeyChecking=no -o LogLevel=ERROR root@"$ip_vps":/root/backup.tar.gz / || { echo -e "${RED}[ERROR] Gagal mentransfer backup.tar.gz${NC}"; exit 1; }
  scp -o StrictHostKeyChecking=no -o LogLevel=ERROR root@"$ip_vps":/root/node.tar.gz / || { echo -e "${RED}[ERROR] Gagal mentransfer node.tar.gz${NC}"; exit 1; }
  scp -o StrictHostKeyChecking=no -o LogLevel=ERROR root@"$ip_vps":/panel.sql / || { echo -e "${RED}[ERROR] Gagal mentransfer panel.sql${NC}"; exit 1; }

  # Extract the transferred files
  echo -e "[INFO] Mengekstrak file backup ...${NC}"
  tar -xvpzf /backup.tar.gz -C / || { echo -e "${RED}[ERROR] Gagal mengekstrak backup.tar.gz${NC}"; exit 1; }
  tar -xvzf /node.tar.gz -C / || { echo -e "${RED}[ERROR] Gagal mengekstrak node.tar.gz${NC}"; exit 1; }
  echo -e "[INFO] Masukkan Perintah MYSQL:" 
  sleep 180
  
  # Restart services
  echo -e "[INFO] Restarting services..."
  sudo systemctl restart nginx || { echo -e "${RED}[ERROR] Gagal restart nginx${NC}"; exit 1; }
  sudo systemctl restart wings || { echo -e "${RED}[ERROR] Gagal restart wings${NC}"; exit 1; }
  sudo systemctl restart mysql || { echo -e "${RED}[ERROR] Gagal restart mysql${NC}"; exit 1; }

  echo -e ""
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+]               MIGRASI PANEL SUKSES             [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e ""
  exit 0
}

# Main script
display_welcome
check_token

while true; do
  clear
  echo -e ""
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]               PILIH TOOLS DIBAWAH                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e ""
  echo -e "SELECT OPTION :"
  echo "1. Backup panel"
  echo "2. Pindahkan panel"
  echo "x. Exit"
  echo -e "Masukkan pilihan (1/2/x):"
  read -r MENU_CHOICE
  clear

  case "$MENU_CHOICE" in
    1)
      backup_panel
      ;;
    2)
      migrate_panel
      ;;
    x)
      echo "Keluar dari skrip."
      exit 0
      ;;
    *)
      echo "Pilihan tidak valid, silahkan coba lagi."
      ;;
  esac
done
