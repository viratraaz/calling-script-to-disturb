#!/bin/bash

yel=$'\e[1;33m'
cyn=$'\e[1;36m'
end=$'\e[0m'

read -p "${cyn}Enter your friend phone number :${yel} default : 198${end} : " phno
read -p "${cyn}Which is your default sim :${yel} default : 1 ${end}: " sim
read -p "${cyn}Enter total minutes to disturb : ${yel}default : 30 ${end} : " minut

phno=${phno:-198}
sim=${sim:-1}
minut=${minut:-30}

printf "\n">>$phno
echo "start time : "$(date +'%r')>>$phno
minut=$((60*minut))
start=$(date "+%s")
end=$(( minut + start ))

i=1

while [ 1=1 ]
do

current=$(date "+%s")

if [ $end -ge $current ];then
echo "number of times : " $i
adb shell am start -a android.intent.action.CALL -d tel:$phno
sleep $(( ( RANDOM % 10 )  + 10 ))

if [[ $(adb shell dumpsys telephony.registry|grep "mForegroundCallState"|cut -d "=" -f2|sed -n ${sim}p) -eq 1 ]];then
echo "Call Received">>$phno
break
fi

adb shell input keyevent  6

sleep $(( ( RANDOM % 3 )  + 2 ))

if [[ $(adb shell dumpsys telephony.registry|grep "mRingingCallState"|cut -d "=" -f2|sed -n 1p) -eq 5 ]] || [[ $(adb shell dumpsys telephony.registry|grep "mRingingCallState"|cut -d "=" -f2|sed -n 2p) -eq 5 ]];then
echo "phone is ringing">>$phno
break
fi

else
break
fi

((i=i+1))

done

echo "total calls : " $i>>$phno
echo "end time : "$(date +'%r')>>$phno
printf "\n">>$phno
