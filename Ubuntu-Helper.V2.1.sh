#To abort a snap install: 
#Snap changes - see which one to abort 
#Then run - sudo snap abort //number//

#If apt install was interrupted
#sudo dpkg --configure  -a

#Overclocking the display
#Run this command - cvt *resolution* (ex. 1920 1080) *refresh rate* (ex 120)
#Add these lines to /etc/X11/xorg.conf:
#Section "ServerLayout"
#Identifier   "Layout0"
#   Screen   0 "Screen0" 0 0
#EndSection
#
#Section "Monitor"
#   Identifier    "Monitor0"
#   HorizSync       30.0 - *insert the hsync from cvt command* (ex. 76.49)
#   VertRefresh     30.0 - *insert your desired refresh rate* (ex. 120)
#   *insert the modeline output here*
#EndSection
#
#Section "Device"
#   Identifier   "Device0"
#   Driver   "amdgpu"
#   Option "Monitor-DisplayPort-1" "Monitor0"
#EndSection
#
#Section "Screen"
#   Identifier   "Screen0"
#   Device   "Device0"
#   Monitor   "Monitor0"
#   DefaultDepth   24
#    SubSection     "Display"
#      Depth       24
#      Modes *copy from the modeline* (ex. "1920x1080_68.00")
#   EndSubSection
#EndSection

function wine_checking_version {
    if [[ $(cat /etc/lsb-release | grep "DISTRIB_RELEASE") = "DISTRIB_RELEASE=21.04" ]] ; then #21.04
        tput setaf 3
        echo "Ubuntu 21.04 detected!"
        tput sgr0
        sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ hirsute main'
    elif [[ $(cat /etc/lsb-release | grep "DISTRIB_RELEASE") = "DISTRIB_RELEASE=20.10" ]] ; then #20.10
        tput setaf 3
        echo "Ubuntu 20.10 detected!"
        tput sgr0
        sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ groovy main'
    elif [[ $(cat /etc/lsb-release | grep "DISTRIB_RELEASE") = "DISTRIB_RELEASE=20.04" ]] ; then #20.04
        tput setaf 3
        echo "Ubuntu 20.04 detected!"
        tput sgr0
        sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
    elif [[ $(cat /etc/lsb-release | grep "DISTRIB_RELEASE") = "DISTRIB_RELEASE=18.04" ]] ; then #18.04
        tput setaf 3
        echo "Ubuntu 18.04 detected!"
        tput sgr0
        sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'
        sudo add-apt-repository ppa:cybermax-dexter/sdl2-backport
    else
        tput setaf 3
        echo "You either run an outdated version of Ubuntu or use a different distribution.
        If you use an older vesrion of Ubuntu please update your system!"
        tput sgr0
        sleep 1
    fi
    }

