EJECUTA1="scriptsSubirArchivos/execute72.sh"
EJECUTA2="scriptsSubirArchivos/execute84.sh"
UPLOAD1="scriptsSubirArchivos/upload72.sh"
UPLOAD2="scriptsSubirArchivos/upload84.sh"

plataforma="";
delta_existe="";

comprobarDescargaArchivos() {
    if [ -f ./$archivoBusqueda ];
    then
        echo
        echo "Veo que te has descargado el full"
        if [ -f ./$archivoSubida2 ];then
            echo
            echo "Veo que te has descargado el delta"
            delta_existe="1";
        else
            echo
            echo "********** ALARMA ***********"
            echo "No te has descargado el delta"
            echo
            delta_existe="0";
        fi
    else
        echo "No te has descargado los archivos"
        exit
    fi
    if [ -d ./www ];
    then
    rm -r www;
    fi
}

comprobarArchivosSonAndroid() {
    unzip full.zip > output_unzip.txt
    rm output_unzip.txt
    plataforma=$(grep Platform: www/cordova.js|head -1);
    miPlataforma1=$(echo "${plataforma##*:}");
    miPlataforma=$(echo $miPlataforma1 | sed 's/ //g')
    echo
    echo "Sistema ->"$miPlataforma
    rm -r www/
}


#Preguntar por el checksum
seteaVersion(){
    read -p "¿checksum? " checksum
}

# comprobarSubida() {
#     echo;
#     echo;
#     echo "***************************************";
#     echo "Introduce contraseña para la maquina 72 para comprobar archivos"
#     echo "***************************************";
#     echo;
#     sh PRUEBAS/prueba72.sh $directorio_final
#     echo;
#     echo;
#     echo "***************************************";
#     echo "Introduce contraseña para la maquina 84 para comprobar archivos"
#     echo "***************************************";
#     echo;
#     sh PRUEBAS/prueba84.sh $directorio_final
# }
funcionalidadSubirArchivos() {

    directorio_final="$ruta_base/$plataforma/$1/$checksum"
    #Se crean directorios
    echo "************************";
    echo "Se crean las carpetas 664 al $archivoBusqueda"
    echo "************************";
    echo
    sh $EJECUTA1 "mkdir -p $directorio_final"
    sh $EJECUTA2 "mkdir -p $directorio_final"
    sh $EJECUTA1 "mkdir $directorio_final"
    sh $EJECUTA2 "mkdir $directorio_final"
    echo
    echo

    #Se suben archivos
    echo "************************";
    echo "Se sube $archivoBusqueda"
    echo "************************";
    echo
    sh $UPLOAD1 $archivoBusqueda $directorio_final
    sh $UPLOAD2 $archivoBusqueda $directorio_final
    echo

    #Se dan permisos a los archivos
    echo "************************";
    echo "Se dan permisos 644 al $archivoBusqueda"
    echo "************************";
    echo
    sh $EJECUTA1 "chmod 644 $directorio_final/$archivoBusqueda"
    sh $EJECUTA2 "chmod 644 $directorio_final/$archivoBusqueda"
    echo

    #Se hace lo mismo para el delta
    if [ $delta_existe -eq "1" ]; then
        echo "************************";
        echo "Se sube $archivoSubida2"
        echo "************************";
        echo
        sh $UPLOAD1 $archivoSubida2 $directorio_final
        sh $UPLOAD2 $archivoSubida2 $directorio_final
        echo
        echo "************************";
        echo "Se dan permisos 644 al $archivoSubida2"
        echo "************************";
        echo
        sh $EJECUTA1 "chmod 644 $directorio_final/$archivoSubida2"
        sh $EJECUTA2 "chmod 644 $directorio_final/$archivoSubida2"
    else
        echo "No se ha subido el delta, ya que no existe"
    fi

}


subirArchivos(){
    comprobarDescargaArchivos
    comprobarArchivosSonAndroid
    plataforma=$brand
    echo "Elegiste ->"$plataforma
    read -p "¿checksum? " checksum
    
    utilsResponseQuestion "Introduce las versiones de Android, separadas por comas"
    read versionesDirectorios
    IFS=, read -ra versionesDirectoriosArray <<<"$versionesDirectorios"
    if [ ${#versionesDirectoriosArray[@]} = 0 ]; then
        utilsResponseKO "Es necesario que indiques las versiones que subiran"
        exit
    fi
    for i in "${versionesDirectoriosArray[@]}"; do
        echo;
        echo "***************************************";
        echo "$ruta_base/$plataforma/$i/$checksum"
        echo "***************************************";
        echo;
    done

    while true; do
        read -p "¿Estan bien las direcciones (yes or no)? " yn
        case $yn in
            yes ) break;;
            no ) echo "no han sido subidos, ten un buen dia";exit;;
        * ) echo "por favor responda yes o no";;
        esac
    done

    for j in "${versionesDirectoriosArray[@]}"; do
        funcionalidadSubirArchivos $j
    done

    echo;
    echo "***************************************";
    echo "Acabaste la subida de archivos"
    echo "***************************************";
}


