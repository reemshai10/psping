#!/bin/bash


#this program will count of instance by process 
# -c - limit amount of pings, e.g. -c 3. Default is infinite
#-t - define alternative timeout in seconds, e.g. -t 5. Default is 1 sec
#-u - define user to check process for. Default is ANY user.


#global variable
count=-1
time=1
user=""

# check if the number of arguments is 1 for case we only input process 
SIZE_ARG=$#
if [ "$SIZE_ARG" -eq "1" ]
 then
    process="$1"
fi    


# loop for getting the argument from the command 
while getopts ":c:t:u:" option; do
   case $option in
      c)
	 count=$OPTARG;;
      t) 
	 time=$OPTARG;;
      u)
	 user=$OPTARG
      ;;
    :) err "Option -$OPTARG requires an argument." || exit 1 ;;
    \?) err "Invalid option: -$OPTARG" || exit 1 ;;
   esac
  
done


if [ -z "$user" ]  # check if user empty 
 then
    if [ -z "$time" ] # check if time empty  if is the case we print for "any user" and do the process for any user
     then
        echo "Pinging ‘"$process"‘ for  any  ‘"user"‘"  
        while [[ $count -ne 0 ]]
        do
            cmd=`ps -ef | grep -v "psping" |  grep "$user" | grep $process |  awk -F " " '{ print $1 " " $8}' | grep -v grep | wc -l`
            echo "$process: "$cmd" instance(s)..."
            count=$(( $count - 1 ))
            sleep $time
        done
    else # if time not empty we shifting and get the process argument and do the process for "any user same like up but we shift "
        shift $((OPTIND-1))
        process=$@
       echo "Pinging ‘"$process"‘ for  any  ‘"user"‘" 
       while [[ $count -ne 0 ]]
        do
            cmd=`ps -ef | grep -v "psping" |  grep "$user" | grep $process |  awk -F " " '{ print $1 " " $8}' | grep -v grep | wc -l`
            echo "$process: "$cmd" instance(s)..."
            count=$(( $count - 1 ))
            sleep $time
      done
    fi   
 else # this case if the user not empty so we know we have the user argument and we process with the specific user.
    shift $((OPTIND-1))
    process=$@
    echo "Pinging ‘"$process"‘ for  any  ‘"$user"‘"

    while [[ $count -ne 0 ]]
     do
        cmd=`ps -ef | grep -v "psping" |  grep "$user" | grep $process |  awk -F " " '{ print $1 " " $8}' | grep -v grep | wc -l`
        echo "$process: "$cmd" instance(s)..."
        count=$(( $count - 1 ))
        sleep $time
    done
 fi   





