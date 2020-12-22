showLogo_amena() {
  printf "${green}    _     __  __   ___   _  _     _    ${white}\n"
  printf "${green}   /_\   |  \/  | | __| | \| |   /_\   ${white}\n"
  printf "${green}  / _ \  | |\/| | | _|  |  . |  / _ \  ${white}\n"
  printf "${green} /_/ \_\ |_|  |_| |___| |_|\_| /_/ \_\ ${white}\n"
  printf "\n"
}

# Questions
showMenuInit_amena() {
    showLogo
    printf "${white}-${yellow} 1)${colorPrimary} Configurar Entorno + Prepare ${white}\n"
    printf "${white}-${yellow} 2)${colorPrimary} Direct Update ${white}\n"
    printf "${white}-${yellow} 3)${colorPrimary} Varios ${white}\n"
    printf "\n"
    msgFooterForQuestions "x"
    read opt
}

showSubmenu1_amena() {
    showLogo
    utilsResponseQuestion "¿Que entorno necesitas de Amena?"
    printf "${white}-${yellow} 1)${colorPrimary} env.PRO.DELIVERY ${white}\n"
    printf "${white}-${yellow} 6)${colorPrimary} env.UAT.DELIVERY ${white}\n"
    printf "${white}-${yellow} 7)${colorPrimary} env.UAT.EDICION ${white}\n"
    printf "\n"
    msgFooterForQuestions "xx"
    read opt1
}

showSubmenu2_amena() {
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

directUpdateVersionsAmena() {
    utilsResponseQuestion "¿Generar versiones de prueba $versionTestAndroidAmena/$versionTestiOSAmena? (s/n)"
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
directUpdate_amena() {
    clear
    showLogo

    utilsResponseInfo "Creacion automatica de paquetes para DU\n"
    directUpdateVersionsAmena
    versionsAndroidTotal=${#versionsAndroidArray[@]}
    versionsiOSTotal=${#versionsiOSArray[@]}
    packagesToGenerate="$(($versionsAndroidTotal + $versionsiOSTotal))"

    utilsResponseWait "Generando $packagesToGenerate paquetes... \n"

    [ -d "$pathPackagesAmena/$packageDefaultMiAmenaAndroid" ] && rm -r "$pathPackages/$packageDefaultMiAmenaAndroid"
    [ -d "$pathPackagesAmena/$packageDefaultMiAmenaiOS" ] && rm -r "$pathPackages/$packageDefaultMiAmenaiOS"

    # Generamos DU
    # cd $pathRepoAmena && grunt DU

    utilsResponseWait "Descomprimiendo zip Android\n"
    cd $pathPackagesAmena && unzip -q "$packageDefaultMiAmenaAndroid.zip" -d "$pathPackagesAmena/$packageDefaultMiAmenaAndroid"
    utilsResponseWait "Descomprimiendo zip iOS\n"
    cd $pathPackagesAmena && unzip -q "$packageDefaultMiAmenaiOS.zip" -d "$pathPackagesAmena/$packageDefaultMiAmenaiOS"

    while IFS= read -r line; do
        if [[ $line = *"app.checksum"* ]]; then
            appChecksum=$line
        fi
    done <"$pathPackagesAmena/$packageDefaultMiAmenaAndroid/meta/deployment.data"

    IFS='app.checksum=' read -ra appChecksumArray <<<"$appChecksum"
    for i in "${appChecksumArray[@]}"; do
        appChecksum=$i
    done

    utilsResponseOK "appChecksum: ${appChecksum} \n"

    # Modificamos la version en cada deployment.data y creamos el zip
    for i in "${versionsAndroidArray[@]}"; do
        [ -d "$pathPackagesAmena/MiOrange-Androd-$i.zip" ] && rm "$pathPackagesAmena/MiOrange-Androd-$i.zip"
        cd "$pathPackagesAmena/$packageDefaultMiAmenaAndroid/meta/" && sed -i -- "s/$versionDefaultAmena/$i/g" *
        cd "$pathPackagesAmena/$packageDefaultMiAmenaAndroid" && zip -rqo "$pathPackagesAmena/MiOrange-Androd-$i.zip" meta www
        utilsResponseOK "Version $i de Android, generada"
    done

    for i in "${versionsiOSArray[@]}"; do
        [ -d "$pathPackagesAmena/MiOrange-iOS-$i.zip" ] && rm "$pathPackagesAmena/MiOrange-iOS-$i.zip"
        cd "$pathPackagesAmena/$packageDefaultMiAmenaiOS/meta/" && sed -i -- "s/$versionDefault/$i/g" *
        cd "$pathPackagesAmena/$packageDefaultMiAmenaiOS" && zip -rqo "$pathPackagesAmena/MiOrange-iOS-$i.zip" meta www
        utilsResponseOK "Version $i de iOS, generada"
    done

    # Eliminamos las carpetas descomprimidas
    rm -r $pathPackagesAmena/$packageDefaultMiAmenaAndroid
    rm -r $pathPackagesAmena/$packageDefaultMiAmenaiOS

    # Movemos los archivos a la carpeta DU
    [ -d "$pathPackagesAmena/DU" ] && rm -r $pathPackagesAmena/DU
    mkdir $pathPackagesAmena/DU
    for i in "${versionsAndroidArray[@]}"; do
        mv "$pathPackagesAmena/MiOrange-Androd-$i.zip" "$pathPackagesAmena/DU/MiOrange-Androd-$i.zip"
    done

    for i in "${versionsiOSArray[@]}"; do
        mv "$pathPackagesAmena/MiOrange-iOS-$i.zip" "$pathPackagesAmena/DU/MiOrange-iOS-$i.zip"
    done

    cp $pathBrowserAmena/miamena_web.zip $pathPackagesAmena/DU/miamena_web.zip

    printf "\n"
    utilsResponseOK "Archivos movidos a la carpeta DU"
    exit

}



