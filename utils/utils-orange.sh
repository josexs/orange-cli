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
    printf "${white}-${yellow} 3)${colorPrimary} AppCenter ${white}\n"
    printf "\n"
    msgFooterForQuestions "x"
    read opt
}

# ENTORNOS
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

# DU
showSubmenu2_orange() {
    showLogo
    printf "${white}-${yellow} 1)${colorPrimary} Preparar paquetes DU ${white}\n"
    printf "${white}-${yellow} 2)${colorPrimary} Buscar full y delta ${white}\n"
    printf "${white}-${yellow} 3)${colorPrimary} Subir full y delta ${white}\n"
    printf "${white}-${yellow} 4)${colorPrimary} Desplegar movilizado ${white}\n"
    printf "\n"
    msgFooterForQuestions "xx"
    read opt2
}

# APPCENTER
showSubmenu3_orange() {
    showLogo
    printf "${white}-${yellow} 1)${colorPrimary} Subir APK y distribuir a grupo ${white}\n"
    printf "\n"
    msgFooterForQuestions "xx"
    read opt3
}

# Functions
selectEnvAndPrepare() {
    printf "$opt1"
}

buscarFullDelta(){
    ssh $userMF@$servidorMF 'bash -s'  < buscarArchivo.sh $rutaBusqueda $archivoBusqueda $servidorMF
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
    cd $pathRepoOrange && grunt DU

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
    #Variable temporales para resolver bug que solo se cambia la version con la primera vuelta y que se almacene la última modificada (ios/android)
    utilsResponseOK "appChecksum: ${appChecksum} \n"
    tempVersion=${versionDefault}
    lastVersionAndroid=${versionDefault}
    lastVersionIos=${versionDefault}
    

    # Modificamos la version en cada deployment.data y creamos el zip
    for i in "${versionsAndroidArray[@]}"; do
        
        [ -d "$pathPackages/MiOrange-Android-$i.zip" ] && rm "$pathPackages/MiOrange-Android-$i.zip"
        cd "$pathPackages/$packageDefaultMiOrangeAndroid/meta/" && sed -i "" "s/$tempVersion/$i/g" *
        cd "$pathPackages/$packageDefaultMiOrangeAndroid" && zip -rqo "$pathPackages/MiOrange-Android-$i.zip" meta www
        utilsResponseOK "Version $i de Android, generada"
        tempVersion=$i
        lastVersionAndroid=$i
    done
    tempVersion=${versionDefault}
    # Modificamos el bundel de ios para que apunte a PRO, ya que se generá con un bundel de PRE sed 's/ab/~~/g; s/bc/ab/g; s/~~/bc/g', en AMENA apunta correctamente a PRO, el cambio se debería de realizara en AMENA en  la version de Pruebas (50 para amena)
    for i in "${versionsiOSArray[@]}"; do
        [ -d "$pathPackages/MiOrange-iOS-$i.zip" ] && rm "$pathPackages/MiOrange-iOS-$i.zip"
        cd "$pathPackages/$packageDefaultMiOrangeiOS/meta/" && sed -i "" "s/$tempVersion/~~/g; s/$bundelOrangePre/$bundelOrangePro/g; s/~~/$i/g" *
        cd "$pathPackages/$packageDefaultMiOrangeiOS" && zip -rqo "$pathPackages/MiOrange-iOS-$i.zip" meta www
        utilsResponseOK "Version $i de iOS, generada"
        tempVersion=$i
        lastVersionIos=$i
    done
    # Crear la version de prueba sí selecciono sí
    generarVersionTest
    

    # Eliminamos las carpetas descomprimidas
    rm -r $pathPackages/$packageDefaultMiOrangeAndroid
    rm -r $pathPackages/$packageDefaultMiOrangeiOS

    # Movemos los archivos a la carpeta DU
    [ -d "$pathPackages/DU" ] && rm -r $pathPackages/DU
    mkdir $pathPackages/DU
    for i in "${versionsAndroidArray[@]}"; do
        mv "$pathPackages/MiOrange-Android-$i.zip" "$pathPackages/DU/MiOrange-Android-$i.zip"
    done

    for i in "${versionsiOSArray[@]}"; do
        mv "$pathPackages/MiOrange-iOS-$i.zip" "$pathPackages/DU/MiOrange-iOS-$i.zip"
    done
     # Movemos la version  de prueba sí selecciono sí junto las versiones de PRO
    moverVersionTestDU
    cp $pathBrowser/miorange_web.zip $pathPackages/DU/miorange_web.zip

    printf "\n"
    utilsResponseOK "Archivos movidos a la carpeta DU"
    exit

}

