#!/bin/bash

# This script runs the CLIENTs for YCSB workloads; use InteractiveFill.mux for
# pre-filling the data store.

if [ $# -lt 1 ]; then
  >&2 echo "Usage: $0 workloadletter"
  exit 1
fi

source clusterInfo.sh

TIME=$(date +%Y%m%d%H%M%S)

mkdir -p ${LOG_DIR}

WORKLOAD=$1
NUM_CLIENTS=$2

# If a number of clients is specified, then it overwrites the number available.
if [[ -n "$NUM_CLIENTS" ]]; then
    IFS='  ' read -r -a clientarray <<< "$CLIENTS"
    CLIENTS=$(echo "${clientarray[@]:0:$NUM_CLIENTS}")
fi

function clean_clients() {
  >&2 echo "Stoping any previous client... "
  for s in $CLIENTS; do
    ssh $s sudo pkill java
    ssh $s sudo rm -f /dev/hugepages/*
  done
  >&2 echo "Finished stopping client... "
}

# Clean clients when receive SIGINT
function sigint_handler() {
  trap - 2
  >&2 echo "Got SIGINT... "
  clean_clients
  exit 1
}
trap 'sigint_handler' 2

# Manually clean up any previous clients and their huge pages, just in case.
clean_clients

# Files in which PerfStats are gathered for each server, both before
# and after the benchmark run.
PERF_BEFORE="$LOG_DIR/perfBefore.log"
PERF_AFTER="$LOG_DIR/perfAfter.log"

# Gather PerfStats before running the experiment.
sudo ./helper $COORD_LOCATOR getStats > $PERF_BEFORE

# Find the last CLIENT name, so we can treat it specially.
for CLIENT in $CLIENTS; do LAST_CLIENT=$CLIENT; done

# Run the workload specified on the command line and wait until completion.
>&2 echo "Running workload $WORKLOAD for run $RUN..."
# Set up a server-side log that we're starting the workload.
sudo ./helper $COORD_LOCATOR logMessage NOTICE \
  "**** Running workload $WORKLOAD"

# Ask all servers to dump a TimeTrace roughly 40 seconds into the experiment.
sudo ./helper $COORD_LOCATOR logTimeTrace 40 &
ttlogpid=$!

# Track the logs for statistics
LOGS=""
# Actually start workload on each client.
>&2 echo "Starting clients..."
for CLIENT in $CLIENTS; do

    ERR_FILE="logs/workload${WORKLOAD}.${CLIENT}.stderr"
    LOG_FILE="logs/workload${WORKLOAD}.${CLIENT}.log"
    LOGS="$LOGS $LOG_FILE"

    CMD="cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workload${WORKLOAD} 10000000 ${COORD_LOCATOR} > ${LOG_FILE} 2> ${ERR_FILE}"

    if [ $CLIENT == $LAST_CLIENT ]; then
     ssh $CLIENT "$CMD"
    else
     ssh $CLIENT "$CMD" &
    fi

done

# Wait for the ttlogger to finish before dumping PerfStats because dpdk doesn't
# allow multiple applications to run simulatneously without special
# configuration.
wait $ttlogpid

# Dump the PerfStats when at least one client has finished.
sudo ./helper $COORD_LOCATOR getStats > $PERF_AFTER
./diffPerfStats.py $PERF_BEFORE $PERF_AFTER > $LOG_DIR/perfStats

# Wait for CLIENTs to finish
wait
./waitClients.sh $LOGS

# Log that we've finished the workload on the server side.
sudo ./helper $COORD_LOCATOR logMessage NOTICE "**** Workload finished"

# Print summary throughput.
overallThroughput=$(grep OVERALL $LOGS | grep Throughput | awk '{sum+=$3} END{print sum}')
echo "Workload${WORKLOAD} Throughout: ${overallThroughput} qps"

# Move the logs directory to a new location to prevent overwriting of
# PerfStats. This is a hack around the fact that we hardcoded the directory
# name logs in several places, but it should be effective before the deadline.
mv "$LOG_DIR" "${LOG_DIR}_workload${WORKLOAD}_${TIME}"
ln -s "${LOG_DIR}_workload${WORKLOAD}_${TIME}" latest
