Bold="\x1b[1m"
Blink="\x1b[5m"
F_Cyan="\x1b[36m"
END='\033[0m'
RED=$'\e[31m'
D="============================================"
#------System Login details-----#
echo -e "$D$D"
echo -e "${Bold}${Blink}${F_Cyan}Current login users in system :${END}"
echo -e "$D$D"
who -q
who -H -a -l
echo -e "$D$D"
