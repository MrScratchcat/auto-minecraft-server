#!/bin/bash
sudo apt update 
sudo apt install wget dialog -y
continue=0
cmd=(dialog --menu "Please Select the version you want to install:" 22 76 16)
options=(
1 "version 1.19.3"
2 "Version 1.19.2"
3 "Version 1.18.2"
4 "Version 1.17.1"
5 "Version 1.16.5"
6 "version 1.19.3 fabric"
7 "Version 1.19.2 fabric"
8 "Version 1.18.2 fabric"
9 "Version 1.17.1 fabric"
10 "Version 1.16.5 fabric"
)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
    1)
        #1.19.3
        continue=1
        wget -O server.jar https://piston-data.mojang.com/v1/objects/c9df48efed58511cdd0213c56b9013a7b5c9ac1f/server.jar
        ;;
    2)
        #1.19.2
        continue=1
        wget -O server.jar https://piston-data.mojang.com/v1/objects/f69c284232d7c7580bd89a5a4931c3581eae1378/server.jar
        ;;
    3)
        #1.18.2
        continue=1
        wget -O server.jar https://launcher.mojang.com/v1/objects/c8f83c5655308435b3dcf03c06d9fe8740a77469/server.jar
        ;;
    4)
        #1.17.1
        continue=1
        wget -O server.jar https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar
        ;;
    5)
        #1.16.5
        continue=1
        sudo apt install openjdk-19-jdk -y
        sudo apt upgrade -y
        wget -O server.jar https://launcher.mojang.com/v1/objects/1b557e7b033b583cd9f66746b7a9ab1ec1673ced/server.jar
        ;;
        
    6)
        #1.19.3 fabric
        continue=1
        wget -O server.jar https://meta.fabricmc.net/v2/versions/loader/1.19.3/0.14.11/0.11.1/server/jar
        ;;
    7)   
        #1.19.2 fabric
        continue=1
        wget -O server.jar https://meta.fabricmc.net/v2/versions/loader/1.19.2/0.14.11/0.11.1/server/jar
        ;;
    8)
        #1.18.2 fabric
        continue=1
        wget -O server.jar https://meta.fabricmc.net/v2/versions/loader/1.18.2/0.14.11/0.11.1/server/jar
        ;;
    9)
        #1.17.1 fabric
        continue=1
        wget -O server.jar https://meta.fabricmc.net/v2/versions/loader/1.17.1/0.14.11/0.11.1/server/jar
        ;;
    10)
        #1.16.5 fabric
        continue=1
        wget -O server.jar https://meta.fabricmc.net/v2/versions/loader/1.16.5/0.14.11/0.11.1/server/jar
        ;;
    esac
done
cmd=(dialog --menu "Please Select your difficulty:" 22 76 16)
options=(
1 "Easy"
2 "Normal"
3 "Hard"
)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
    1)
        #easy
        continue=1
        difficulty=easy
        ;;
    2)
        #normal
        continue=1
        difficulty=normal
        ;;
    3)
        #hard
        continue=1
        difficulty=hard
        ;;

    esac
done
cmd=(dialog --menu "Please Select your render distance:" 22 76 16)
options=(
1 "10"
2 "16"
3 "32"
)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
    1)
        #10
        continue=1
        distance=10
        ;;
    2)
        #16
        continue=1
        distance=16
        ;;
    3)
        #32
        continue=1
        distance=32
        ;;

    esac
done
cmd=(dialog --menu "Please Select your gamemode:" 22 76 16)
options=(
1 "Survival"
2 "Creative"
3 "Hardcore"
)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
    1)
        #survival
        continue=1
        hardcore=false
        gamemode=survival
        ;;
    2)
        #creative
        continue=1
        hardcore=false
        gamemode=creative
        ;;
    3)
        #hardcore
        continue=1
        hardcore=true
        gamemode=hardcore
        difficulty=hard
        ;;

    esac
done
if [ $continue -eq 0 ]; then
    echo "you didnt made a choice, stop script" 
    exit 1
else
    echo "#Minecraft server properties
allow-flight=true
allow-nether=true
broadcast-console-to-ops=true
broadcast-rcon-to-ops=true
difficulty=${difficulty}
enable-command-block=false
enable-jmx-monitoring=false
enable-query=false
enable-rcon=false
enable-status=true
enforce-secure-profile=true
enforce-whitelist=false
entity-broadcast-range-percentage=100
force-gamemode=false
function-permission-level=2
gamemode=${gamemode}
generate-structures=true
generator-settings={}
hardcore=${hardcore}
hide-online-players=false
initial-disabled-packs=
initial-enabled-packs=vanilla
level-name=world
level-seed=
level-type=minecraft\:normal
max-chained-neighbor-updates=1000000
max-players=20
max-tick-time=60000
max-world-size=29999984
motd=A Minecraft Server
network-compression-threshold=256
online-mode=true
op-permission-level=4
player-idle-timeout=0
prevent-proxy-connections=false
pvp=true
query.port=25565
rate-limit=0
rcon.password=
rcon.port=25575
require-resource-pack=false
resource-pack=
resource-pack-prompt=
resource-pack-sha1=
server-ip=
server-port=25565
simulation-distance=${distance}
spawn-animals=true
spawn-monsters=true
spawn-npcs=true
spawn-protection=16
sync-chunk-writes=true
text-filtering-config=
use-native-transport=true
view-distance=${distance}
white-list=false" > server.properties
    
    sudo apt install openjdk-19-jdk -y
    sudo apt upgrade -y

    mem=$(free -h | grep -i mem | awk '{print int($2 + 0.5)}')
    echo " "
    echo "Allocating ${mem}GB of RAM for Minecraft server."
    echo " "
    echo "java -Xmx${mem}G -Xms1G -jar server.jar nogui" > start.bat

    echo eula=true > eula.txt
    sudo chmod +x start.bat
    sudo ./start.bat
    sudo chown -R $USER: $HOME
fi