function gaming {
    #adding repository
    sudo add-apt-repository ppa:lutris-team/lutris #lurtis repositor
    sudo dpkg --add-architecture i386
    wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
    wine_checking_version
    sudo apt update
    sudo apt install --install-recommends winehq-devel lutris

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

function xanmod_kernel {

    function adding_xanmod_repo {
        echo 'deb http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-kernel.list
        wget -qO - https://dl.xanmod.org/gpg.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/xanmod-kernel.gpg add -
        sudo apt update
        clear
        }

    function xanmod_menu {
        tput setaf 3
        echo "Select your preferred Xanmod kernel"
        tput setaf 2
        sleep 0.1
        echo "1 - Xanmod"
        sleep 0.1
        echo "2 - Xanmod-Edge"
        sleep 0.1
        echo "3 - Xanmod-Realtime"
        sleep 0.1
        echo "4 - Xanmod-LTS"
        sleep 0.1
        echo "5 - Xanmod-CPU-Shed (Beta)"
        sleep 0.1
        echo "6 - Xanmod-Realtime-Edge (Beta)"
        sleep 0.1
        echo "7 - Back to menu"
        sleep 0.1
        tput setaf 4
        echo "Which kernel would you like to install? (1-7)"

        tput sgr0
        read input

        if [[ $input = "1" ]] ; then
            clear
            adding_xanmod_repo
            sudo apt install linux-xanmod
            clear
            anythingelse

        elif [[ $input = "2" ]] ; then
            clear
            adding_xanmod_repo
            sudo apt install linux-xanmod-edge
            clear
            anythingelse

        elif [[ $input = "3" ]] ; then
            clear
            adding_xanmod_repo
            sudo apt install linux-xanmod-rt
            clear
            anythingelse

        elif [[ $input = "4" ]] ; then
            clear
            adding_xanmod_repo
            sudo apt install linux-xanmod-lts
            clear
            anythingelse

        elif [[ $input = "5" ]] ; then
            clear
            adding_xanmod_repo
            sudo apt install linux-xanmod-cacule
            clear
            anythingelse

        elif [[ $input = "6" ]] ; then
            clear
            adding_xanmod_repo
            sudo apt install linux-xanmod-rt-edge
            clear
            anythingelse

        elif [[ $input = "7" ]] ; then
            clear
            menu

        else
            clear
            tput setaf 3
            echo "You should enter a valid number! (1-7)"
            tput sgr0
            sleep 2
            clear
            xanmod_menu
        fi

        }

    xanmod_menu
    }

#This one is only kept for me to easily install apps.
#Accessible from menu if you type "apps" instead of numbers.
#You can adjust it for yourself as you wish.
function myapps { 

    #Adding repos
    sudo add-apt-repository ppa:ubuntuhandbook1/apps #puddletag
    sudo add-apt-repository ppa:kisak/kisak-mesa #latest mesa
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb #chrome

    sudo apt update

    #Repo / deb apps
    sudo apt install neofetch kate radeontop krita timeshift audacious qbittorrent handbrake puddletag ardour qjackctl pulseaudio-module-jack jackd adb x42-plugins lsp-plugins calf-plugins guitarix-lv2 eq10q git kaffeine ffmpegthumbs libreoffice flatpak soundconverter mesa-utils

    sudo apt install ./google-chrome-stable_current_amd64.deb

    #audioshits
    sudo apt-get install apt-transport-https gpgv wget
    wget https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos_10.0.3_all.deb
    sudo dpkg -i kxstudio-repos_10.0.3_all.deb
    sudo apt install wineasio cadence
    regsvr32 wineasio
    wine64 regsvr32 wineasio

    gaming

    #qttools5-dev-tools qttools5-dev (if needed for pycharm)

    #Flatpak apps
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install simplenote
    flatpak install flathub org.olivevideoeditor.Olive
    flatpak install flathub org.kde.kdenlive
    flatpak install flathub com.discordapp.Discord
    flatpak install flathub com.google.AndroidStudio
    flatpak install flathub com.obsproject.Studio
    
    #Olive community effects
    cd /home/$USER
    git clone https://github.com/cgvirus/Olive-Editor-Community-Effects
    sudo mv Olive-Editor-Community-Effects /var/lib/flatpak/app/org.olivevideoeditor.Olive/x86_64/stable/0f1f1eab59b49640b97bfc9606b07c0292524c9a918aa0f5614f04a9eeea9fb8/files/share/olive-editor/effects

    #Adding user to audio group
    sudo usermod -a -G audio $USER

    }
    
    
function menu {
    clear
    tput setaf 3
    echo "Available actions:"
    tput setaf 2
    sleep 0.1
    echo "1 - Install gaming programs"
    sleep 0.1
    echo "2 - Install Nvidia drivers"
    sleep 0.1
    echo "3 - Install Wineasio"
    sleep 0.1
    echo "4 - Install Xanmod kernel"
    sleep 0.1
    echo "5 - Tearing fix (AMD)"
    sleep 0.1
    echo "6 - Tearing fix (Nvidia)"
    sleep 0.1
    tput setaf 3
    echo "Type "exit" to abort script"
    sleep 0.1
    tput setaf 4 
    echo "What would you like to install? (1-6)"

    tput sgr0 
    read input 

    if [[ $input = "1" ]] ; then 
        clear
        gaming
        clear
        anythingelse

    elif [[ $input = "2" ]] ; then 
        clear
        nvidia
        clear
        anythingelse
        
    elif [[ $input = "3" ]] ; then
        clear
        wineasio_install
        clear
        anythingelse
        
    elif [[ $input = "4" ]] ; then 
        clear
        xanmod_kernel
        clear
        anythingelse

    elif [[ $input = "5" ]] ; then
        clear
        tearingamd
        clear
        anythingelse

    elif [[ $input = "6" ]] ; then
        clear
        tearingnvidia
        clear
        anythingelse

    elif [[ $input = "apps" ]] ; then
        clear
        myapps
        clear
        anythingelse

    elif [[ $input = "exit" ]] ; then
        clear
        exit
        
    else 
        clear
        tput setaf 3 
        echo "You should enter a valid number! (1-6)"
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


