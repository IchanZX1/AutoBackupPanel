#!/bin/bash

# Color
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
  echo -e "script ini di buat untuk mempermudah melakukan Migrasi pterodactyl,"
  echo -e "Tidak ada yang harus diperjual belikan karena script ini saya buat Khusus Para pengguna Pterodactyl."
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
#Check user token
check_token() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]               LICENSI BY ICHANZX             [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  echo -e "${YELLOW}MASUKAN AKSES TOKEN :${NC}"
  read -r USER_TOKEN

  if [ "$USER_TOKEN" = "ichanzxcoderid" ]; then
    echo -e "${GREEN}AKSES BERHASIL${NC}}"
  else
    echo -e "${GREEN}Buy dulu Weh Ke IchanZX https://t.me/ichanxd${NC}"
    exit 1
  fi
  clear
}

#Backup NodeJS MYSQL PANEL
backup_panel() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]               MEMULAI BACKUP PANEL                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "

mysqldump -u root -p nama_database > /var/www/pterodactyl/panel.sqL
\n
tar -cvpzf backup.tar.gz /etc/letsencrypt /var/www/pterodactyl /etc/nginx/sites-available/pterodactyl.conf
tar -cvzf node.tar.gz /var/lib/pterodactyl /etc/pterodactyl
EOF


  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+]               BACKUP PANEL SUKSES             [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  clear
  exit 0
}

#Memindahkan Panel Dan Set MYSQL
migrate_panel() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]               MEMULAI MIGRASI PANEL                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "

# Minta input token dari pengguna
scp root@$ip_vps:/root/{backup.tar.gz,node.tar.gz} /
tar -xvpzf /backup.tar.gz -C /
systemctl restart nginx
tar -xvzf /node.tar.gz -C /
mysql -u root -p $nama_database < /var/www/pterodactyl/panel.sql
sudo systemctl restart wings
sudo systemctl restart mysql
EOF


  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+]               MIGRASI PANEL SUKSES             [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  clear
  exit 0
}

# Main script
display_welcome
check_token

while true; do
  clear
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]               PILIH TOOLS DIBAWAH                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  echo -e "SELECT OPTION :"
  echo "1. backup panel"
  echo "2. pindahkan panel"
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
