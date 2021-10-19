showLogo_jazztel() {
    printf "${yellow}  JAZZTEL    ${white}\n"
    printf "${yellow}  JAZZTEL    ${white}\n"
    printf "${yellow}  JAZZTEL    ${white}\n"
    printf "${yellow}  JAZZTEL    ${white}\n"
    printf "\n"
}

showLogo_jazztel2() {
    printf "${yellow}  ----    ${white}\n"
    printf "${yellow}  JAZZTEL    ${white}\n"
    printf "${yellow}  JAZZTEL    ${white}\n"
    printf "${yellow}  JAZZTEL    ${white}\n"
    printf "\n"
}

# Questions
showMenuInit_jazztel() {
    showLogo
    #printf "${white}-${yellow} 1)${colorPrimary} Configurar Entorno + Prepare ${white}\n"
    printf "${white}-${yellow} 1)${colorPrimary} Direct Update ${white}\n"
    printf "\n"
    msgFooterForQuestions "x"
    read opt
}
# Functions
selectEnvAndPrepare() {
    printf "$opt1"
}

buscarFullDelta(){
    ssh $userMF@$servidorMF 'bash -s'  < buscarArchivo.sh $rutaBusqueda $archivoBusqueda $servidorMF
}


showSubmenu1_jazztel(){
    showLogo
    utilsResponseQuestion "¿Que entorno necesitas?"
    printf "${white}-${yellow} 1)${colorPrimary} environment PRO  ${white}\n"
    printf "${white}-${yellow} 2)${colorPrimary} environment UAT${white}\n"
    printf "${white}-${yellow} 3)${colorPrimary} environment UAT2 ${white}\n"
    printf "${white}-${yellow} 4)${colorPrimary} enviroment ASE ${white}\n"
    #printf "${white}-${yellow} 5)${colorPrimary}  ${white}\n"
    #printf "${white}-${yellow} 6)${colorPrimary}  ${white}\n"
    #printf "${white}-${yellow} 7)${colorPrimary}  ${white}\n"
    printf "\n"
    msgFooterForQuestions "xx"
    read opt1
}
showSubmenu2_jazztel() {
    showLogo
    printf "${white}-${yellow} 1)${colorPrimary} Preparar paquetes DU ${white}\n"
    #printf "${white}-${yellow} 2)${colorPrimary} Buscar full y delta ${white}\n"
    #printf "${white}-${yellow} 3)${colorPrimary} Subir full y delta ${white}\n"
    #printf "${white}-${yellow} 4)${colorPrimary} Desplegar movilizado ${white}\n"
    #printf "\n"
    msgFooterForQuestions "xx"
    read opt2
}

