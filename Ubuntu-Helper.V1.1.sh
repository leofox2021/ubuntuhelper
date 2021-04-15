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
    #sudo add-apt-repository ppa:kisak/kisak-mesa #latest mesa (if needed (but i dont recommend...))
    
    #installing
    sudo apt update 
    sudo apt full upgrade
    sudo apt install --install-recommends winehq-stable #wine
    sudo apt install lutris mesa-utils #mesa
}

function wineasio_install {
    sudo apt-get install apt-transport-https gpgv wget
    wget https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos_10.0.3_all.deb
    sudo dpkg -i kxstudio-repos_10.0.3_all.deb
    sudo apt update
    sudo apt install wineasio cadence
    regsvr32 wineasio
    wine64 regsvr32 wineasio

    }

function tearingamd {

    #amdgpu file 
    FILE=/usr/share/X11/xorg.conf.d/10-amdgpu.conf
    tput sgr0
    if [[ -f "$FILE" ]]; then
        tput setaf 3
        echo "amdgpu config exists!
        Fixing it.."
        tput sgr0
        sudo sed -i '5i Option "TearFree" "on"' /usr/share/X11/xorg.conf.d/10-amdgpu.conf
        sleep 0.5 
        echo "All done!"
    else 
        echo "amdgpu config doesn't exist!
        Creating the file..." 
        sleep 0.5
        tput sgr0
        echo "Section "OutputClass"
            Identifier "AMDgpu"
            MatchDriver "amdgpu"
            Driver "amdgpu"
            Option "TearFree" "on"
            Option "AccelMethod" "glamor"
        EndSection" > /usr/share/X11/xorg.conf.d/10-amdgpu.conf
    fi
    
    #10-radeon file 
    FILE=/usr/share/X11/xorg.conf.d/10-radeon.conf
    if [[ -f "$FILE" ]]; then
        tput setaf 3
        echo "radeon config exists!
        Fixing it.."
        tput sgr0
        sudo sed -i '5i Option "TearFree" "on"' /usr/share/X11/xorg.conf.d/10-radeon.conf
        sleep 0.5 
        tput setaf 3
        echo "All done!"
    else 
        echo "radeon config doesn't exist!
        Creating the file..." 
        sleep 0.5
        tput sgr0
        echo "Section "OutputClass"
            Identifier "Radeon"
            MatchDriver "radeon"
            Driver "radeon"
            Option "TearFree" "on"
            Option "AccelMethod" "glamor"
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
#accessible from menu if you type "apps" instead of numbers
#you can adjust it for yourself as you wish. 

function myapps { 

    #Adding repos
    sudo add-apt-repository ppa:ubuntuhandbook1/apps #puddletag
    sudo add-apt-repository ppa:ubuntustudio-ppa/ardour-backports #ardour
    sudo add-apt-repository https://www.mediahuman.com/packages/ubuntu #mediahuman
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys 7D19F1F3
    #audioshits
    sudo apt-get install apt-transport-https gpgv wget
    wget https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos_10.0.3_all.deb
    sudo dpkg -i kxstudio-repos_10.0.3_all.deb
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb #chrome
    sudo apt update

    #Repo / deb apps
    sudo apt install obs-studio neofetch kate radeontop krita timeshift audacious qttools5-dev-tools qttools5-dev qbittorrent handbrake puddletag ardour qjackctl pulseaudio-module-jack jackd youtube-to-mp3 youtube-downloader adb x42-plugins lsp-plugins git wineasio cadence kaffeine ffmpegthumbs libreoffice
    sudo apt install ./google-chrome-stable_current_amd64.deb

    #Flatpak apps
    flatpak install simplenote
    flatpak install flathub org.olivevideoeditor.Olive

    #Snap apps
    sudo snap install discord telegram natron
    sudo snap install atom --classic

    #Olive community effects
    git clone https://github.com/cgvirus/Olive-Editor-Community-Effects
    sudo mv Olive-Editor-Community-Effects /var/lib/flatpak/app/org.olivevideoeditor.Olive/x86_64/stable/0f1f1eab59b49640b97bfc9606b07c0292524c9a918aa0f5614f04a9eeea9fb8/files/share/olive-editor/effects

    #Adding user to audio group
    uservar=$USER
    usermod -a -G audio $uservar

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

    elif [[ $input = "apps" ]] ; then
        myapps

    elif [[ $input = "wineasio" ]] ; then
        wineasio_install
        
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


