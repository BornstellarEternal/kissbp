#!/bin/bash

echo -e "\nPick a foreground color, any foreground color ;)\n"
for fg in {1..256}; do
    echo -en "\e[38;5;${fg}m${fg} \e[0m"
done

echo -e "\n\nPick a background color, any background color ;)"
echo -e "  (tip) if on ubuntu terminal use 256 if no background is desired\n"
for bg in {1..256}; do
    echo -en "\e[48;5;${bg};38;5;255m${bg} \e[0m"
done
echo
