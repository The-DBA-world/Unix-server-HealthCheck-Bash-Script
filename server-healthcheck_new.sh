####################################################################################################################################
#!/bin/bash                                                                                                                        ##
##Github page:https://github.com/The-DBA-world/Unix-server-HealthCheck-Bash-Script/blob/main/server-healthcheck_new.sh ------------##
##---------- Purpose : To quickly check and report health status in a linux system.------------------------------------------------##
##---------- Tested on : RHEL8/7/6/, SLES/SLED 15/12/11, Ubuntu20/18/16, CentOS  --------------------------------------------------##
##-----------NOTE: This script requires root privileges ---------------------------------------------------------------------------##
##----------- "sudo /bin/bash server-healthcheck_new.sh" --------------------------------------------------------------------------##
#####################################################################################################################################


#------variables ----------------------#
S="************************************"
D="-------------------------------------"
COLOR="y"
Bold="\x1b[1m"
Blink="\x1b[5m"
F_Cyan="\x1b[36m"
END='\033[0m'

MOUNT=$(mount|egrep -iw "ext4|ext3|xfs|gfs|gfs2|btrfs"|grep -v "loop"|sort -u -t' ' -k1,2)
FS_USAGE=$(df -PThl -x tmpfs -x iso9660 -x devtmpfs -x squashfs|awk '!seen[$1]++'|sort -k6n|tail -n +2)
IUSAGE=$(df -iPThl -x tmpfs -x iso9660 -x devtmpfs -x squashfs|awk '!seen[$1]++'|sort -k6n|tail -n +2)

if [ $COLOR == y ]; then
{
 GCOLOR="\e[47;32m ------ OK/HEALTHY \e[0m"
 WCOLOR="\e[43;31m ------ WARNING \e[0m"
 CCOLOR="\e[47;31m ------ CRITICAL \e[0m"
}
else
{
 GCOLOR=" ------ OK/HEALTHY "
 WCOLOR=" ------ WARNING "
 CCOLOR=" ------ CRITICAL "
}
fi

echo -e "$S"
echo -e "\tSystem Health Status"
echo -e "$S"

#--------Print Operating System Details--------#
hostname -f &> /dev/null && printf "Hostname : $(hostname -f)" || printf "Hostname : $(hostname -s)"

echo -e "\n${Bold}${Blink}${F_Cyan}Operating System : ${END}"
[ -f /etc/os-release ] && echo $(egrep -w "NAME|VERSION" /etc/os-release|awk -F= '{ print $2 }'|sed 's/"//g') || cat /etc/system-release

echo -e "${Bold}${Blink}${F_Cyan}Kernel Version :${END}" $(uname -r)
printf "OS Architecture :"$(arch | grep x86_64 &> /dev/null) && printf " 64 Bit OS\n"  || printf " 32 Bit OS\n"

#--------Print system uptime-------#
UPTIME=$(uptime)
echo -en "${Bold}${Blink}${F_Cyan}System Uptime : ${END}"
echo $UPTIME|grep day &> /dev/null
if [ $? != 0 ]; then
  echo $UPTIME|grep -w min &> /dev/null && echo -en "$(echo $UPTIME|awk '{print $2" by "$3}'|sed -e 's/,.*//g') minutes" \
 || echo -en "$(echo $UPTIME|awk '{print $2" by "$3" "$4}'|sed -e 's/,.*//g') hours"
else
  echo -en $(echo $UPTIME|awk '{print $2" by "$3" "$4" "$5" hours"}'|sed -e 's/,//g')
fi
echo -e "\nCurrent System Date & Time : "$(date +%c)

#--------Check for any read-only file systems--------#
echo -e "\n${Bold}${Blink}${F_Cyan}Checking For Read-only File System[s]${END}"
echo -e "$D"
echo "$MOUNT"|grep -w ro && echo -e "\n.....Read Only file system[s] found"|| echo -e ".....No read-only file system[s] found. "

#--------Check for currently mounted file systems--------#
echo -e "\n\n${Bold}${Blink}${F_Cyan}Checking For Currently Mounted File System[s]${END}"
echo -e "$D$D"
echo "$MOUNT"|column -t

#--------Check disk usage on all mounted file systems--------#
echo -e "\n\n${Bold}${Blink}${F_Cyan}Checking For Disk Usage On Mounted File System[s]${END}"
echo -e "$D$D"
echo -e "( 0-85% = OK/HEALTHY,  85-95% = WARNING,  95-100% = CRITICAL )"
echo -e "$D$D"
echo -e "Mounted File System[s] Utilization (Percentage Used):\n"

COL1=$(echo "$FS_USAGE"|awk '{print $1 " "$7}')
COL2=$(echo "$FS_USAGE"|awk '{print $6}'|sed -e 's/%//g')

for i in $(echo "$COL2"); do
{
  if [ $i -ge 95 ]; then
    COL3="$(echo -e $i"% $CCOLOR\n$COL3")"
  elif [[ $i -ge 85 && $i -lt 95 ]]; then
    COL3="$(echo -e $i"% $WCOLOR\n$COL3")"
  else
    COL3="$(echo -e $i"% $GCOLOR\n$COL3")"
  fi
}
done
COL3=$(echo "$COL3"|sort -k1n)
paste<(echo "$COL1")<(echo "$COL3") -d' '|column -t

