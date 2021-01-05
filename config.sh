#!/bin/bash

ABSPATH=$(
  cd "$(dirname "$0")"
  pwd -P
)
#pathRepoOrange="/Users/jgomepav/apps/MiOrange"
#pathRepoAmena="/Users/jgomepav/apps/MiAmena"
pathRepoOrange="/Users/jzuritag/Orange/miOrange"
pathRepoAmena="/Users/jzuritag/Orange/miAmena"
pathPackages="$pathRepoOrange/mobilefirst"
pathBrowser="$pathRepoOrange/archive"
pathPackagesAmena="$pathRepoAmena/mobilefirst"
pathBrowserAmena="$pathRepoAmena/archive"
packageDefaultMiOrangeAndroid='com.orange.miorange-android-6.6.6'
packageDefaultMiOrangeiOS='com.everis.orange.miorange.pro-ios-6.6.6'
packageDefaultMiAmenaAndroid='com.orange.miamena-android-4.3.0'
packageDefaultMiAmenaiOS='com.orange.sp.miamena-ios-4.3.0'


bundelOrangePro="com.orange.sp.miorange"
bundelAmenenaPro="com.orange.sp.miamena"
bundelOrangePre="com.everis.orange.miorange.pro"
bundelAmenenaPre="com.everis.orange.miamena.pro"

versionDefault="6.6.6"
versionDefaultAmena="4.3.0"
appChecksum=""
versionTestAndroid="30"
versionTestiOS="30"
versionTestiOSAmena="50"
versionTestAndroidAmena="50"