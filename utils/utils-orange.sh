showLogo_orange() {
    printf "${orange}  ___    ___     _     _  _    ___   ___  ${white}\n"
    printf "${orange} / _ \  | _ \   /_\   | \| |  / __| |___| ${white}\n"
    printf "${orange}| (_) | |   /  / _ \  | .| | (__| | |__|  ${white}\n"
    printf "${orange} \___/  |_|_\ /_/ \_\ |_|\_|  \___| |___| ${white}\n"
    printf "\n"
}

# Questions
showMenuInit_orange() {
    showLogo
    printf "${white}-${yellow} 1)${colorPrimary} Configurar Entorno + Prepare ${white}\n"
    printf "${white}-${yellow} 2)${colorPrimary} Direct Update ${white}\n"
    printf "${white}-${yellow} 3)${colorPrimary} Varios ${white}\n"
    printf "\n"
    msgFooterForQuestions "x"
    read opt
}

showSubmenu1_orange() {
    showLogo
    utilsResponseQuestion "¿Que entorno necesitas?"
    printf "${white}-${yellow} 1)${colorPrimary} env.PRO.DELIVERY ${white}\n"
    printf "${white}-${yellow} 2)${colorPrimary} env.PRO.DELIVERY_EDICION ${white}\n"
    printf "${white}-${yellow} 3)${colorPrimary} env.PRO.PREVIEW_FACTURAS ${white}\n"
    printf "${white}-${yellow} 4)${colorPrimary} env.PRO.UAT_DELIVERY ${white}\n"
    printf "${white}-${yellow} 5)${colorPrimary} env.PRO.UAT_EDICION ${white}\n"
    printf "${white}-${yellow} 6)${colorPrimary} env.UAT.DELIVERY ${white}\n"
    printf "${white}-${yellow} 7)${colorPrimary} env.UAT.EDICION ${white}\n"
    printf "\n"
    msgFooterForQuestions "xx"
    read opt1
}

showSubmenu2_orange() {
    showLogo
    printf "${white}-${yellow} 1)${colorPrimary} Preparar paquetes DU ${white}\n"
    printf "\n"
    msgFooterForQuestions "xx"
    read opt2
}

# Functions

selectEnvAndPrepare() {
    printf "$opt1"
}

