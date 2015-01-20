#!/usr/bin/env bash

echo  -e -n "-------------------------------\n"
for i in {30..37}
do  
    for j in $(seq 00 07);
    do echo -e -n "\e[${j};${i}m ${j} ${i}\e[0m";
    done;
    echo -n  -e "\n";
done
echo  -e -n "-------------------------------\n"



echo  -e -n "-------------------------------\n"
for i in $(seq 00 07); 
do  
    for j in $(seq 30 37);
    do echo -e -n "\e[${i};${j}m ${i} ${j}\e[0m";
    done;
    echo -n  -e "\n";
done
echo  -e -n "-------------------------------\n"

echo  -e -n "-------------------------------\n"
for i in $(seq 00 07); 
do  
    for j in $(seq 30 37);
    do 
        for k in {40..47};
        do
            echo -e -n "\e[${i};${j};${k}m ${i}${j}${k} \e[0m";
        done;
        echo -n -e "\n";
    done;
echo  -e -n "-------------------------------\n"
done
echo  -e -n "-------------------------------\n"