generarVersionTest() {
    if [[ "$testVersions" = "s" ]]; then
        utilsResponseQuestion "Generando version de pruebas $versionTestAndroid/$versionTestiOS"
        [ -d "$pathPackages/MiOrange-Android-$versionTestAndroid.zip" ] && rm "$pathPackages/MiOrange-Android-$versionTestAndroid.zip"
        cd "$pathPackages/$packageDefaultMiOrangeAndroid/meta/" && sed -i "" "s/$lastVersionAndroid/$versionTestAndroid/g" *
        cd "$pathPackages/$packageDefaultMiOrangeAndroid" && zip -rqo "$pathPackages/MiOrange-Android-$versionTestAndroid.zip" meta www
        utilsResponseOK "Version $versionTestAndroid  Tets de Android, generada"
        [ -d "$pathPackages/MiOrange-iOS-$versionTestiOS.zip" ] && rm "$pathPackages/MiOrange-iOS-$versionTestiOS.zip"
        cd "$pathPackages/$packageDefaultMiOrangeiOS/meta/" && sed -i "" "s/$lastVersionIos/~~/g; s/$bundelOrangePro/$bundelOrangePre/g; s/~~/$versionTestiOS/g" * 
        

        cd "$pathPackages/$packageDefaultMiOrangeiOS" && zip -rqo "$pathPackages/MiOrange-iOS-$versionTestiOS.zip" meta www
        utilsResponseOK "Version $versionTestiOS Test de iOS, generada"
    fi

}
moverVersionTestDU(){
    if [[ "$testVersions" = "s" ]]; then
      mv "$pathPackages/MiOrange-Android-$versionTestAndroid.zip" "$pathPackages/DU/MiOrange-Android-$versionTestAndroid.zip"
      mv "$pathPackages/MiOrange-iOS-$versionTestiOS.zip" "$pathPackages/DU/MiOrange-iOS-$versionTestiOS.zip"
    fi
}

