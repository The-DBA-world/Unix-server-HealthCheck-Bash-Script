Bold="\x1b[1m"
Blink="\x1b[5m"
F_Cyan="\x1b[36m"
END='\033[0m'
RED=$'\e[31m'
D="============================================"
#------Print top 5 Memory & CPU consumed process threads-----#
echo -e "$D$D"
echo -e "${Bold}${Blink}${F_Cyan}Top 5 Memory Resource Hog Processes${END}"
ps -eo pmem,pid,ppid,user,stat,args --sort=-pmem|grep -v $$|head -6|sed 's/$//'
echo -e "\n${Bold}${Blink}${F_Cyan}Top 5 CPU Resource Hog Processes${END}"
ps -eo pcpu,pid,ppid,user,stat,args --sort=-pcpu|grep -v $$|head -6|sed 's/$//'
echo -e "$D$D"
