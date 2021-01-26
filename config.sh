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


pathPackages="$pathRepoOrange/mobilefirst"
pathBrowser="$pathRepoOrange/archive"
pathPackagesAmena="$pathRepoAmena/mobilefirst"
pathBrowserAmena="$pathRepoAmena/archive"
packageDefaultMiOrangeAndroid='com.orange.miorange-android-6.6.6'
packageDefaultMiOrangeiOS='com.everis.orange.miorange.pro-ios-6.6.6'
packageDefaultMiAmenaAndroid='com.orange.miamena-android-4.3.0'
packageDefaultMiAmenaiOS='com.orange.sp.miamena-ios-4.3.0'

bundelOrangePro="com.orange.sp.miorange"
bundelAmenaPro="com.orange.sp.miamena"
bundelOrangePre="com.everis.orange.miorange.pro"
bundelAmenaPre="com.everis.orange.miamena.pro"

versionDefault="6.6.6"
versionDefaultAmena="4.3.0"
appChecksum=""
versionTestAndroid="30.0"
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
                            
