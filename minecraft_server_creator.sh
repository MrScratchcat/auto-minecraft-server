#!/bin/bash
mem=$(free -h | grep -i mem | awk '{print int($2 + 0.5)}')

#variable for the location you are in
location=$(pwd | grep .)

#internet check
echo "Checking for internet connection...."
wget -q --spider https://github.com/MrScratchcat/auto-minecraft-server
if [ $? -eq 0 ]; then
    echo "connected!"
else
    echo "You have no internet connection!"
    exit
fi

sudo apt update 
sudo apt install dialog -y

#choice for minecraft version
continue=0
cmd=(dialog --menu "Please Select the version you want to install:" 22 76 16)
options=(
0 "version 1.20.1 (Latest!)"
1 "version 1.19.4"
2 "version 1.19.3"
3 "Version 1.19.2"
4 "Version 1.18.2"
5 "Version 1.17.1"
6 "Version 1.16.5"
7 "version 1.20.1 fabric (Latest!)"
8 "version 1.19.4 fabric"
9 "version 1.19.3 fabric"
10 "Version 1.19.2 fabric"
11 "Version 1.18.2 fabric"
12 "Version 1.17.1 fabric"
13 "Version 1.16.5 fabric"
14 "version 1.20.1 forge (Latest!)"
15 "version 1.19.4 forge"
16 "version 1.19.3 forge"
17 "version 1.19.2 forge"
18 "version 1.18.2 forge"
19 "version 1.17.1 forge"
20 "version 1.16.5 forge"
)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
    0)
        #1.20.1
        continue=1
        server=https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar
        forge=false
        ;;
    1)
        #1.19.4
        continue=1
        server=https://piston-data.mojang.com/v1/objects/8f3112a1049751cc472ec13e397eade5336ca7ae/server.jar
        forge=false
        ;;
    2)
        #1.19.3
        continue=1
        server=https://piston-data.mojang.com/v1/objects/c9df48efed58511cdd0213c56b9013a7b5c9ac1f/server.jar
        forge=false
        ;;
    3)
        #1.19.2
        continue=1
        server=https://piston-data.mojang.com/v1/objects/f69c284232d7c7580bd89a5a4931c3581eae1378/server.jar
        forge=false
        ;;
    4)
        #1.18.2
        continue=1
        server=https://launcher.mojang.com/v1/objects/c8f83c5655308435b3dcf03c06d9fe8740a77469/server.jar
        forge=false
        ;;
    5)
        #1.17.1
        continue=1
        server=https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar
        forge=false
        ;;
    6)
        #1.16.5
        continue=1
        server=https://launcher.mojang.com/v1/objects/1b557e7b033b583cd9f66746b7a9ab1ec1673ced/server.jar
        forge=false
        ;;
    7)
        #1.20.1 fabric
        continue=1
        server=https://meta.fabricmc.net/v2/versions/loader/1.20.1/0.14.21/0.11.2/server/jar
        forge=false
        ;;  
    8)
        #1.19.4 fabric
        continue=1
        server=https://meta.fabricmc.net/v2/versions/loader/1.19.4/0.14.19/0.11.2/server/jar
        forge=false
        ;;  
    9)
        #1.19.3 fabric
        continue=1
        server=https://meta.fabricmc.net/v2/versions/loader/1.19.3/0.14.19/0.11.2/server/jar
        forge=false
        ;;
    10)   
        #1.19.2 fabric
        continue=1
        server=https://meta.fabricmc.net/v2/versions/loader/1.19.2/0.14.19/0.11.2/server/jar
        forge=false
        ;;
    11)
        #1.18.2 fabric
        continue=1
        server=https://meta.fabricmc.net/v2/versions/loader/1.18.2/0.14.19/0.11.2/server/jar
        forge=false
        ;;
    12)
        #1.17.1 fabric
        continue=1
        server=https://meta.fabricmc.net/v2/versions/loader/1.17.1/0.14.19/0.11.2/server/jar
        forge=false
        ;;
    13)
        #1.16.5 fabric
        continue=1
        server=https://meta.fabricmc.net/v2/versions/loader/1.16.5/0.14.19/0.11.2/server/jar
        forge=false
        ;;
    14)
        #1.20.1 forge
        continue=1
        forge=true
        server=https://maven.minecraftforge.net/net/minecraftforge/forge/1.20.1-47.0.0/forge-1.20.1-47.0.0-installer.jar
        ;;
    15)
        #1.19.4 forge
        continue=1
        forge=true
        server=https://maven.minecraftforge.net/net/minecraftforge/forge/1.19.4-45.0.66/forge-1.19.4-45.0.66-installer.jar
        ;;
    16)
        #1.19.3 forge
        continue=1
        forge=true
        server=https://maven.minecraftforge.net/net/minecraftforge/forge/1.19.3-44.1.23/forge-1.19.3-44.1.23-installer.jar
        ;;
    17)
        #1.19.2 forge
        continue=1
        forge=true
        server=https://maven.minecraftforge.net/net/minecraftforge/forge/1.19.2-43.2.12/forge-1.19.2-43.2.12-installer.jar
        ;;
    18)
        #1.18.2 forge
        continue=1
        forge=true
        server=https://maven.minecraftforge.net/net/minecraftforge/forge/1.18.2-40.2.8/forge-1.18.2-40.2.8-installer.jar
        ;;
    19)
        #1.17.1 forge
        continue=1
        forge=true
        server=https://maven.minecraftforge.net/net/minecraftforge/forge/1.17.1-37.1.1/forge-1.17.1-37.1.1-installer.jar
        ;;
    20)
        #1.16.5 forge
        continue=1
        forge=true
        server=https://maven.minecraftforge.net/net/minecraftforge/forge/1.16.5-36.2.39/forge-1.16.5-36.2.39-installer.jar
        ;;

        esac
