Bold="\x1b[1m"
Blink="\x1b[5m"
F_Cyan="\x1b[36m"
END='\033[0m'
D="============================================"
#------Check for load average (current data)-----#
echo -e "$D$D"
echo -e "${Bold}${Blink}${F_Cyan}Checking For Load Average on host${END}"
echo -e "$D$D"
echo -e "Current Load Average : $(uptime|grep -o "load average.*"|awk '{print $3" " $4" " $5}')"
echo -e "$D$D"
