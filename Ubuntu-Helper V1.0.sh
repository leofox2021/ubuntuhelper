#To abort a snap install: 
#Snap changes - see which one to abort 
#Then run - sudo snap abort //number//

#If apt install was interrupted
#sudo dpkg --configure  -a

function gaming {
    #adding repository
    sudo add-apt-repository ppa:lutris-team/lutris #lurtis repository
    sudo dpkg --add-architecture i386 #wine
    wget -nc https://dl.winehq.org/wine-builds/winehq.key
    sudo apt-key add winehq.key
    sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
    sudo add-apt-repository ppa:kisak/kisak-mesa #latest mesa
    
    #installing
    sudo apt update 
    sudo apt full upgrade
    sudo apt-get install --install-recommends winehq-stable #wine
    sudo apt install lutris mesa-utils #mesa
}
    
    
function tearingamd {

    #amdgpu file 
    FILE=/usr/share/X11/xorg.conf.d/10-amdgpu.conf
    if [[ -f "$FILE" ]]; then
        tput setaf 3
        echo "amdgpu config exists!
        Fixing it.."
        sudo sed -i '5i Option "TearFree" "on"' /usr/share/X11/xorg.conf.d/10-amdgpu.conf
        sleep 0.5 
        tput setaf 3
        echo "All done!"
    else 
        echo "amdgpu config doesn't exist!
        Creating the file..." 
        sleep 0.5
        echo "Section "OutputClass"
            Identifier "AMDgpu"
            MatchDriver "amdgpu"
            Driver "amdgpu"
            Option "TearFree" "on"
        EndSection" > /usr/share/X11/xorg.conf.d/10-amdgpu.conf
    fi
    
    #10-radeon file 
    FILE=/usr/share/X11/xorg.conf.d/10-radeon.conf
    if [[ -f "$FILE" ]]; then
        tput setaf 3
        echo "radeon config exists!
        Fixing it.."
        sudo sed -i '5i Option "TearFree" "on"' /usr/share/X11/xorg.conf.d/10-radeon.conf
        sleep 0.5 
        tput setaf 3
        echo "All done!"
    else 
        echo "radeon config doesn't exist!
        Creating the file..." 
        sleep 0.5
        echo "Section "OutputClass"
            Identifier "Radeon"
            MatchDriver "radeon"
            Driver "radeon"
            Option "TearFree" "on"
        EndSection" > /usr/share/X11/xorg.conf.d/10-radeon.conf
    fi
}
    
function tearingnvidia {
    sudo echo options nvidia_drm modeset=1 > /etc/modprobe.d/zz-nvidia-modeset.conf
    sudo update-initramfs -u
    tput sgr3 
    echo "You must reboot to apply the changes!"
    anythingelse
}

function nvidia {
    sudo apt install nvidia-driver-460 
}


#this one is only kept for me to easily install apps. 
#you can adjust it for yourself as you wish. 
function myapps { 
    sudo add-apt-repository ppa:ubuntuhandbook1/apps
    sudo add-apt-repository ppa:ubuntustudio-ppa/ardour-backports
    sudo apt update
    sudo apt install obs-studio neofetch kate radeontop krita timeshift audacious qttools5-dev-tools qttools5-dev discord qbittorrent handbrake puddletag ardour qjackctl pulseaudio-module-jack jackd 
    flatpak install telegram discord simplenote
    flatpak install flathub org.olivevideoeditor.Olive
    sudo snap install atom chromium 
}
    
    
function menu {
    tput setaf 3
    echo "Available actions:"
    tput setaf 2
    sleep 0.1
    echo "1 - Install gaming programs"
    sleep 0.1
    echo "2 - Install nvidia drivers"
    sleep 0.1
    echo "3 - Tearing fix (AMD)"
    sleep 0.1
    echo "4 - Tearing fix (Nvidia)"
    sleep 0.1
    tput setaf 4 
    echo "What would you like to install? (1-4)"

    tput sgr0 
    read input 

    if [[ $input = "1" ]] ; then 
        gaming
        anythingelse

    elif [[ $input = "2" ]] ; then 
        nvidia
        anythingelse
        
    elif [[ $input = "3" ]] ; then 
        tearingamd
        anythingelse
        
    elif [[ $input = "4" ]] ; then 
        tearingnvidia
        anythingelse
        
    else 
        tput setaf 3 
        echo "You should enter a valid number! (1-4)"
        tput sgr0
        sleep 2
        clear
        menu 
    fi
}


function anythingelse {
    tput setaf 4 
    echo "Anything else? (Enter YES or NO)" 
    tput sgr0 
    read input 
    if [[ $input = no ]] ; then 
        exit
    else 
        clear
        menu  
    fi 
} 

#this function is kept here only for me 
#you can cahnge your username and add your apps to the function 
uservar=$USER 
if [[ $uservar = "lilfox" ]] ; then
    tput setaf 3 
    echo "Alright, Leo, installing your apps first!" 
    tput sgr0 
    myapps 
else 
    uservar=0
fi 

function entermenu {
    tput sgr0 
    read input 
    if [[ $input = "ubuntuhelper" ]] ; then 
        tput setaf 4
        echo "Some easter eggs we've got here!
        But let's get serious bro..."
        entermenu
    else
        menu
    fi 
}

#MAIN 
tput setaf 4 
sleep 0.1
echo "Hi there! This is my script to help you ease your Ubuntu usage"
sleep 0.1
echo "This script can help you install various unseful components to your system." 
sleep 0.1
echo "Press enter to proceed to the menu"
sleep 0.1
echo "(You will be asked your password several times during the installs)"
entermenu 


