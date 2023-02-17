#!/usr/bin/zsh

ans=$(echo -e "no\nreboot\nsuspend" | dmenu -c -h 40 -l 3 -p "Do you want reboot or suspend?")

if [[ ($ans == "suspend") ]]
then
    systemctl suspend
elif [[ ($ans == "reboot") ]]
then
    systemctl reboot
fi
