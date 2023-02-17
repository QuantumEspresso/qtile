#!/usr/bin/zsh

res=`amixer -D pulse sget Master | grep 'Left:' | awk -F'[][]' '{ print $4 }'`

if [[ $res == "off" ]]; then
	echo -n "Mute"
else
	amixer -D pulse sget Master | grep 'Left:' | awk -F'[][]' '{ print $2 }'
fi
