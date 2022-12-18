
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
        sudo apt install openjdk-19-jdk -y
        sudo apt upgrade -y
        wget -O server.jar https://piston-data.mojang.com/v1/objects/c9df48efed58511cdd0213c56b9013a7b5c9ac1f/server.jar
        ;;
    2)
        #1.19.2
        continue=1
        sudo apt install openjdk-19-jdk -y
        sudo apt upgrade -y
        wget -O server.jar https://piston-data.mojang.com/v1/objects/f69c284232d7c7580bd89a5a4931c3581eae1378/server.jar
        ;;
    3)
        #1.18.2
        continue=1
        sudo apt install openjdk-19-jdk -y
        sudo apt upgrade -y
        wget -O server.jar https://launcher.mojang.com/v1/objects/c8f83c5655308435b3dcf03c06d9fe8740a77469/server.jar
        ;;
    4)
        #1.17.1
        continue=1
        sudo apt install openjdk-19-jdk -y
        sudo apt upgrade -y
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
        sudo apt install openjdk-19-jdk -y
        sudo apt upgrade -y
        wget -O server.jar https://meta.fabricmc.net/v2/versions/loader/1.19.3/0.14.11/0.11.1/server/jar
        ;;
    7)   
        #1.19.2 fabric
        continue=1
        sudo apt install openjdk-19-jdk -y
        sudo apt upgrade -y
        wget -O server.jar https://meta.fabricmc.net/v2/versions/loader/1.19.2/0.14.11/0.11.1/server/jar
        ;;
    8)
        #1.18.2 fabric
        continue=1
        sudo apt install openjdk-19-jdk -y
        sudo apt upgrade -y
        wget -O server.jar https://meta.fabricmc.net/v2/versions/loader/1.18.2/0.14.11/0.11.1/server/jar
        ;;
    9)
        #1.17.1 fabric
        continue=1
        sudo apt install openjdk-19-jdk -y
        sudo apt upgrade -y
        wget -O server.jar https://meta.fabricmc.net/v2/versions/loader/1.17.1/0.14.11/0.11.1/server/jar
        ;;
    10)
        #1.16.5 fabric
        continue=1
        sudo apt install openjdk-19-jdk -y
        sudo apt upgrade -y
        wget -O server.jar https://meta.fabricmc.net/v2/versions/loader/1.16.5/0.14.11/0.11.1/server/jar
        ;;
    esac
done
if [ $continue -eq 0 ]; then
    echo "you didnt made a choice, stop script" 
    exit 1
else
    sudo chmod +x minecraft_server_downloader.sh
    echo java -Xmx6000M -Xms6000M -jar server.jar nogui pause>> start.bat
    echo eula=true > eula.txt
    sudo chmod +x start.bat
    sudo ./start.bat
fi
