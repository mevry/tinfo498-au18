#!/bin/bash
passwords=( 'farout' '123' 'Bach' 'Dragon' 'Secretshazam' 'pirateplato' 'i!h@d@M$!wbr')
index=1
for password in ${passwords[@]}; do
    user=User$index
    useradd $user
    echo $password | passwd $user --stdin
    ((index++))
done