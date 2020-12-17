#!/bin/bash

ABSPATH=$(
  cd "$(dirname "$0")"
  pwd -P
)

pathRepoOrange="/Users/jgomepav/apps/MiOrange"
pathRepoAmena="/Users/jgomepav/apps/MiAmena"
pathPackages="$pathRepoOrange/mobilefirst"
pathBrowser="$pathRepoOrange/archive"
packageDefaultMiOrangeAndroid='com.orange.miorange-android-6.6.6'
packageDefaultMiOrangeiOS='com.everis.orange.miorange.pro-ios-6.6.6'

versionDefault="6.6.6"
appChecksum=""
versionTestAndroid="30"
versionTestiOS="30"
