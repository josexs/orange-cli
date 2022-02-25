#!/bin/bash
HOST=$servidor72
USER=$user72
PASS=$pass72
FICHEROS=$1
DIRECTORIO_REMOTO=$2
 
VAR=$(expect -c "
spawn scp -r $FICHEROS $USER@$HOST:$DIRECTORIO_REMOTO 
match_max 100000
expect \"*?assword:*\"
send -- \"$PASS\r\"
send -- \"\r\"
expect eof
")
echo "==============="
echo "$VAR"
