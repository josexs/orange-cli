#!/bin/bash
HOST=$servidor84
USER=$user84
PASS=$pass84
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