done

#difficulty selecton
cmd=(dialog --menu "Please Select your difficulty:" 22 76 16)
options=(
1 "Easy"
2 "Normal"
3 "Hard"
4 "Peaceful"
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
    4)
        #Peaceful
        continue=1
        difficulty=peaceful
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
clear

#choice for server name
dialog --inputbox "Put in the name of your server:" 8 60 2>name.txt
name=$(cat name.txt)
rm name.txt
if [ -z "$name" ]; then
   name="a very cool minecraft server"
fi
clear

#choice for seed
dialog --inputbox "seed empty for random:" 8 60 2>seed.txt
seed=$(cat seed.txt)
rm seed.txt
clear

#deleting the old startup program
if [ $startup == 0 ]
then
    cd
    systemctl stop minecraft.service
    sudo rm /etc/systemd/system/minecraft.service
    sudo rm /usr/local/bin/autostart.sh
    cd ${location}
fi

sudo ufw allow ${port}
 
sudo apt install default-jdk wget screen openjdk-19-jdk -y
sudo rm forge*.jar
if [ $forge == true ]
then 
    wget ${server}
elif [ $forge == false ]
then 
    wget -O server.jar ${server}
fi

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
level-type=minecraft:normal
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

echo " "
echo "Allocating ${mem}GB of RAM for Minecraft server."
echo " "
echo eula=true > eula.txt

echo "${starter}" > start.sh
sudo chmod +x start.sh


if [ $forge == true ]
then 
    echo "-Xmx${mem}G" > user_jvm_args.txt
    java -jar forge*.jar --installServer
    starter=$(cat run.sh | grep java)
elif [ $forge == false ]
then 
    starter="java -Xmx${mem}G -Xms${mem}G -jar server.jar nogui"
fi

if [ $startup == 0 ]
then

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
    $starter" > autostart.sh
    sudo chmod +x autostart.sh
    sudo cp autostart.sh /usr/local/bin

elif [ $startup == 1 ]
then 
    echo "Your minecraft server wont start at startup!"
fi

if [ $start == 0 ]
then
    ${starter}
elif [ $start == 1 ]
then 
    echo "please wait this wont take longer than 20 seconds"
fi
        
sudo chown -R $USER: $HOME
clear
echo "All done to start your server type: bash start.sh"

if [ $startup == 0 ]
then 
    sudo systemctl enable minecraft.service
    sudo systemctl daemon-reload
    sudo rm autostart.sh
    echo "To stop the server type "systemctl stop minecraft" or to see if the server is running type "systemctl status minecraft" "
    echo "systemctl stop minecraft.service && ${starter}" > start.sh
    sudo chmod +x start.sh
elif [ $startup == 1 ]
then
  sudo chmod +x start.sh
fi
