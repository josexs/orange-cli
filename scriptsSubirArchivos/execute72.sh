#!/bin/bash
HOST=$servidor72
USER=$user72
PASS=$pass72

CMD=$@
VAR=$(expect -c "
spawn ssh -o StrictHostKeyChecking=no $USER@$HOST $CMD
match_max 100000
expect \"*?assword:*\"
send -- \"$PASS\r\"
send -- \"\r\"
expect eof
")
echo "==============="
echo "$VAR"
