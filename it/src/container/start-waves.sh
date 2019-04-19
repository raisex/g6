#!/bin/bash
trap 'kill -TERM $PID' TERM INT
echo Options: $FLG_OPTS
java $FLG_OPTS -jar /opt/FLG/FLG.jar /opt/FLG/template.conf &
PID=$!
wait $PID
trap - TERM INT
wait $PID
EXIT_STATUS=$?
>>>>>>> d6fc9c1852d38efd766c0e4c855b24458edcc1a2
