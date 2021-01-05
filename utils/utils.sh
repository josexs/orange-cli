#!/bin/bash

# Variables
lastUpdate="05-01-21"

# Colores
white=$(echo "\033[0;37m")
red=$(echo "\033[31m")
yellow=$(echo "\033[33m")
green=$(echo "\033[32m")
grey=$(echo "\033[90m")
orange=$(echo "\033[31m")

colorPrimary=""
colorSecondary=""
colorError=""
colorSuccess=""

brand=$1
error=false

setColorsOrange() {
  colorPrimary=$orange
  colorSecondary=$white
  colorError=$red
  colorSuccess=$green
}

setColorsAmena() {
  colorPrimary=$green
  colorSecondary=$white
  colorError=$red
  colorSuccess=$green
}

showLastUpdate() {
  printf "Ultima actualizacion: ${colorPrimary}$lastUpdate\n\n"
}

# Responses OK/KO/WAIT
utilsResponseOK() {
  printf ${green}"✅  ${white}$1\n"
}

utilsResponseKO() {
  printf ${red}"❌  ${white}$1\n"
}

utilsResponseInfo() {
  printf ${red}"🎤  ${white}$1\n"
}

utilsResponseWait() {
  printf ${red}"🕢  ${white}$1\n"
}

utilsResponseQuestion() {
  printf ${red}"🧐  ${white}$1\n"
}

msgFooterForQuestions() {
    printf "Introduce una opcion del menu ${yellow}/ ${red}${1} para salir ${white}"
}

if [ "$brand" == "orange" ]; then
  setColorsOrange
elif [ "$brand" == "amena" ]; then
  setColorsAmena
else
  error=true
fi