directUpdate_jazztel() {
    clear
    showLogo

    utilsResponseInfo "Creacion automatica de paquetes para DU\n"
    directUpdateVersionsJazztel
    versionsAndroidTotal=${#versionsAndroidArray[@]}
    versionsiOSTotal=${#versionsiOSArray[@]}
    packagesToGenerate="$(($versionsAndroidTotal + $versionsiOSTotal))"
    utilsResponseWait "Generando $packagesToGenerate paquetes... \n"

    [ -d "$pathPackagesJazztel/$packageDefaultMiJazztelAndroid" ] && rm -r "$pathPackagesJazztel/$packageDefaultMiJazztelAndroid"
    [ -d "$pathPackagesJazztel/$packageDefaultMiJazzteliOS" ] && rm -r "$pathPackagesJazztel/$packageDefaultMiJazzteliOS"
     
    # Generamos DU
    # cd $pathRepoAmena && grunt DU

    utilsResponseWait "Descomprimiendo zip Android\n"
    cd $pathPackagesJazztel && unzip -q "$packageDefaultMiJazztelAndroid.zip" -d "$pathPackagesJazztel/$packageDefaultMiJazztelAndroid"
    utilsResponseWait "Descomprimiendo zip iOS\n"
    cd $pathPackagesJazztel && unzip -q "$packageDefaultMiJazzteliOS.zip" -d "$pathPackagesJazztel/$packageDefaultMiJazzteliOS"

    while IFS= read -r line; do
        if [[ $line = *"app.checksum"* ]]; then
            appChecksum=$line
        fi
    done <"$pathPackagesJazztel/$packageDefaultMiJazztelAndroid/meta/deployment.data"

    IFS='app.checksum=' read -ra appChecksumArray <<<"$appChecksum"
    for i in "${appChecksumArray[@]}"; do
        appChecksum=$i
    done

    utilsResponseOK "appChecksum: ${appChecksum} \n"
    #Variable temporales para resolver bug que solo se cambia la version con la primera vuelta y que se almacene la última modificada (ios/android)
    tempVersionJazztel=${versionDefaultJazztel}
    lastVersionAndroidJazztel=${versionDefaultJazztel}
    lastVersionIosJazztel=${versionDefaultJazztel}

    # Modificamos la version en cada deployment.data y creamos el zip
    for i in "${versionsAndroidArray[@]}"; do
        [ -d "$pathPackagesJazztel/com.orange.bluu.jazztel-android-$i.zip" ] && rm "$pathPackagesJazztel/com.orange.bluu.jazztel-android-$i.zip"
        cd "$pathPackagesJazztel/$packageDefaultMiJazztelAndroid/meta/" && sed -i "" "s/$tempVersionJazztel/$i/g" *
        cd "$pathPackagesJazztel/$packageDefaultMiJazztelAndroid" && zip -rqo "$pathPackagesJazztel/com.orange.bluu.jazztel-android-$i.zip" meta www
        utilsResponseOK "Version $i de Android, generada"
        tempVersionJazztel=$i
        lastVersionAndroidJazztel=$i
    done

    tempVersionJazztel=${versionDefaultJazztel}

    for i in "${versionsiOSArray[@]}"; do
        [ -d "$pathPackagesJazztel/com.orange.sp.jazztel-ios-$i.zip" ] && rm "$pathPackagesJazztel/com.orange.sp.jazztel-ios-$i.zip"
        cd "$pathPackagesJazztel/$packageDefaultMiJazzteliOS/meta/" && sed -i "" "s/$tempVersionJazztel/$i/g" *
        cd "$pathPackagesJazztel/$packageDefaultMiJazzteliOS" && zip -rqo "$pathPackagesJazztel/com.orange.sp.jazztel-ios-$i.zip" meta www
        utilsResponseOK "Version $i de iOS, generada"
        tempVersionJazztel=$i
        lastVersionIosJazztel=$i
    done
    
    # Crear la version de prueba sí selecciono sí
    # generarVersionTestJazztel por ahora no existe
    

    # Eliminamos las carpetas descomprimidas
    rm -r $pathPackagesJazztel/$packageDefaultMiJazztelAndroid
    rm -r $pathPackagesJazztel/$packageDefaultMiJazzteliOS

    # Movemos los archivos a la carpeta DU
    [ -d "$pathPackagesJazztel/DU" ] && rm -r $pathPackagesJazztel/DU
    mkdir $pathPackagesJazztel/DU
    for i in "${versionsAndroidArray[@]}"; do
        mv "$pathPackagesJazztel/com.orange.bluu.jazztel-android-$i.zip" "$pathPackagesJazztel/DU/com.orange.bluu.jazztel-android-$i.zip"
    done

    for i in "${versionsiOSArray[@]}"; do
        mv "$pathPackagesJazztel/com.orange.sp.jazztel-ios-$i.zip" "$pathPackagesJazztel/DU/com.orange.sp.jazztel-ios-$i.zip"
    done

    moverVersionTestDUAmena
    
    findFileBrowser=$(find $pathBrowserJazztel  -iname mijazztelbrowser_*_browser_build.zip)
    if [ ! -z "$findFileBrowser" ]; then
        fileBrowser=${findFileBrowser##*/}
        #echo "$findFileBrowser"
        #echo "$fileBrowser"
        cp $pathBrowserJazztel/$fileBrowser $pathPackagesJazztel/DU/$fileBrowser
        utilsResponseOK "Movilizado copiado a la carpeta DU"
    else
     utilsResponseKO "Fallo en  movilizado a mover a la carpeta DU"
    fi
    printf "\n"
    utilsResponseOK "Archivos movidos a la carpeta DU"
    exit

}




directUpdateVersionsJazztel(){
 
    #utilsResponseQuestion "¿Generar versiones de prueba $versionTestAndroid/$versionTestiOS? (s/n)"
    #read testVersions
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
