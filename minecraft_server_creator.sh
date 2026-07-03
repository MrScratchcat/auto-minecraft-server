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
sudo apt install dialog jq curl wget -y

#choice for the server type
cmd=(dialog --menu "Please select the server type you want to install:" 22 76 16)
options=(
1 "Vanilla"
2 "Fabric"
3 "Forge"
4 "NeoForge"
)
choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
case $choice in
    1) type=vanilla ;;
    2) type=fabric ;;
    3) type=forge ;;
    4) type=neoforge ;;
    *) echo "No server type selected!"; exit 1 ;;
esac

#fetching all available versions from the official APIs so this script never needs updating
echo "Fetching all available ${type} versions...."
installer=false
case $type in
    vanilla)
        manifest=$(curl -s https://piston-meta.mojang.com/mc/game/version_manifest_v2.json)
        mapfile -t versions < <(echo "$manifest" | jq -r '.versions[] | select(.type=="release") | .id')
        ;;
    fabric)
        mapfile -t versions < <(curl -s https://meta.fabricmc.net/v2/versions/game | jq -r '.[] | select(.stable==true) | .version')
        ;;
    forge)
        promos=$(curl -s https://files.minecraftforge.net/net/minecraftforge/forge/promotions_slim.json)
        mapfile -t versions < <(echo "$promos" | jq -r '.promos | keys[]' | sed 's/-latest$//;s/-recommended$//' | sort -u -rV)
        ;;
    neoforge)
        neoversions=$(curl -s https://maven.neoforged.net/api/maven/versions/releases/net/neoforged/neoforge | jq -r '.versions[]')
        #neoforge versions look like 21.1.77 which means minecraft 1.21.1 (a .0 minor means for example 1.21)
        mapfile -t versions < <(echo "$neoversions" | awk -F. '{print $1"."$2}' | sort -u -rV | awk -F. '{if ($2 == 0) print "1."$1; else print "1."$1"."$2}')
        ;;
esac

if [ ${#versions[@]} -eq 0 ]; then
    echo "Could not fetch the ${type} version list! Please try again later."
    exit 1
fi

#choice for minecraft version (menu is built from the fetched list)
options=()
i=1
for v in "${versions[@]}"; do
    if [ $i -eq 1 ]; then
        options+=($i "$v (Latest!)")
    else
        options+=($i "$v")
    fi
    i=$((i+1))
done
cmd=(dialog --menu "Please select the ${type} version you want to install:" 22 76 16)
choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
if [ -z "$choice" ]; then
    echo "No version selected!"
    exit 1
fi
version=${versions[$((choice-1))]}

#finding the download url for the chosen version
case $type in
    vanilla)
        versionurl=$(echo "$manifest" | jq -r --arg v "$version" '.versions[] | select(.id==$v) | .url')
        server=$(curl -s "$versionurl" | jq -r '.downloads.server.url // empty')
        if [ -z "$server" ]; then
            echo "Mojang does not provide a server jar for ${version}!"
            exit 1
        fi
        ;;
    fabric)
        loaderversion=$(curl -s https://meta.fabricmc.net/v2/versions/loader | jq -r '[.[] | select(.stable==true)][0].version')
        installerversion=$(curl -s https://meta.fabricmc.net/v2/versions/installer | jq -r '[.[] | select(.stable==true)][0].version')
        server="https://meta.fabricmc.net/v2/versions/loader/${version}/${loaderversion}/${installerversion}/server/jar"
        ;;
    forge)
        installer=true
        #prefer the recommended forge build, fall back to the latest one
        forgeversion=$(echo "$promos" | jq -r --arg k "${version}-recommended" '.promos[$k] // empty')
        if [ -z "$forgeversion" ]; then
            forgeversion=$(echo "$promos" | jq -r --arg k "${version}-latest" '.promos[$k] // empty')
        fi
        if [ -z "$forgeversion" ]; then
            echo "Could not find a forge build for ${version}!"
            exit 1
        fi
        server="https://maven.minecraftforge.net/net/minecraftforge/forge/${version}-${forgeversion}/forge-${version}-${forgeversion}-installer.jar"
        ;;
    neoforge)
        installer=true
        #turn the minecraft version back into the neoforge version prefix (1.21.1 -> 21.1)
        minor=$(echo "$version" | cut -d. -f2)
        patch=$(echo "$version" | cut -d. -f3)
        if [ -z "$patch" ]; then
            patch=0
        fi
        #prefer stable builds, fall back to beta builds
        neoversion=$(echo "$neoversions" | grep "^${minor}\.${patch}\." | grep -v beta | sort -V | tail -1)
        if [ -z "$neoversion" ]; then
            neoversion=$(echo "$neoversions" | grep "^${minor}\.${patch}\." | sort -V | tail -1)
        fi
        if [ -z "$neoversion" ]; then
            echo "Could not find a neoforge build for ${version}!"
            exit 1
        fi
        server="https://maven.neoforged.net/releases/net/neoforged/neoforge/${neoversion}/neoforge-${neoversion}-installer.jar"
        ;;
esac

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
        difficulty=easy
        ;;
    2)
        #normal
        difficulty=normal
        ;;
    3)
        #hard
        difficulty=hard
        ;;
    4)
        #Peaceful
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
        distance=10
        ;;
    2)
        #16
        distance=16
        ;;
    3)
        #32
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
        hardcore=false
        gamemode=survival
        ;;
    2)
        #creative
        hardcore=false
        gamemode=creative
        ;;
    3)
        #hardcore
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

sudo apt install default-jdk wget screen openjdk-21-jdk -y
sudo rm -f forge*.jar neoforge*.jar installer.jar
if [ $installer == true ]
then
    wget -O installer.jar ${server}
else
    wget -O server.jar ${server}
fi
if [ $? -ne 0 ]; then
    echo "The download failed! Please try again later."
    exit 1
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

if [ $installer == true ]
then
    java -jar installer.jar --installServer
    rm -f installer.jar installer.jar.log
    echo "-Xmx${mem}G" > user_jvm_args.txt
    if [ -f run.sh ]
    then
        starter=$(cat run.sh | grep java)
    else
        #older forge versions dont have a run.sh and get started with the forge jar itself
        serverjar=$(ls forge-*.jar neoforge-*.jar 2>/dev/null | head -1)
        starter="java -Xmx${mem}G -Xms${mem}G -jar ${serverjar} nogui"
    fi
else
    starter="java -Xmx${mem}G -Xms${mem}G -jar server.jar nogui"
fi

echo "${starter}" > start.sh
sudo chmod +x start.sh

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