#--------Check for any zombie processes--------#
echo -e "\n\n${Bold}${Blink}${F_Cyan}Checking For Zombie Processes${END}"
echo -e "$D"
ps -eo stat|grep -w Z 1>&2 > /dev/null
if [ $? == 0 ]; then
  echo -e "Number of zombie process on the system are :" $(ps -eo stat|grep -w Z|wc -l)
  echo -e "\n  Details of each zombie processes found   "
  echo -e "  $D"
  ZPROC=$(ps -eo stat,pid|grep -w Z|awk '{print $2}')
  for i in $(echo "$ZPROC"); do
      ps -o pid,ppid,user,stat,args -p $i
  done
else
 echo -e "No zombie processes found on the system."
fi

#--------Check Inode usage--------#
echo -e "\n\n${Bold}${Blink}${F_Cyan}Checking For INode Usage${END}"
echo -e "$D$D"
echo -e "( 0-85% = OK/HEALTHY,  85-95% = WARNING,  95-100% = CRITICAL )"
echo -e "$D$D"
echo -e "INode Utilization (Percentage Used):\n"

COL11=$(echo "$IUSAGE"|awk '{print $1" "$7}')
COL22=$(echo "$IUSAGE"|awk '{print $6}'|sed -e 's/%//g')

for i in $(echo "$COL22"); do
{
  if [[ $i = *[[:digit:]]* ]]; then
  {
  if [ $i -ge 95 ]; then
    COL33="$(echo -e $i"% $CCOLOR\n$COL33")"
  elif [[ $i -ge 85 && $i -lt 95 ]]; then
    COL33="$(echo -e $i"% $WCOLOR\n$COL33")"
  else
    COL33="$(echo -e $i"% $GCOLOR\n$COL33")"
  fi
  }
  else
    COL33="$(echo -e $i"% (Inode Percentage details not available)\n$COL33")"
  fi
}
done

COL33=$(echo "$COL33"|sort -k1n)
paste<(echo "$COL11")<(echo "$COL33") -d' '|column -t

#--------Check for MEMORY & SWAP Utilization--------#
echo -e "$D$D"
echo -e "${Bold}${Blink}${F_Cyan}Checking MEMORY Details${END}"
echo -e "Total Memory Memory in MiB : "$(grep -w MemTotal /proc/meminfo|awk '{print $2/1024}')", in GiB : "\
$(grep -w MemTotal /proc/meminfo|awk '{print $2/1024/1024}')
echo -e " Memory Free Memory in MiB : "$(grep -w MemFree /proc/meminfo|awk '{print $2/1024}')", in GiB : "\
$(grep -w MemFree /proc/meminfo|awk '{print $2/1024/1024}')

echo -e "\n\n${Bold}${Blink}${F_Cyan}Checking SWAP Details${END}"
echo -e "$D"
echo -e "Total Swap Memory in MiB : "$(grep -w SwapTotal /proc/meminfo|awk '{print $2/1024}')", in GiB : "\
$(grep -w SwapTotal /proc/meminfo|awk '{print $2/1024/1024}')
echo -e "Swap Free Memory in MiB : "$(grep -w SwapFree /proc/meminfo|awk '{print $2/1024}')", in GiB : "\
$(grep -w SwapFree /proc/meminfo|awk '{print $2/1024/1024}')

#--------Check for Processor Utilization (current data)--------#
echo -e "\n\n${Bold}${Blink}${F_Cyan}Checking For Processor Utilization${END}"
echo -e "$D"
echo -e "\nCurrent Processor Utilization Summary :\n"
mpstat|tail -2

#--------Check for load average (current data)--------#
echo -e "\n\n${Bold}${Blink}${F_Cyan}Checking For Load Average${END}"
echo -e "$D"
echo -e "Current Load Average : $(uptime|grep -o "load average.*"|awk '{print $3" " $4" " $5}')"

#------Print most recent 5 reboot events if available----#
echo -e "\n\n${Bold}${Blink}${F_Cyan}Most Recent 5 Reboot Events${END}"
echo -e "$D$D"
last -x 2> /dev/null|grep reboot 1> /dev/null && /usr/bin/last -x 2> /dev/null|grep reboot|head -5 || \
echo -e "No reboot events are recorded."

#------Print most recent 5 shutdown events if available-----#
echo -e "\n\n${Bold}${Blink}${F_Cyan}Most Recent 5 Shutdown Events${END}"
echo -e "$D$D"
last -x 2> /dev/null|grep shutdown 1> /dev/null && /usr/bin/last -x 2> /dev/null|grep shutdown|head -5 || \
echo -e "No shutdown events are recorded."

#--------Print top 5 Memory & CPU consumed process threads---------#
#--------excludes current running program which is hwlist----------#
echo -e "\n\n${Bold}${Blink}${F_Cyan}Top 5 Memory Resource Hog Processes${END}"
echo -e "$D$D"
ps -eo pmem,pid,ppid,user,stat,args --sort=-pmem|grep -v $$|head -6|sed 's/$//'

echo -e "\n${Bold}${Blink}${F_Cyan}Top 5 CPU Resource Hog Processes${END}"
echo -e "$D$D"
ps -eo pcpu,pid,ppid,user,stat,args --sort=-pcpu|grep -v $$|head -6|sed 's/$//'
echo -e "\n %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo -e "NOTE:- If any of the above fields are marked as \"blank\" or \"NONE\" or \"UNKNOWN\" or \"Not Available\" or \"Not Specified\"
that means either there is no value present in the system for these fields, otherwise that value may not be available,
or suppressed since there was an error in fetching details."
echo -e "\n %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"

