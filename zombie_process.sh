Bold="\x1b[1m"
Blink="\x1b[5m"
F_Cyan="\x1b[36m"
END='\033[0m'
RED=$'\e[31m'
D="============================================"
#------Checking For Zombie Processes-----#
echo -e "$D$D"
echo -e "${Bold}${Blink}${F_Cyan}Do we have any Zombie Process on host?${END}"
echo -e "$D$D"
ps -eo stat|grep -w Z 1>&2 > /dev/null
if [ $? == 0 ]; then
  echo -e "Number of zombie process on the system are :" $(ps -eo stat|grep -w Z|wc -l)
  echo -e "\n  Below are the details of Zombie process on host\n"
  ZPROC=$(ps -eo stat,pid|grep -w Z|awk '{print $2}')
  for i in $(echo "$ZPROC"); do
      ps -o pid,ppid,user,stat,args -p $i
  done
else
 echo -e "Good News!!No zombie processes found on the system."
fi
