Bold="\x1b[1m"
Blink="\x1b[5m"
F_Cyan="\x1b[36m"
END='\033[0m'
D="============================================"
#------Print most recent 5 Reboot events if available-----#
echo -e "$D$D"
echo -e "${Bold}${Blink}${F_Cyan}Most Recent 5 Reboot Events${END}"
echo -e "$D$D"
last -x 2> /dev/null|grep reboot 1> /dev/null && /usr/bin/last -x 2> /dev/null|grep reboot|head -5 || \
echo -e "No system reboot events are recorded."
echo -e "$D$D"
