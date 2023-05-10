#!/bin/bash
mem=$(free -h | grep -i mem | awk '{print int($2 + 0.5)}')

#internet check
echo "checking for internet connection"
echo ""
wget -q --spider https://github.com/MrScratchcat/auto-minecraft-server
if [ $? -eq 0 ]; then
    echo "Your Online"
else
    echo "You are Offline please connet to the internet and try again!"
    exit
fi

#variable for the location you are in
location=$(pwd | grep .)

sudo apt update 
sudo apt install dialog -y

#choice for minecraft version
continue=0
cmd=(dialog --menu "Please Select the version you want to install:" 22 76 16)
options=(
0 "version 1.19.4"
1 "version 1.19.3"
2 "Version 1.19.2"
3 "Version 1.18.2"
4 "Version 1.17.1"
5 "Version 1.16.5"
6 "version 1.19.4 fabric"
7 "version 1.19.3 fabric"
8 "Version 1.19.2 fabric"
9 "Version 1.18.2 fabric"
10 "Version 1.17.1 fabric"
11 "Version 1.16.5 fabric"
)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
    0)
        #1.19.4
        continue=1
        server=https://piston-data.mojang.com/v1/objects/8f3112a1049751cc472ec13e397eade5336ca7ae/server.jar
        ;;
    1)
        #1.19.3
        continue=1
        server=https://piston-data.mojang.com/v1/objects/c9df48efed58511cdd0213c56b9013a7b5c9ac1f/server.jar
        ;;
    2)
        #1.19.2
        continue=1
        server=https://piston-data.mojang.com/v1/objects/f69c284232d7c7580bd89a5a4931c3581eae1378/server.jar
        ;;
    3)
        #1.18.2
        continue=1
        server=https://launcher.mojang.com/v1/objects/c8f83c5655308435b3dcf03c06d9fe8740a77469/server.jar
        ;;
    4)
        #1.17.1
        continue=1
        server=https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar
        ;;
    5)
        #1.16.5
        continue=1
        server=https://launcher.mojang.com/v1/objects/1b557e7b033b583cd9f66746b7a9ab1ec1673ced/server.jar
        ;;

    6)
        #1.19.4 fabric
        continue=1
        server=https://meta.fabricmc.net/v2/versions/loader/1.19.4/0.14.19/0.11.2/server/jar
        ;;  
    7)
        #1.19.3 fabric
        continue=1
        server=https://meta.fabricmc.net/v2/versions/loader/1.19.3/0.14.19/0.11.2/server/jar
        ;;
    8)   
        #1.19.2 fabric
        continue=1
        server=https://meta.fabricmc.net/v2/versions/loader/1.19.2/0.14.19/0.11.2/server/jar
        ;;
    9)
        #1.18.2 fabric
        continue=1
        server=https://meta.fabricmc.net/v2/versions/loader/1.18.2/0.14.19/0.11.2/server/jar
        ;;
    10)
        #1.17.1 fabric
        continue=1
        server=https://meta.fabricmc.net/v2/versions/loader/1.17.1/0.14.19/0.11.2/server/jar
        ;;
    11)
        #1.16.5 fabric
        continue=1
        server=https://meta.fabricmc.net/v2/versions/loader/1.16.5/0.14.19/0.11.2/server/jar
        ;;
        esac
done

#difficulty selecton
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

#render distance selection
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

#gamemode selection
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

#startup selection
dialog --yesno "Do you want your minecraft server to start at startup?" 7 40
startup=$?
clear
if [ $startup == 0 ]
then
    cd
    systemctl stop minecraft.service
    sudo rm /etc/systemd/system/minecraft.service
    sudo rm /usr/local/bin/autostart.sh
    cd ${location}
    
	sudo echo "[Unit]
	After=network.target

	[Service]
	Type=simple
	ExecStart=/usr/local/bin/autostart.sh

	[Install]
	WantedBy=default.target
	" > minecraft.service

	sudo cp minecraft.service /etc/systemd/system
	sudo rm minecraft.service
	sudo chmod +x /etc/systemd/system/minecraft.service

    sudo echo "#!/bin/bash
    cd ${location}
    java -Xmx${mem}G -Xms${mem}G -jar server.jar nogui" > autostart.sh
    sudo chmod +x autostart.sh
    sudo cp autostart.sh /usr/local/bin

elif [ $startup == 1 ]
then 
    echo "Your minecraft server wont start at startup!"
fi
#choice for start if script is done 
dialog --yesno "Do you want to start as soon the script is done?" 7 40
start=$?
clear

#choice for the server port
dialog --inputbox "put in port number empty for default:" 8 60 2>port.txt
port=$(cat port.txt)
rm port.txt
if [ -z "$port" ]; then
    port=25565
fi
echo $port
clear

#choice for server name
dialog --inputbox "Put in the name of your server:" 8 60 2>name.txt
name=$(cat name.txt)
rm name.txt
if [ -z "$name" ]; then
name="a very cool minecraft server"
fi
clear
echo "$name"

#choice for seed
dialog --inputbox "seed empty for random:" 8 60 2>seed.txt
seed=$(cat seed.txt)
rm seed.txt
clear
echo "$seed"


sudo apt install wget -y
wget -O server.jar ${server}
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
    level-seed=${seed}
    level-type=minecraft\:normal
    max-chained-neighbor-updates=1000000
    max-players=20
    max-tick-time=60000
    max-world-size=29999984
    motd=${name}
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
    server-port=${port}
    simulation-distance=${distance}
    spawn-animals=true
    spawn-monsters=true
    spawn-npcs=true
    spawn-protection=0
    sync-chunk-writes=true
    text-filtering-config=
    use-native-transport=true
    view-distance=${distance}
    white-list=false" > server.properties

    sudo apt install openjdk-19-jdk -y
    sudo apt upgrade -y
    echo " "
    echo "Allocating ${mem}GB of RAM for Minecraft server."
    echo " "
    echo "systemctl stop minecraft.service && java -Xmx${mem}G -Xms${mem}G -jar server.jar nogui" > start.sh
    echo eula=true > eula.txt
    sudo chmod +x start.sh

    if [ $start == 0 ]
    then
        java -Xmx${mem}G -Xms${mem}G -jar server.jar nogui
        
    elif [ $start == 1 ]
    then 
        echo "didnt start"
    fi
        
    sudo chown -R $USER: $HOME
    clear
    echo "all done to start your server type: bash start.sh"
    if [ $startup == 0 ]
    then 
        sudo systemctl enable minecraft.service
        sudo systemctl daemon-reload
        sudo systemctl start minecraft.service
        sudo rm autostart.sh
        echo "to stop the server type "systemctl stop minecraft" or to see the server log type "systemctl status minecraft" "
    fi
fi
