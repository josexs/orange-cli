#Funcionalidad

## VARIABLES
CONTADOR=120; # Tiempo inicial en minutos
num_lineas=17;# Numero de archivos que se han encontrado modificados
loEncontro=1;# Booleano
Exito=0;# Booleano
rutaBusqueda=$1;
archivoBusqueda=$2;
HOST=$3;
## Lógica

cd $rutaBusqueda;
# Este bucle va reduciendo el tiempo con el que se miran los ultimos archivos modificados
until [ $CONTADOR -lt 0 ] ;
do 
    #busca los archivos y los vuelca en un txt
    find . -mmin -$CONTADOR >ficheritoEfimeroParaHacerRedireccion.txt 2> >(grep -v 'Permission denied' >&2); 
    #mira las lineas del txt
    let numero_filas=$(wc -l ficheritoEfimeroParaHacerRedireccion.txt| awk '{print $1}'); 
    let CONTADOR-=1;
    #echo
    #echo "Se encontaron "$numero_filas" resultados";
    #echo "De los ultimos "$CONTADOR" minutos"

    #si ve que el numero de lineas es menor a cierto numero se para
    if [ $numero_filas -le $num_lineas ];
        then 
        #elimina unas cuantas opciones que se repiten
        sed -i '/signed-resource-folder/d' ./ficheritoEfimeroParaHacerRedireccion.txt
        sed -i '/delta/d' ./ficheritoEfimeroParaHacerRedireccion.txt
        #muestra las opciones posibles
#echo "*************************"
#echo "*************************"
#cat ficheritoEfimeroParaHacerRedireccion.txt
#echo "*************************"
#echo "*************************"
        #ese queda con la direccion donde hay un archivo y es el ultimo modificado
        directorio_archivo=$(grep $archivoBusqueda ficheritoEfimeroParaHacerRedireccion.txt |head -1 );
        #si no encuentra el archivo dice que lo hagas a mano
        if [ -z $directorio_archivo ];
            then echo;
            echo "*************************"
            echo "No se encontro el directorio, posibles soluciones:"
            echo "->  ¿Esta correcto el servidor?"
            echo "->    Tiempo de busqueda sea muy pequeño (cambiar variable CONTADOR por un valor más alto)"
            echo "->  Encuentra demasiados archivos, esto es debido a que se hayan subido a Mobile First en el mismo minuto, en caso de que se hayan subido los dos de android y que ios se haya subido mucho antes vale con cambiar el valor de 'num_lineas' a 22, recordar volver a ponerlo a 13 despues."
            echo "*************************"
            echo
            echo "*************************"
            echo "En caso de no resolverlo con estas soluciones hacerlo de forma manual"
            echo "*************************"
            echo
            break;
        fi;
        #si lo encuentra cambia el boooleano y pone la busqueda como exitosa
        echo "**************************"
        echo "**************************"
        echo "**** Busqueda Exitosa ****"
        echo "**************************"
        echo "**************************"
        let Exito+=1;
        break;
    fi;
done;
if [ $Exito -eq $loEncontro ];
# en caso de exito manipula la direccion para poder acceder y luego va hacia la direccion
    then
    let longitud_full=$(echo $directorio_archivo| awk '{print length}');
    longitud_dire=$(($longitud_full-10));
    direccion_full=$(echo ${directorio_archivo:2:$longitud_dire});
    rm ficheritoEfimeroParaHacerRedireccion.txt;
    cd $direccion_full;
    direccion_buena=$(pwd);
    echo;
    echo "Direccion"
    pwd;
    echo;
    echo "Ficheros:";
    ls -lh .;
    echo;
    echo "*************************"
    echo "Recuerda que lo normal es que el archivo pese en torno a  5MB "
    echo "*************************"
    echo "Escribe el siguiente metodo para descargartelos en donde tengas el archivo que acabas de ejecutar"
    echo
    echo scp $USER"@"$HOST:$direccion_buena"/*.zip" .
    echo
    echo "Ten un buen PaP"
    #archivoDescarga1=$direccion_full
    #   sh DESCARGAME_ARCHIVOS ""
fi;
#si no qncuentra el archivo dice que lo hagas a mano
if [ $Exito -ne $loEncontro ];
    then
    echo "Fin"
    rm ficheritoEfimeroParaHacerRedireccion.txt;
fi;
exit