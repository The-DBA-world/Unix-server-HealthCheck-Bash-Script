Bold="\x1b[1m"
Blink="\x1b[5m"
F_Cyan="\x1b[36m"
END='\033[0m'
RED=$'\e[31m'
D="============================================"
#------Check for Memory &SWAP Utilization-----#
echo -e "$D$D"
echo -e "${Bold}${Blink}${F_Cyan}Checking MEMORY Details${END}"
echo -e "Total Memory Memory in MiB : "$(grep -w MemTotal /proc/meminfo|awk '{print $2/1024}')", in GiB : "\
$(grep -w MemTotal /proc/meminfo|awk '{print $2/1024/1024}')
echo -e " Memory Free Memory in MiB : "$(grep -w MemFree /proc/meminfo|awk '{print $2/1024}')", in GiB : "\
$(grep -w MemFree /proc/meminfo|awk '{print $2/1024/1024}')

echo -e "${Bold}${Blink}${F_Cyan}Checking SWAP Details${END}"
echo -e "Total Swap Memory in MiB : "$(grep -w SwapTotal /proc/meminfo|awk '{print $2/1024}')", in GiB : "\
$(grep -w SwapTotal /proc/meminfo|awk '{print $2/1024/1024}')
echo -e " Swap Free Memory in MiB : "$(grep -w SwapFree /proc/meminfo|awk '{print $2/1024}')", in GiB : "\
$(grep -w SwapFree /proc/meminfo|awk '{print $2/1024/1024}')
echo -e "$D$D"
