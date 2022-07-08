#!/bin/bash

echo 
echo Загрузщик Майнкрафт сервера v1.0
echo          PCNow!, 2022
echo 
echo Если вы хотите запустить сервер,
echo нажмите 1.
echo Если вы хотите установить Майнкрафт сервер,
echo нажмите 2.

while true
do

read -n1 Keypress

case "$Keypress" in

$'1')
echo Майнкрафт сервер загружается, ждите
exit
;;

$'2')
echo Начинается установка
;;

esac

done