#!/bin/bash
##---------- Purpose : To quickly check and report health status in a linux system.----------##
##---------- Tested on : RHEL8/7/6/, SLES/SLED 15/12/11, Ubuntu20/18/16, CentOS , -----------##
##---------- Updated version : v3.1 (Updated on 16th Oct 2021) ------------------------------##
##-----------NOTE: This script requires root privilege --------------------------------------##
##----------- "sudo /bin/bash server-healthcheck.sh"-----------------------------------------##
##-------------------------------------------------------------------------------------------##


#--------- variables used in scrip ------#




#----------------Scripts execution-----------------#
/bin/bash shut_events.sh
/bin/bash reboot_events.sh
/bin/bash load_average.sh
/bin/bash process_utilization.sh
/bin/bash zombie_process.sh
/bin/bash system_user_logons.sh
/bin/bash mem_cpu_consum_proc.sh
/bin/bash mem_utilization.sh

