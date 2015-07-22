#!/bin/sh
#
# This shell script uses YCSB benchmark A to load the database for YCSB.

if [ $# -ne 4 ]; then
  echo "Usage: fill.sh wd coordLocator logDir clientIds"
  exit 1
fi

WD=$1
COORD=$2
LOG_DIR=$3
CLIENTS=$4

LOGS=""
START="0"
for CLIENT in $CLIENTS; do LAST_CLIENT=$CLIENT; done
for CLIENT in $CLIENTS; do
  LOG=$LOG_DIR/fill-rc$CLIENT.log
  LOGS="$LOGS $LOG"
  if (($CLIENT == $LAST_CLIENT)); then
    ssh rc$CLIENT \
        $WD/rc-ycsb.sh workloada \
        10000000 \
        $COORD \
        $START \
        1000000 > $LOG 2>&1
  else
    ssh rc$CLIENT \
        $WD/rc-ycsb.sh workloada \
        10000000 \
        $COORD \
        $START \
        1000000 > $LOG 2>&1 &
  fi
  ((START=START+1000000))
  usleep 10000
  done

./waitClients.sh $LOGS