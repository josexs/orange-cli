#!/bin/bash
HOST=$servidor84
USER=$user84
PASS=$pass84
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
