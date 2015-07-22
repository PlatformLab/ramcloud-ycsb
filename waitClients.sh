#!/bin/sh
#
# This shell script waits for one or more YCSB clients to finish
# processing. If they don't finish within a reasonable amount of time,
# it generates an error message.
#
# Usage: waitClients log log log ...
# Each argument is the name of a log file which will contain information
# indicating proper completion.

for ((COUNT=30; COUNT>0; COUNT--)); do
  STATUS=ok
  for LOG in $*; do
    LINES=`grep -c OVERALL $LOG`
    if [ $LINES -ne 2 ]; then
      STATUS=problem
      if [ $COUNT -eq 1 ]; then
        echo "WARNING: client appears not to have completed "
            "successfully; check $LOG"
      fi
    fi
  done
  if [ $STATUS == ok ]; then exit 0; fi
  if [ $COUNT -lt 20 ]; then
      echo "Some clients not finished; waiting..."
  fi
  sleep 1
done
exit 1
