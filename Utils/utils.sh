#!/bin/bash

red=$'\e[1;31m'
blue=$'\e[1;34m'
yellow=$'\e[1;93m'
bold=$'\e[1m'
reset=$'\e[0m'

magenta=$'\e[1;35m'
green=$'\e[1;32m'
cyan=$'\e[1;36m'
white=$'\e[0m'
norm=$'\e[21m'

real_pwd=$(realpath "$0" | sed -e "s@utils.sh@@g")

help() 
{ 
    echo "Description: My custom utilities"
    echo "${bold}Usage:${reset} ${yellow}$(basename "$0") OPTIONS [PARAMS]...${reset}"
    echo ""
    echo "-h|--help                                      Show this help message"
    echo "-s|--start-vm ${bold}VM_NAME${reset}                          Start virtual machine"
    echo "-r|--restart-plasma                            Restart KDE Plasma desktop"
    echo "-c|--custom-res ${bold}H V OUTPUT${reset}                     Set custom resolution to a display"
    echo "-m|--set-monitors                              Set the monitors to your default setup"
    echo "-p|--pid-command ${bold}PID(s) COMMAND${reset}                Run a command after a process exits"
    echo "--update-walc ${bold}WALC_VERSION COMMIT_MSG${reset}          Update the WALC AUR package to the new version"
    echo "                                                      - (${blue}https://github.com/WAClient/WALC${reset})"
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

    H=$1
    V=$2
    RES="$1x$2"
    OUTPUT=$3
    CVT=$(echo \"$RES\" $(cvt "$H" "$V" | tail -1 | cut -d ' ' -f3-))
    MODE=$(echo "$CVT" | cut -d ' ' -f1)
    STATUS=$(python3 "$real_pwd/display_check.py" "$OUTPUT" "$RES")
    if [[ $STATUS = "False" ]]; then
        xrandr --newmode $CVT
        xrandr --addmode "$OUTPUT" "$MODE"
    elif [[ ! $STATUS = "True" ]]; then
        echo "${red}ERROR:${reset} Output $OUTPUT is not active!"
        exit 1
    fi

    echo "MODE: $MODE"
    
    xrandr --output "$OUTPUT" --mode "$MODE"
}

setMonitors()
{
    graphics_mode="$(optimus-manager --print-mode | cut -d " " -f5)"
    if [[ $graphics_mode = "nvidia" ]]; then
        primary_output="eDP-1-1"
        secondary_output="DP-1-1"
    else
        primary_output="eDP-1"
        secondary_output="DP-1"
    fi

    printMessage "Setting your default screen resolution"
    
    ##### Primary Screen #####
    
    primary_mode="1600x900"
    primary_set="$(python3 "$real_pwd/display_check.py" $primary_output $primary_mode)"
    primary_cvt=$(echo "$primary_mode  $(cvt 1600 900 | tail -1 | cut -d ' ' -f3-)")
    
    [[ $primary_set = "False" ]] && xrandr --newmode $(echo $primary_cvt); xrandr --addmode $primary_output $primary_mode
    xrandr --output $primary_output --primary --mode $primary_mode
    
    ##### External Monitor #####

    xrandr --output $secondary_output --auto

    secondary_mode="1920x1080"
    secondary_set="$(python3 "$real_pwd/display_check.py" $secondary_output $secondary_mode)"
    secondary_connected=$(xrandr --listactivemonitors | grep " $secondary_output")
    
    if [[ $secondary_connected != "" ]]; then
        secondary_cvt=$(echo "$secondary_mode  $(cvt 1920 1080 | tail -1 | cut -d ' ' -f3-)")
        [[ $secondary_set = "False" ]] && xrandr --newmode $(echo $secondary_cvt); xrandr --addmode $secondary_output $secondary_mode
        xrandr --output $secondary_output --mode $secondary_mode --right-of $primary_output
    fi

    # Debug:
    # echo "Primary mode: $primary_mode"
    # echo "Secondary mode: $secondary_mode"
}

runAfterPid()
{
    printMessage "Will run command ($2) after pid $1 exits"
    while [[ $(ps "$1" &> /dev/null)$? -eq 0 ]]; do
        sleep 2
    done && $2
}

updateWALC()
{
    version=$1

    cd /home/abdullah/01-Projects/WALC/aur/

    printMessage "WALC PKGBUILD UPADATER"
    sleep 0.5
    printMessage "Downloading source file..."

    wget "https://github.com/WAClient/WALC/archive/refs/tags/v$version.tar.gz"
    file=v$version.tar.gz

    sleep 0.5
    printMessage "Generating MD5 sum..."
    md5sum=$(md5sum "$file" | awk '{print $1;}')

    sleep 0.5
    printMessage "Updating PKGBUILD"
    cat PKGBUILD_TEMPLATE | sed -e "s/put_version_number_over_here/$version/" -e "s/some-long-md5-hash/$md5sum/" > walc/PKGBUILD
    cd walc
    makepkg --printsrcinfo > .SRCINFO

    printMessage "Committing Changes"
    git add PKGBUILD .SRCINFO
    git commit -m "$2"

    printMessage "Pushing Changes"
    git push

    printMessage "All done!"
    cd
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
            break
            ;;
        -r|--restart-plasma)
            restartPlasma
            break
            ;;
        -c|--custom-res)
            if [ "$2" ] && [ "$3" ] && [ "$4" ]; then
                shift
                setCustomRes "$1" "$2" "$3"
            else
                echo "${red}ERROR:${reset} \"-c|--custom-res\" requires ${bold}3${reset} arguments"
            fi
            break
            ;;
        -m|--set-monitors)
            setMonitors
            break
            ;;
        -p|--pid-command)
            if [ "$2" ] && [ "$3" ]; then
                shift
                PID="$1"

                if ! ps -p "$PID" &> /dev/null; then
                    echo "${red}ERROR:${reset} provided PID does not exist!"
                    exit
                fi

                shift
                COMMAND="$*"
                runAfterPid "$PID" "$COMMAND"
            else
                echo "${red}ERROR:${reset} \"-s|--pid-command\" requires 2 ${bold}non-empty arguments${reset}"
            fi
            break
            ;;
        --update-walc)
            if [ "$2" ] && [ "$3" ]; then
                shift
                updateWALC "$1" "$3"
            else
                echo "${red}ERROR:${reset} \"--update-walc\" requires ${bold}2${reset} arguments"
            fi
            break
            ;;
        --)
            shift
            break
            ;;
        -?*)
            echo "${red}WARN:${reset} Unknown option (ignored): $1"
            ;;
        *)       
            help
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