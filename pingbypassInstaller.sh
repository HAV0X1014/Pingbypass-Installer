#set some variables
internalip=$( ip -o route get to 10.0.0.0 | sed -n 's/.*src \([0-9.]\+\).*/\1/p' ) #WHAT THE FUCK
externalip=$(curl -4 -s ifconfig.me)
javadir=~/jdk1.8.0_321/bin
hmcdir=~/HeadlessMC
modsdir=~/.minecraft/mods
mcdir=~/.minecraft/versions/1.12.2
launch=~launchpb

#make sure this is being run in the home dir and not anywhere else
if [ $PWD != ~ ]; then
	echo $'**This script \033[0;31mMUST\033[0m be run in the home directory!**\n**This script will NOT work elsewhere!**'
	exit 0
fi

#check for wget, and require the user to install it
if ! command -v wget &> /dev/null
then
	echo $"wget is not installed. Install it with 'sudo apt install wget' if you are on a Debian or Ubuntu based system. If you are on an RPM (red hat) based system, use 'yum install wget -y'. For Arch based systems, use 'pacman -Syu wget'."
	exit 0
fi

#check for curl, and pester the user if they dont have it
if ! command -v curl &> /dev/null
then
	echo $'\ncurl is not installed. Install it with "sudo apt install curl" if you are on a Debian or Ubuntu based system. If you are on anything I dont really care. 

You dont have to have it installed, but I am going to hold you for 10 seconds so you will get annoyed.\n'
	sleep 10
fi

#print the credits first, every installer ALWAYS has a stupid splash screen
echo $'The proper pingbypass installer'
echo $'brought to you by HAV0X of'
echo $'\033[33m                                                                            
 ▄▄           ▐      ▗              ▗▄▄  ▝          ▐                       
▐▘ ▘ ▄▖ ▗▗▖  ▄▟  ▄▖ ▗▟▄  ▄▖  ▖▄     ▐ ▝▌▗▄  ▗▗▖  ▄▄ ▐▄▖ ▗ ▗ ▗▄▖  ▄▖  ▄▖  ▄▖ 
▝▙▄ ▝ ▐ ▐▘▐ ▐▘▜ ▐ ▝  ▐  ▝ ▐  ▛ ▘    ▐▄▟▘ ▐  ▐▘▐ ▐▘▜ ▐▘▜ ▝▖▞ ▐▘▜ ▝ ▐ ▐ ▝ ▐ ▝ 
  ▝▌▗▀▜ ▐ ▐ ▐ ▐  ▀▚  ▐  ▗▀▜  ▌      ▐    ▐  ▐ ▐ ▐ ▐ ▐ ▐  ▙▌ ▐ ▐ ▗▀▜  ▀▚  ▀▚ 
▝▄▟▘▝▄▜ ▐ ▐ ▝▙█ ▝▄▞  ▝▄ ▝▄▜  ▌      ▐   ▗▟▄ ▐ ▐ ▝▙▜ ▐▙▛  ▜  ▐▙▛ ▝▄▜ ▝▄▞ ▝▄▞ 
                                                 ▖▐      ▞  ▐               
                                                 ▝▘     ▝▘  ▝               
\033[0;31m'
echo $'Sandstar Pingbypass can be found at \033[33mhttp://discord.gg/5HVsNJrVWM\033[39m\n'
sleep 2
echo $'This script will NOT do any network setup for you, nor log in to HeadlessMC.'
echo $'If any directories already exist, they will not be created/written into.\n'
sleep 1

#ask for user input for ip, port, password, and OS type
read -p $'What port would you like to use for Pingbypass? \n' openport
read -p $'What password would you like the Pingbypass server to use? \n' pass
read -p $'What is the latest RELEASE version of 3arthh4ck on Github?.\n(The version under the releases tab, formatted like 1.8.4)' ver

#install java if it hasnt been installed before
if [ ! -d "$javadir" ]; then
	wget https://javadl.oracle.com/webapps/download/GetFile/1.8.0_321-b07/df5ad55fdd604472a86a45a217032c7d/linux-i586/jdk-8u321-linux-x64.tar.gz
	tar -xf jdk-8u321-linux-x64.tar.gz
fi

#make config files, directories and input relevant configs if they dont exist
if [ ! -d "$hmcdir" ]; then
	mkdir ~/HeadlessMC -p && touch ~/HeadlessMC/config.properties && cat >> ~/HeadlessMC/config.properties<<EOL 
hmc.java.versions=$javadir/java
hmc.invert.jndi.flag=true
hmc.invert.lookup.flag=true
hmc.invert.lwjgl.flag=true
hmc.invert.pauls.flag=true
hmc.jvmargs=-Xmx1700M -Dheadlessforge.no.console=true
EOL

	mkdir ~/.minecraft/earthhack -p && touch ~/.minecraft/earthhack/pingbypass.properties && cat >> ~/.minecraft/earthhack/pingbypass.properties<<EOL
pb.server=true
pb.ip=$internalip
pb.port=$openport
pb.password=$pass
EOL
fi

#download mods and hmc and move them to the proper places if not already downloaded
if [ ! -d "$modsdir" ]; then
	mkdir ~/.minecraft/mods -p
	wget https://github.com/3arthqu4ke/3arthh4ck/releases/download/$ver/3arthh4ck-$ver-release.jar && mv 3arthh4ck-$ver-release.jar ~/.minecraft/mods
	wget https://github.com/3arthqu4ke/HMC-Specifics/releases/download/1.0.3/HMC-Specifics-1.12.2-b2-full.jar && mv HMC-Specifics-1.12.2-b2-full.jar ~/.minecraft/mods
	wget https://github.com/3arthqu4ke/HeadlessForge/releases/download/1.2.0/headlessforge-1.2.0.jar && mv headlessforge-1.2.0.jar ~/.minecraft/mods
	wget https://github.com/3arthqu4ke/HeadlessMc/releases/download/1.5.2/headlessmc-launcher-1.5.2.jar
fi

#download minecraft and forge if not already done and login
if [ ! -d "$mcdir" ]; then
	$javadir/java -jar headlessmc-launcher-1.5.2.jar --command download 1.12.2
	$javadir/java -jar headlessmc-launcher-1.5.2.jar --command forge 1.12.2
fi

#make launch file for pb server if it hasnt been made already
if [ ! -d "$launch" ]; then
	touch hmc && cat >>~/hmc<<EOL
$javadir/java -jar headlessmc-launcher-1.5.2.jar --command $@
EOL
chmod +x hmc
fi

#tell user how to use hmc and how to launch server
echo $"

Run HeadlessMC with './hmc' and login to your Minecraft account with 'login [email] and password [password].
Use 'launch [id number next to the forge install] -id' to launch the Pingbypass server.

On 3arthh4ck in the multiplayer menu, turn Pingbypass ON, and input these connection details in this order. (If there isnt anything for IP, use your external IP)
IP '$externalip'
Port '$openport'
Password '$pass'"
