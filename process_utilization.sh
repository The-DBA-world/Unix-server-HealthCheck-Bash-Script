Bold="\x1b[1m"
Blink="\x1b[5m"
F_Cyan="\x1b[36m"
END='\033[0m'
RED=$'\e[31m'
D="================================================"
#------Checking For Process Utilization-----#
echo -e "$D$D"
echo -e "${Bold}${Blink}${F_Cyan}Current Process Utilization Summary :${END}"
echo -e "$D$D"
mpstat|tail -2
echo -e "$D$D"
