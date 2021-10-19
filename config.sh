#!/bin/bash

ABSPATH=$(
  cd "$(dirname "$0")"
  pwd -P
)

pathRepoOrange=$(grep pathRepoOrange .env | xargs)
IFS='=' read -ra pathRepoOrange <<<"$pathRepoOrange"
pathRepoOrange=${pathRepoOrange[1]}

pathRepoAmena=$(grep pathRepoAmena .env | xargs)
IFS='=' read -ra pathRepoAmena <<<"$pathRepoAmena"
pathRepoAmena=${pathRepoAmena[1]}

appIdAppCenter=$(grep appIdAppCenter .env | xargs)
IFS='=' read -ra appIdAppCenter <<<"$appIdAppCenter"
appIdAppCenter=${appIdAppCenter[1]}

servidorMF=$(grep servidorMF .env | xargs)
IFS='=' read -ra servidorMF <<<"$servidorMF"
servidorMF=${servidorMF[1]}

userMF=$(grep userMF .env | xargs)
IFS='=' read -ra userMF <<<"$userMF"
userMF=${userMF[1]}

rutaBusqueda=$(grep rutaBusqueda .env | xargs)
IFS='=' read -ra rutaBusqueda <<<"$rutaBusqueda"
rutaBusqueda=${rutaBusqueda[1]}

archivoBusqueda=$(grep archivoBusqueda .env | xargs)
IFS='=' read -ra archivoBusqueda <<<"$archivoBusqueda"
archivoBusqueda=${archivoBusqueda[1]}

archivoSubida2=$(grep archivoSubida2 .env | xargs)
IFS='=' read -ra archivoSubida2 <<<"$archivoSubida2"
archivoSubida2=${archivoSubida2[1]}

ruta_base=$(grep ruta_base .env | xargs)
IFS='=' read -ra ruta_base <<<"$ruta_base"
ruta_base=${ruta_base[1]}


pathRepoJazztel=$(grep pathRepoJazztel .env | xargs)
IFS='=' read -ra pathRepoJazztel <<<"$pathRepoJazztel"
pathRepoJazztel=${pathRepoJazztel[1]}

pathPackages="$pathRepoOrange/mobilefirst"
pathBrowser="$pathRepoOrange/archive"
pathPackagesAmena="$pathRepoAmena/mobilefirst"
pathBrowserAmena="$pathRepoAmena/archive"
pathPackagesJazztel="$pathRepoJazztel/mobilefirst"
pathBrowserJazztel="$pathRepoJazztel/browserBuilds"
packageDefaultMiOrangeAndroid='com.orange.miorange-android-6.6.6'
packageDefaultMiOrangeiOS='com.everis.orange.miorange.pro-ios-6.6.6'
packageDefaultMiJazztelAndroid='com.orange.bluu.jazztel-android-2.3.3'
packageDefaultMiJazzteliOS='com.orange.sp.jazztel-ios-2.3.3'
packageDefaultMiAmenaAndroid='com.orange.miamena-android-4.3.0'
packageDefaultMiAmenaiOS='com.orange.sp.miamena-ios-4.3.0'

bundelOrangePro="com.orange.sp.miorange"
bundelAmenaPro="com.orange.sp.miamena"
bundelOrangePre="com.everis.orange.miorange.pro"
bundelAmenaPre="com.everis.orange.miamena.pro"
bundelJazztelPro="com.orange.sp.jazztel"
bundelJazztelPre="com.everis.jazztel.pro"


versionDefault="6.6.6"
versionDefaultAmena="4.3.0"
versionDefaultJazztel="2.3.3"
appChecksum=""
versionTestAndroid="100.1"
versionTestiOS="30.0"
versionTestiOSAmena="50.0"
versionTestAndroidAmena="50.0"

#APPCENTER
appGroupAppCenter="APP"
posGroupAppCenter="POS"
squadTePagoGroupAppCenter="SquadTePago"
squadNecesitoAyudaGroupAppCenter="SquadNecesitoAyuda"
squadAprendoGroupAppCenter="SquadAprendo"
squadComproMasGroupAppCenter="SquadComproMas"
squadGestionaMiCuentaGroupAppCenter="SquadGestionaMiCuenta"
pathAPKOrange="$pathRepoOrange/platforms/android/build/outputs/apk/PLAY_STORE/debug/MiOrange-PLAY_STORE-debug.apk"
pathAPKAmena="$pathRepoAmena/platforms/android/build/outputs/apk/PLAY_STORE/debug/MiAmena-PLAY_STORE-debug.apk"
                            
