sudo apt update 
sudo apt upgrade -y
sudo apt install openjdk-18-jdk wget dialog -y
continue=0
cmd=(dialog --menu "Please Select the version you want to install:" 22 76 16)
options=(
1 "Version 1.19.2"
2 "Version 1.18.2"
3 "Version 1.17.1"
4 "Version 1.16.5"
)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
    1)
        #1.19.2
        continue=1
        wget -O server.jar https://meta.fabricmc.net/v2/versions/loader/1.19.2/0.14.10/0.11.1/server/jar
        ;;
    2)
        #1.18.2
        continue=1
        wget -O server.jar https://meta.fabricmc.net/v2/versions/loader/1.18.2/0.14.10/0.11.1/server/jar
        ;;
    3)
        #1.17.1
        continue=1
        wget -O server.jar https://meta.fabricmc.net/v2/versions/loader/1.17.1/0.14.10/0.11.1/server/jar
        ;;
    4)
        #1.16.5
        continue=1
        wget -O server.jar https://meta.fabricmc.net/v2/versions/loader/1.16.5/0.14.10/0.11.1/server/jar
        ;;
    esac
done
if [ $continue -eq 0 ]; then
    echo "Geen keuze gemaakt, stop script" 
    exit 1
else
    sudo chmod +x minecraft_server_downloader.sh
    echo java -Xmx6000M -Xms6000M -jar server.jar nogui pause>> start.bat
    echo eula=true > eula.txt
    sudo chmod +x start.bat
    sudo ./start.bat
fi