distributeAppCenter() {
    clear
    utilsResponseQuestion "¿Quieres generar el APK? (s/n)"
    read quiereAPK

    if [[ "$quiereAPK" = "n" ]]; then
        utilsResponseQuestion "Introduce la ruta exacta del apk"
        read pathAPKNoGenerated
        if [ -f ${pathAPKNoGenerated} ]; then
            utilsResponseOK "APK Encontrado"
        else
            utilsResponseKO "El APK no existe en la ruta proporcionada"
            exit
        fi
    fi
    utilsResponseQuestion "¿A que grupo te gustaria enviar el APK?"
    printf "${white}-${yellow} 1)${colorPrimary} Equipo APP ${white}\n"
    printf "${white}-${yellow} 2)${colorPrimary} POs ${white}\n"
    printf "${white}-${yellow} 3)${colorPrimary} Squad Te Pago ${white}\n"
    printf "${white}-${yellow} 4)${colorPrimary} Squad Gestiona mi cuenta ${white}\n"
    printf "${white}-${yellow} 5)${colorPrimary} Squad Necesito Ayuda ${white}\n"
    printf "${white}-${yellow} 6)${colorPrimary} Squad Aprendo ${white}\n"
    printf "${white}-${yellow} 7)${colorPrimary} Squad Compro + ${white}\n\n"
    msgFooterForQuestions "xxx"
    read groupAppcenterQuestion

    utilsResponseInfo "Escribe la release note"
    read releaseNote

    if [[ "$quiereAPK" = "s" ]]; then
        utilsResponseInfo "Generando APK... Tomatelo con calma, suelen ser 3 minutos 😅"
        cd $pathRepoOrange && grunt generate_env_vars:PRO:DELIVERY:s
        cd $pathRepoOrange && grunt app_prepare:android
        cd $pathRepoOrange/platforms/android && chmod 777 gradlew
        cd $pathRepoOrange/platforms/android && ./gradlew clean
        cd $pathRepoOrange/platforms/android && ./gradlew assemblePLAY_STOREDebug
    fi
    case $groupAppcenterQuestion in
    1) distributeAppCenter2 $appGroupAppCenter $releaseNote $quiereAPK $pathAPKNoGenerated ;;
    2) distributeAppCenter2 $posGroupAppCenter $releaseNote $quiereAPK $pathAPKNoGenerated ;;
    3) distributeAppCenter2 $squadTePagoGroupAppCenter $releaseNote $quiereAPK $pathAPKNoGenerated ;;
    4) distributeAppCenter2 $squadGestionaMiCuentaGroupAppCenter $releaseNote $quiereAPK $pathAPKNoGenerated ;;
    5) distributeAppCenter2 $squadNecesitoAyudaGroupAppCenter $releaseNote $quiereAPK $pathAPKNoGenerated ;;
    6) distributeAppCenter2 $squadAprendoGroupAppCenter $releaseNote $quiereAPK $pathAPKNoGenerated ;;
    7) distributeAppCenter2 $squadComproMasGroupAppCenter $releaseNote $quiereAPK $pathAPKNoGenerated ;;
    xxx) xx ;;
    esac
    read groupAppcenterQuestion
}

distributeAppCenter2() {
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    pathAPK=""

    if [[ "$3" = "n" ]]; then
        pathAPK=$4
    else
        pathAPK=$pathAPKOrange
    fi
    if nvm --version >/dev/null 2>&1; then
        printf "\n"
        utilsResponseWait "Subiendo APK y distribuyendo a grupo..."
        nvm install 10 >/dev/null 2>&1
        nvm use 10 >/dev/null 2>&1
        if appcenter distribute release --app $appIdAppCenter --group $1 -r "$2" -f $pathAPK; then
            nvm use 6.9.3 >/dev/null 2>&1
            utilsResponseOK "APK subido correctamente y distribuido al grupo $1"
        else
            utilsResponseKO "Ha habido un problema al subir y distribuir el APK, revisalo"
        fi
    else
        utilsResponseInfo "No tienes NVM, instalando..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash >/dev/null 2>&1
        export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        printf "\n"
        utilsResponseWait "Subiendo APK y distribuyendo a grupo..."
        printf "\n"
        nvm install 10 >/dev/null 2>&1
        nvm use 10 >/dev/null 2>&1
        if appcenter distribute release --app $appIdAppCenter --group $1 -r "$releaseNote" -f $pathAPK; then
            nvm use 6.9.3 >/dev/null 2>&1
            utilsResponseOK "APK subido correctamente y distribuido al grupo $1"
        else
            utilsResponseKO "Ha habido un problema al subir y distribuir el APK, revisalo"
        fi
    fi
    nvm use 6.9.3 >/dev/null 2>&1
    exit
}
desplegarMovilizadoOrange(){
    #TODO seguir por aqui
    #1. Buscar el fichero y descomprimirlo
    FILE="$pathBrowser/miOrange_web.zip"
    EXECUTE_FILE="scriptsSubirArchivos/executeMovilizadoUAT.sh"
    if [ -f "$FILE" ]; then
      echo "$FILE exists."
      unzip -q $FILE -d $pathBrowser
      if [ -d "$pathBrowser/miOrange_web" ]; then
         echo "existe directorio"
         #2. Aceder al servidor y renombrar el directorio actual de miOrange de movilizado
         sh $EXECUTE_FILE
      fi
      

    else 
       utilsResponseKO "NO Existe .zip de movilizado"
        
    fi  

    
    #3. Subir el directorio
}