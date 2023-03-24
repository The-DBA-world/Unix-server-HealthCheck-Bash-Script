# Script will provide shutdown events if any on Linux Host
# Git Code : https://github.com/The-DBA-world/Unix-server-HealthCheck-Bash-Script/new/main
# execute: ./shut_events.sh

Bold="\x1b[1m"
Blink="\x1b[5m"
F_Cyan="\x1b[36m"
END='\033[0m'
D="============================================"
#------Print most recent 5 shutdown events if available-----#
echo -e "$D$D"
echo -e "${Bold}${Blink}${F_Cyan}Most Recent 5 Shutdown Events${END}"
echo -e "$D$D"
last -x 2> /dev/null|grep shutdown 1> /dev/null && /usr/bin/last -x 2> /dev/null|grep shutdown|head -5 || \
echo -e "No shutdown events are recorded."
echo -e "$D$D"

