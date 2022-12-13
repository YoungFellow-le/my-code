#!/bin/bash

red=$'\e[1;31m'
green=$'\e[1;32m'
blue=$'\e[1;34m'
magenta=$'\e[1;35m'
cyan=$'\e[1;36m'
yellow=$'\e[1;93m'
white=$'\e[0m'
bold=$'\e[1m'
norm=$'\e[21m'
reset=$'\e[0m'

help() 
{
    echo "Description: My custom utilities"
    echo "Usage: ${yellow}$(basename "$0") OPTIONS [PARAMS]...${reset}"
    echo ""
    echo "-h|--help                           Show this help message"
    echo "-s|--start-vm ${bold}VM_NAME${reset}               Start virtual machine"
    echo "-r|--restart-plasma                 Restart KDE Plasma desktop"
    echo "-c|--custom-res ${bold}H V OUTPUT${reset}          Set custom resolution to a display"
    echo "-m|--set-monitors                   Set the monitors to your default setup"
    echo "-p|--pid-shutdown ${bold}PID(s)${reset}            Shutdown the computer after a process exits"
    echo ""

}

printMessage() 
{
    echo -e "\n    ${yellow}[+]${reset}${bold} $1${reset} \n"
}


restartPlasma() 
{
    printMessage "Restarting Plasma Desktop"
    kquitapp5 plasmashell
    kstart5 plasmashell&
}

startVM()
{
    printMessage "Starting VM: $1"
    virsh --connect qemu:///system start "$1"
    virt-manager --connect qemu:///system --show-domain-console "$1"
}

setCustomRes() 
{
    printMessage "Setting custom resolution of $1x$2 to output $3"

    CVT=$(cvt "$1" "$2" | tail -1 | cut -d ' ' -f2-)
    MODE=$(echo "$CVT" | cut -d ' ' -f1 | sed "s/\"//g")
    xrandr --newmode "$CVT"

    xrandr --addmode "$3" "$MODE"
    xrandr --output "$3" --mode "$MODE"
}

setMonitors()
{
    printMessage "Setting your default screen resolution"

    xrandr -d :0 --output DP-1 --auto
    xrandr -d :0 --output DP-1-1 --auto

    MODE=$(optimus-manager --print-mode | cut -d " " -f 5)

    CVT=$(cvt 1920 1080 | tail -1 | cut -d ' ' -f2-)
    secondary_mode=$(echo "$CVT" | cut -d ' ' -f1)
    connected=$(xrandr --listactivemonitors | grep ' DP-1' | sed "s/\"//g")
    xrandr --newmode "$CVT"

    CVT2=$(cvt 1600 900 | tail -1 | cut -d ' ' -f2-)
    primary_mode=$(echo "$CVT2" | cut -d ' ' -f1 | sed "s/\"//g")
    xrandr --newmode "$CVT2"

    if [[ $connected != "" ]]
    then
        if [[ $MODE == "nvidia" ]]
        then
            xrandr --addmode DP-1-1 "$secondary_mode"
            xrandr --addmode eDP-1-1 "$primary_mode"
            xrandr --output eDP-1-1 --primary --mode "$primary_mode" --pos 0x180 --output HDMI-1-1 --off --output DP-1-1 --pos 1600x0 --mode "$secondary_mode"
        else 
            xrandr --addmode DP-1 "$secondary_mode"
            xrandr --addmode eDP-1 "$primary_mode"
            xrandr --output eDP-1 --primary --mode "$primary_mode" --pos 0x180 --output HDMI-1 --off --output DP-1 --pos 1600x0 --mode "$secondary_mode"
        fi

    else
        if [[ $MODE == "nvidia" ]]
        then
            xrandr --addmode eDP-1-1 "$primary_mode"
            xrandr --output eDP-1-1 --primary --mode "$primary_mode" --output HDMI-1-1 --off
        else 
            xrandr --addmode eDP-1 "$primary_mode"
            xrandr --output eDP-1 --primary --mode "$primary_mode" --output HDMI-1 --off
        fi
    fi
}

shutdownAfterPid()
{
    printMessage "Will shutdown after pid $1 exits"
    while [[ $(ps "$1" &> /dev/null)$? -eq 0 ]]; do
        sleep 2
    done && shutdown -h now
}



while :; do
    case $1 in
        -h|--help)
            help
            exit
            ;;
        -s|--start-vm)
            if [ "$2" ]; then
                shift
                startVM "$1"
            else
                echo "${red}ERROR:${reset} \"-s|--start-vm\" requires a ${bold}non-empty argument${reset}"
            fi
            ;;
        -r|--restart-plasma)
            restartPlasma
            ;;
        -c|--custom-res)
            if [ "$2" ] && [ "$3" ] && [ "$4" ]; then
                shift
                setCustomRes "$1" "$2" "$3"
            else
                echo "${red}ERROR:${reset} \"-c|--custom-res\" requires ${bold}3${reset} arguments"
            fi
            ;;
        -m|--set-monitors)
            setMonitors
            ;;
        -p|--pid-shutdown)
            if [ "$2" ]; then
                shift
                shutdownAfterPid "$1"
            else
                echo "${red}ERROR:${reset} \"-p|--pid-shutdown\" requires ${bold}3${reset} arguments"
            fi
            ;;
        --)
            shift
            break
            ;;
        -?*)
            echo "${red}WARN:${reset} Unknown option (ignored): $1"
            ;;
        *)       
            
            break
    esac
    shift
done



# Might use this one day:
# --file=?*)
    #     file=${1#*=} # Delete everything up to "=" and assign the remainder.
    #     ;;
# -v|--verbose)
#             verbose=$((verbose + 1))  # Each -v adds 1 to verbosity.
#             ;;