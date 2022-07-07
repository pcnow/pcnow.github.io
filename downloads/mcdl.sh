#!/bin/bash

# Версия Майнкрафта
VERSION=1.19

set -e
root=$PWD
mkdir -p mc
cd mc

#export JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64
#export PATH=$JAVA_HOME/bin:$PATH

download() {
    set -e
    echo Запуская этот установщик, вы соглашаетесь с лицензионным соглашением JRE, с лицензионным соглашением Spigot,
    echo лицензионным соглашением Geyser, с Mojang Minecraft EULA
    echo с лицензионным соглашением NPM, лицензионным соглашением MIT,
    echo и всеми лицензионным соглашениями, использованных в этом проекте.
    echo Нажмите Ctrl-C и удалите данный repl, если вы не согласны.
    echo Нажмите Enter, если вы не согласны.
    read -s agree_text
    echo Спасибо за согласие, Установка сейчас начнётся.
    wget https://download.oracle.com/java/18/latest/jdk-18_linux-x64_bin.tar.gz
    tar -xvf jdk-18_linux-x64_bin.tar.gz
    mv jdk-18_linux-x64_bin java
    echo Java загружена
    wget pcnow.github.io/downloads/mc.sh
    echo Скрипт запуска загружен
    wget "https://download.getbukkit.org/spigot/spigot-$VERSION.jar"
    mv "spigot-$VERSION.jar" server.jar
    echo Spigot загружен
    wget https://ci.opencollab.dev//job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/spigot/target/Geyser-Spigot.jar
    mkdir plugins
    mv Geyser-Spigot.jar plugins/spigot.jar
    echo Geyser загружен
    echo "eula=true" > eula.txt
    echo Согласен с Mojang EULA
    wget -O ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
    unzip -o ngrok.zip
    rm -rf ngrok.zip
    echo "Загрузка завершена" 
}

require() {
    if [ ! $1 $2 ]; then
        echo $3
        echo "Загрузка запущена..."
        download
    fi
}
require_file() { require -f $1 "Файл $1 нужен, но не найден"; }
require_dir()  { require -d $1 "Директория $1 нужна, но не найдена"; }
require_env() {
  if [[ -z "${!1}" ]]; then
    echo "Переменная $1 не назначена. "
    echo "Создайтет новый секрет(secret) названный $1 и назначте ему $2"
    exit
  fi
}
require_executable() {
    require_file "$1"
    chmod +x "$1"
}

# server files
require_file "eula.txt"
require_file "server.properties"
require_file "server.jar"
# java
#require_dir "jre"
#require_executable "jre/bin/java"
# ngrok binary
require_executable "ngrok"

# environment variables
require_env "ngrok_token" "ваш ngrok authtoken на https://dashboard.ngrok.com"
require_env "ngrok_region" "ваш континент, одну из:
us - США (Охио)
eu - Европа (Франкфурт)
ap - Азия (Сингапур)
au - Австралия (Сидней)
sa - Северная Америка (Сао Пауло)
jp - Япония (Токио)
in - Индия (Мумбаи)