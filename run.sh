#!/bin/sh
#
# This script runs one YCSB benchmark on a cluster that has already been
# set up.
#
# Arguments:
# workingDir:    the directory containing this script (and other scripts
#                related to running YCSB)
# logDir:        directory in which log files should be written
# coordLocator:  service locator for the RAMCloud coordinator
# workload:      which YCSB workload to run (e.g. "workloada")
# clientIds:    list of client machine numbers on which to run the benchmark
#                (e.g. "30", not "rc30")

if [ $# -ne 5 ]; then
  echo "Usage: run.sh workingDir logDir coordLocator workload clientIds"
  exit 1
fi

WD=$1
LOG_DIR=$2
COORD=$3
WORKLOAD=$4
CLIENTS=$5

# After this many seconds have elapsed in the benchmark, each server will
# be asked to dump a time trace to its log.
SECS_BEFORE_FIRST_TIME_TRACE_DUMP=50

# Files in which PerfStats are gathered for each server, both before
# and after the benchmark run.
PERF_BEFORE="$LOG_DIR/perfBefore.log"
PERF_AFTER="$LOG_DIR/perfAfter.log"

$WD/helper $COORD getStats > $PERF_BEFORE

# After this many seconds have elapsed in the benchmark, each server will
# be asked to dump a time trace to its log.
SECS_BEFORE_TIME_TRACE_DUMP=40

# Uncomment the following line to arrange for a time trace dumpn on
# all servers partway through the run
(sleep $SECS_BEFORE_TIME_TRACE_DUMP && $WD/helper $COORD logTimeTrace) &

# Find the last client name, so we can treat it specially.
for CLIENT in $CLIENTS; do LAST_CLIENT=$CLIENT; done

LOGS=""
for CLIENT in $CLIENTS; do
  LOG=$LOG_DIR/client-rc$CLIENT.log
  LOGS="$LOGS $LOG"
  if [ $CLIENT == $LAST_CLIENT ]; then
    ssh rc$CLIENT sh $WD/rc-ycsb.sh ${WORKLOAD} 10000000 $COORD \
         > $LOG_DIR/client-rc$CLIENT.log 2>&1
  else
    ssh rc$CLIENT sh $WD/rc-ycsb.sh ${WORKLOAD} 10000000 $COORD \
        > $LOG_DIR/client-rc$CLIENT.log 2>&1 &
  fi
  usleep 1000
done

$WD/helper $COORD getStats > $PERF_AFTER
$WD/diffPerfStats.py $PERF_BEFORE $PERF_AFTER > $LOG_DIR/perfStats

./waitClients.sh $LOGS
