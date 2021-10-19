#!/bin/bash
ABSPATH=$(
    cd "$(dirname "$0")"
    pwd -P
)
source $ABSPATH/config.sh $1
source $ABSPATH/utils/utils.sh
source $ABSPATH/utils/utils-orange.sh
source $ABSPATH/utils/utils-amena.sh
source $ABSPATH/utils/utils-jazztel.sh
source $ABSPATH/subirRedireccion.sh

if [ $error = true ]; then
    utilsResponseKO "¡Vaya! No has introducido la marca... ¡Intentalo de nuevo!"
    exit
fi

showLogo() {
    if [ $brand = 'orange' ]; then
        showLogo_orange
    elif [ $brand = 'jazztel' ]; then
        showLogo_jazztel 
    else
        showLogo_amena
    fi
    showLastUpdate
}

showMenu() {
    if [ $brand = 'orange' ]; then
        showMenuInit_orange
   elif [ $brand = 'jazztel' ]; then
        showMenuInit_jazztel      
    else
        showMenuInit_amena
    fi
}

showSubmenu1() {
    if [ $brand = 'orange' ]; then
        showSubmenu1_orange
    elif [ $brand = 'jazztel' ]; then
        showSubmenu1_jazztel   
    else
        showSubmenu1_amena
    fi
}

showSubmenu2() {
    if [ $brand = 'orange' ]; then
        showSubmenu2_orange
    elif [ $brand = 'jazztel' ]; then
        showSubmenu2_jazztel     
    else
        showSubmenu2_amena
    fi
}

showSubmenu3() {
    if [ $brand = 'orange' ]; then
        showSubmenu3_orange
    else
        showSubmenu3_amena
    fi
}

directUpdate() {
    if [ $brand = 'orange' ]; then
        directUpdate_orange
    elif [ $brand = 'jazztel' ]; then
        directUpdate_jazztel       
    else
        directUpdate_amena
    fi
}
desplegarMovilizado() {
    if [ $brand = 'orange' ]; then
        desplegarMovilizadoOrange
    else
        desplegarMovilizadoAmena
    fi
}

generateEnvVars_orange() {
    printf "\n"
    utilsResponseWait "Generando archivo de entorno Orange"
    cd $pathRepoOrange && grunt generate_env_vars:$1 >/dev/null
    utilsResponseOK "Archivo de entorno generado correctamente"
    utilsResponseWait "Generando entorno"
    cd $pathRepoOrange && grunt app_prepare >/dev/null
    utilsResponseOK "Entorno generado correctamente"
    # cd $pathRepoOrange && cordova build android
    # adb devices
    # adb install /Users/jgomepav/apps/MiOrange/platforms/android/build/outputs/apk/PLAY_STORE/debug/MiOrange-PLAY_STORE-debug.apk

    exit
}
generateEnvVars_amena() {
    printf "\n"
    utilsResponseWait "Generando archivo de entorno Amena"
    cd $pathRepoAmena && grunt generate_env_vars:$1 >/dev/null
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
    elif [ $brand = 'jazztel' ]; then
       optionsForQuestions_jazztel
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
                2) buscarFullDelta ;;
                3) subirArchivos ;;
                4) desplegarMovilizado ;;
                xx) xx ;;
                esac
                read opt2
                ;;
            3)
                opt3=0
                title="AppCenter"
                clear
                showSubmenu3
                case $opt3 in
                1) distributeAppCenter ;;
                xx) xx ;;
                esac
                read opt3
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
                2) buscarFullDelta ;;
                3) desplegarMovilizado ;;
                xx) xx ;;
                esac
                read opt2
                ;;
            esac
        fi
    done
}

optionsForQuestions_jazztel(){
     while [ $opt != '' ]; do
        if [ $opt = '' ]; then
            exit
        else
            case $opt in
            1)
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