directUpdateVersionsOrange() {
    utilsResponseQuestion "¿Generar versiones de prueba $versionTestAndroid/$versionTestiOS? (s/n)"
    read testVersions
    utilsResponseQuestion "Introduce las versiones de Android, separadas por comas"
    read versionsAndroid
    IFS=, read -ra versionsAndroidArray <<<"$versionsAndroid"
    if [ ${#versionsAndroidArray[@]} = 0 ]; then
        utilsResponseKO "Es necesario que indiques alguna version de Android"
        exit
    fi

    utilsResponseOK "Hay ${colorPrimary}${#versionsAndroidArray[@]}${white} versiones para android\n"

    utilsResponseQuestion "Introduce las versiones de iOS, separadas por comas"
    read versionsiOS
    IFS=, read -ra versionsiOSArray <<<"$versionsiOS"
    if [ ${#versionsiOSArray[@]} = 0 ]; then
        utilsResponseKO "Es necesario que indiques alguna version de iOS"
        exit
    fi
    utilsResponseOK "Hay ${colorPrimary}${#versionsiOSArray[@]}${white} versiones para iOS\n"

}

directUpdate_orange() {
    clear
    showLogo

    utilsResponseInfo "Creacion automatica de paquetes para DU\n"
    directUpdateVersionsOrange
    versionsAndroidTotal=${#versionsAndroidArray[@]}
    versionsiOSTotal=${#versionsiOSArray[@]}
    packagesToGenerate="$(($versionsAndroidTotal + $versionsiOSTotal))"

    utilsResponseWait "Generando $packagesToGenerate paquetes... \n"

    [ -d "$pathPackages/$packageDefaultMiOrangeAndroid" ] && rm -r "$pathPackages/$packageDefaultMiOrangeAndroid"
    [ -d "$pathPackages/$packageDefaultMiOrangeiOS" ] && rm -r "$pathPackages/$packageDefaultMiOrangeiOS"

    # Generamos DU
    # cd $pathRepoOrange && grunt DU

    utilsResponseWait "Descomprimiendo zip Android\n"
    cd $pathPackages && unzip -q "$packageDefaultMiOrangeAndroid.zip" -d "$pathPackages/$packageDefaultMiOrangeAndroid"
    utilsResponseWait "Descomprimiendo zip iOS\n"
    cd $pathPackages && unzip -q "$packageDefaultMiOrangeiOS.zip" -d "$pathPackages/$packageDefaultMiOrangeiOS"

    while IFS= read -r line; do
        if [[ $line = *"app.checksum"* ]]; then
            appChecksum=$line
        fi
    done <"$pathPackages/$packageDefaultMiOrangeAndroid/meta/deployment.data"

    IFS='app.checksum=' read -ra appChecksumArray <<<"$appChecksum"
    for i in "${appChecksumArray[@]}"; do
        appChecksum=$i
    done

    utilsResponseOK "appChecksum: ${appChecksum} \n"

    # Modificamos la version en cada deployment.data y creamos el zip
    for i in "${versionsAndroidArray[@]}"; do
        [ -d "$pathPackages/MiOrange-Androd-$i.zip" ] && rm "$pathPackages/MiOrange-Androd-$i.zip"
        cd "$pathPackages/$packageDefaultMiOrangeAndroid/meta/" && sed -i "" "s/$versionDefault/$i/g" *
        cd "$pathPackages/$packageDefaultMiOrangeAndroid" && zip -rqo "$pathPackages/MiOrange-Androd-$i.zip" meta www
        utilsResponseOK "Version $i de Android, generada"
    done
   # Modificamos el bundel de ios para que apunte a PRO, ya que se generá con un bundel de PRE sed 's/ab/~~/g; s/bc/ab/g; s/~~/bc/g', en AMENA apunta correctamente a PRO, el cambio se debería de realizara en AMENA en  la version de Pruebas (50 para amena)
    for i in "${versionsiOSArray[@]}"; do
        [ -d "$pathPackages/MiOrange-iOS-$i.zip" ] && rm "$pathPackages/MiOrange-iOS-$i.zip"
        cd "$pathPackages/$packageDefaultMiOrangeiOS/meta/" && sed -i "" "s/$versionDefault/~~/g; s/$bundelOrangePre/$bundelOrangePro/g; s/~~/$i/g" *
        cd "$pathPackages/$packageDefaultMiOrangeiOS" && zip -rqo "$pathPackages/MiOrange-iOS-$i.zip" meta www
        utilsResponseOK "Version $i de iOS, generada"
    done

    # Eliminamos las carpetas descomprimidas
    rm -r $pathPackages/$packageDefaultMiOrangeAndroid
    rm -r $pathPackages/$packageDefaultMiOrangeiOS

    # Movemos los archivos a la carpeta DU
    [ -d "$pathPackages/DU" ] && rm -r $pathPackages/DU
    mkdir $pathPackages/DU
    for i in "${versionsAndroidArray[@]}"; do
        mv "$pathPackages/MiOrange-Androd-$i.zip" "$pathPackages/DU/MiOrange-Androd-$i.zip"
    done

    for i in "${versionsiOSArray[@]}"; do
        mv "$pathPackages/MiOrange-iOS-$i.zip" "$pathPackages/DU/MiOrange-iOS-$i.zip"
    done

    cp $pathBrowser/miorange_web.zip $pathPackages/DU/miorange_web.zip

    printf "\n"
    utilsResponseOK "Archivos movidos a la carpeta DU"
    exit

}

