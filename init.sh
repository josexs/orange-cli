#!/bin/bash
ABSPATH=$(
    cd "$(dirname "$0")"
    pwd -P
)
source $ABSPATH/config.sh $1
source $ABSPATH/utils/utils.sh
source $ABSPATH/utils/utils-orange.sh
source $ABSPATH/utils/utils-amena.sh

if [ $error = true ]; then
    printf "¡Vaya! No has introducido el brand...¡Intentalo de nuevo!"
    exit
fi

showLogo() {
    if [ $brand = 'orange' ]; then
        showLogo_orange
    else
        showLogo_amena
    fi
    showLastUpdate
}

showMenu() {
    if [ $brand = 'orange' ]; then
        showMenuInit_orange
    else
        showMenuInit_amena
    fi
}

showSubmenu1() {
    if [ $brand = 'orange' ]; then
        showSubmenu1_orange
    else
        showSubmenu1_amena
    fi
}

showSubmenu2() {
    if [ $brand = 'orange' ]; then
        showSubmenu2_orange
    else
        showSubmenu2_amena
    fi
}

directUpdate() {
    if [ $brand = 'orange' ]; then
        directUpdate_orange
    else
        directUpdate_amena
    fi
}



generateEnvVars_orange(){
    printf "\n"
    utilsResponseWait "Generando archivo de entorno Orange"
    cd $pathRepoOrange && grunt generate_env_vars:$1  >/dev/null
    utilsResponseOK "Archivo de entorno generado correctamente"
    utilsResponseWait "Generando entorno"
    cd $pathRepoOrange && grunt app_prepare >/dev/null
    utilsResponseOK "Entorno generado correctamente"
    # cd $pathRepoOrange && cordova build android
    # adb devices
    # adb install /Users/jgomepav/apps/MiOrange/platforms/android/build/outputs/apk/PLAY_STORE/debug/MiOrange-PLAY_STORE-debug.apk

    exit
}
generateEnvVars_amena(){
    printf "\n"
    utilsResponseWait "Generando archivo de entorno Amena"
    cd $pathRepoAmena && grunt generate_env_vars:$1  >/dev/null
    utilsResponseOK "Archivo de entorno generado correctamente"
    utilsResponseWait "Generando entorno"
    cd $pathRepoAmena && grunt app_prepare >/dev/null
    utilsResponseOK "Entorno generado correctamente"
    exit
}

xx() {
    clear
    showMenu
}

optionsForQuestions() {
    if [ $brand = 'orange' ]; then
        optionsForQuestions_orange
    else
       optionsForQuestions_amena
    fi
}

optionsForQuestions_orange() {
    while [ $opt != '' ]; do
        if [ $opt = '' ]; then
            exit
        else
            case $opt in
            1)
                opt1=0
                title="Configurar Entorno + Prepare"
                clear
                showSubmenu1
                case $opt1 in
                1) generateEnvVars_orange "PRO:DELIVERY:s" ;;
                2) generateEnvVars_orange "PRO:DELIVERY_EDICION:s" ;;
                3) ggenerateEnvVars_orange "PRO:PREVIEW_FACTURAS:s" ;;
                4) generateEnvVars_orange "PRO:UAT_DELIVERY:s" ;;
                5) generateEnvVars_orange "PRO:UAT_EDICION:s" ;;
                6) generateEnvVars_orange "UAT:DELIVERY:s" ;;
                7) generateEnvVars_orange "UAT:EDICION:s" ;;
                xx) xx ;;
                esac
                read opt1
                ;;
            2)
                opt2=0
                title="Direct Update"
                clear
                showSubmenu2
                case $opt2 in
                1) directUpdate ;;
                xx) xx ;;
                esac
                read opt2
                ;;
            esac
        fi
    done
}
optionsForQuestions_amena() {
    while [ $opt != '' ]; do
        if [ $opt = '' ]; then
            exit
        else
            case $opt in
            1)
                opt1=0
                title="Configurar Entorno + Prepare"
                clear
                showSubmenu1
                case $opt1 in
                1) generateEnvVars_amena "PRO:DELIVERY:s" ;;
                2) generateEnvVars_amena "UAT:DELIVERY:s" ;;
                3) generateEnvVars_amena "UAT:EDICION:s" ;;
                xx) xx ;;
                esac
                read opt1
                ;;
            2)
                opt2=0
                title="Direct Update"
                clear
                showSubmenu2
                case $opt2 in
                1) directUpdate ;;
                xx) xx ;;
                esac
                read opt2
                ;;
            esac
        fi
    done
}

clear
showMenu
optionsForQuestions
