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
    printf "${white}-${yellow} 1)${colorPrimary} Backend ${white}\n"
    printf "${white}-${yellow} 2)${colorPrimary} Frontend ${white}\n"
    printf "${white}-${yellow} 3)${colorPrimary} Varios ${white}\n"
    printf "\n"
    msgFooterForQuestions "x"
    read opt
}

showSubmenu1_amena() {
    showLogo
    printf "${white}-${yellow} 1)${colorPrimary} Configurar Entorno + Prepare ${white}\n"
    printf "${white}-${yellow} 2)${colorPrimary} Direct Update ${white}\n"
    printf "${white}-${yellow} 3)${colorPrimary} Varios ${white}\n"
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
directUpdate_amena() {
    printf "DU"
}