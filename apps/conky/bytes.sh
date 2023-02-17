#!/bin/zsh

bytes_type=("B" "kB" "MB" "GB" "TB" "PB")
num=$1
count=1
rest=0
while [ $(($num / 1024)) -ne 0 ]
do
	tmp=$(($num / 1024))
	count=$((count+1))
	rest=$(($num - $tmp * 1024))
	num=$tmp
done

if [ $((rest * 100 / 1024)) -lt 10 ]
then
	echo $num.0$(($rest * 100 / 1024)) ${bytes_type[$count]}
else
	echo $num.$(($rest * 100 / 1024)) ${bytes_type[$count]}
fi

