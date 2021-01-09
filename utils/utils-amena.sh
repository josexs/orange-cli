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
    read testVersionsAmena
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

    [ -d "$pathPackagesAmena/$packageDefaultMiAmenaAndroid" ] && rm -r "$pathPackagesAmena/$packageDefaultMiAmenaAndroid"
    [ -d "$pathPackagesAmena/$packageDefaultMiAmenaiOS" ] && rm -r "$pathPackagesAmena/$packageDefaultMiAmenaiOS"

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
    #Variable temporales para resolver bug que solo se cambia la version con la primera vuelta y que se almacene la última modificada (ios/android)
    tempVersionAmena=${versionDefaultAmena}
    lastVersionAndroidAmena=${versionDefaultAmena}
    lastVersionIosAmena=${versionDefaultAmena}

    # Modificamos la version en cada deployment.data y creamos el zip
    for i in "${versionsAndroidArray[@]}"; do
        [ -d "$pathPackagesAmena/MiAmena-Androd-$i.zip" ] && rm "$pathPackagesAmena/MiAmena-Androd-$i.zip"
        cd "$pathPackagesAmena/$packageDefaultMiAmenaAndroid/meta/" && sed -i "" "s/$tempVersionAmena/$i/g" *
        cd "$pathPackagesAmena/$packageDefaultMiAmenaAndroid" && zip -rqo "$pathPackagesAmena/MiAmena-Androd-$i.zip" meta www
        utilsResponseOK "Version $i de Android, generada"
        tempVersionAmena=$i
        lastVersionAndroidAmena=$i
    done

    tempVersionAmena=${versionDefaultAmena}

    for i in "${versionsiOSArray[@]}"; do
        [ -d "$pathPackagesAmena/MiAmena-iOS-$i.zip" ] && rm "$pathPackagesAmena/MiAmena-iOS-$i.zip"
        cd "$pathPackagesAmena/$packageDefaultMiAmenaiOS/meta/" && sed -i "" "s/$tempVersionAmena/$i/g" *
        cd "$pathPackagesAmena/$packageDefaultMiAmenaiOS" && zip -rqo "$pathPackagesAmena/MiAmena-iOS-$i.zip" meta www
        utilsResponseOK "Version $i de iOS, generada"
        tempVersionAmena=$i
        lastVersionIosAmena=$i
    done
    
    # Crear la version de prueba sí selecciono sí
    generarVersionTestAmena
    

    # Eliminamos las carpetas descomprimidas
    rm -r $pathPackagesAmena/$packageDefaultMiAmenaAndroid
    rm -r $pathPackagesAmena/$packageDefaultMiAmenaiOS

    # Movemos los archivos a la carpeta DU
    [ -d "$pathPackagesAmena/DU" ] && rm -r $pathPackagesAmena/DU
    mkdir $pathPackagesAmena/DU
    for i in "${versionsAndroidArray[@]}"; do
        mv "$pathPackagesAmena/MiAmena-Androd-$i.zip" "$pathPackagesAmena/DU/MiAmena-Androd-$i.zip"
    done

    for i in "${versionsiOSArray[@]}"; do
        mv "$pathPackagesAmena/MiAmena-iOS-$i.zip" "$pathPackagesAmena/DU/MiAmena-iOS-$i.zip"
    done

    moverVersionTestDUAmena

    cp $pathBrowserAmena/miamena_web.zip $pathPackagesAmena/DU/miamena_web.zip

    printf "\n"
    utilsResponseOK "Archivos movidos a la carpeta DU"
    exit

}
#Genera versión de prueba con la ultima que se modifico al generar por el ciclo, se cambia el bundel para PRE en ios
generarVersionTestAmena() {
    if [[ "$testVersionsAmena" = "s" ]]; then
        utilsResponseQuestion "Generando version de pruebas Amena $versionTestAndroidAmena/$versionTestiOSAmena"
        [ -d "$pathPackagesAmena/MiAmena-Androd-$versionTestAndroidAmena.zip" ] && rm "$pathPackagesAmena/MiAmena-Androd-$versionTestAndroidAmena.zip"
        cd "$pathPackagesAmena/$packageDefaultMiAmenaAndroid/meta/" && sed -i "" "s/$lastVersionAndroidAmena/$versionTestAndroidAmena/g" *
        cd "$pathPackagesAmena/$packageDefaultMiAmenaAndroid" && zip -rqo "$pathPackagesAmena/MiAmena-Androd-$versionTestAndroidAmena.zip" meta www
        utilsResponseOK "Version $versionTestAndroidAmena  Tets de Android, generada"
        [ -d "$pathPackagesAmena/MiAmena-iOS-$versionTestiOSAmena.zip" ] && rm "$pathPackagesAmena/MiAmena-iOS-$versionTestiOSAmena.zip"
        cd "$pathPackagesAmena/$packageDefaultMiAmenaiOS/meta/" && sed -i "" "s/$lastVersionIosAmena/~~/g; s/$bundelAmenaPro/$bundelAmenaPre/g; s/~~/$versionTestiOSAmena/g" *
        cd "$pathPackagesAmena/$packageDefaultMiAmenaiOS" && zip -rqo "$pathPackagesAmena/MiAmena-iOS-$versionTestiOSAmena.zip" meta www
        utilsResponseOK "Version $versionTestiOSAmena Test de iOS, generada"
    fi

}
#Para mover la version de pruebas siempre que la opción sea sí
moverVersionTestDUAmena(){
    if [[ "$testVersionsAmena" = "s" ]]; then
      mv "$pathPackagesAmena/MiAmena-Androd-$versionTestAndroidAmena.zip" "$pathPackagesAmena/DU/MiAmena-Androd-$versionTestAndroidAmena.zip"
      mv "$pathPackagesAmena/MiAmena-iOS-$versionTestiOSAmena.zip" "$pathPackagesAmena/DU/MiAmena-iOS-$versionTestiOSAmena.zip"
    fi
}



