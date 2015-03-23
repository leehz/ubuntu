#!/usr/bin/env bash

while true 
    
do  clear
    for i in $(echo "/ | \ -" ) ; do
    printf "\e[35;41m\r%s\e[0m" $i
    sleep 0.5 
done 
done

