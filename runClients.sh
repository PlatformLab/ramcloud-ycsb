# This script runs the CLIENTs for YCSB workloads; use InteractiveFill.mux for
# pre-filling the data store.

if [ $# -ne 1 ]; then
  >&2 echo "Usage: $0 workloadletter"
  exit 1
fi

COORD_LOCATOR="basic+udp:host=128.110.153.76,port=12246"
CLIENTS="ms0838 ms0922 ms0831 ms0926 ms0923 ms0845 ms0919 ms0803 ms0903 ms0837 ms1023 ms0828 ms0928 ms0807 ms0918 ms0907 ms0815 ms0927 ms0912 ms0936 ms0802 ms0806 ms1040 ms1006 ms0829 ms0909 ms0811 ms0930 ms0917 ms1012 ms0938 ms0808 ms1031 ms0902 ms0834 ms0945 ms1038 ms0929 ms0901 ms0818 ms0906 ms0934 ms0817 ms0937 ms0939 ms1020 ms1041"

WORKLOAD=$1

# Clean clients when receive SIGINT
function sigint_handler() {
  for s in $CLIENTS; do
    echo "Stop client: $s"
    ssh $s sudo pkill java
    ssh $s sudo rm -f /dev/hugepages/*
  done
  exit 0
}
trap 'sigint_handler' 2

# Manually clean up any previous clients and their huge pages, just in case.
sigint_handler

# Find the last CLIENT name, so we can treat it specially.
for CLIENT in $CLIENTS; do LAST_CLIENT=$CLIENT; done
echo $LAST_CLIENT

# Run the workload (possibly fill) specified on the command line and wait until
# completion.

echo "Running workload $WORKLOAD for run $RUN..."
# Set up a server-side log that we're starting the workload.
./helper $COORD_LOCATOR logMessage NOTICE \
  "**** Running workload $WORKLOAD"

# Track the logs for waiting
LOGS=""
# Actually start workload on each client.
for CLIENT in $CLIENTS; do

    ERR_FILE="logs/workload${WORKLOAD}.${CLIENT}.stderr"
    LOG_FILE="logs/workload${WORKLOAD}.${CLIENT}.log"
    LOGS="$LOGS $LOG_FILE"

    CMD="cd /shome/ramcloud-ycsb; sudo ./rc-ycsb.sh workload${WORKLOAD} 10000000 basic+udp:host=128.110.153.76,port=12246 > ${LOG_FILE} 2> ${ERR_FILE}"

    echo "Starting CLIENT on $CLIENT"
    if [ $CLIENT == $LAST_CLIENT ]; then
     ssh $CLIENT "$CMD"
    else
     ssh $CLIENT "$CMD" &
    fi

done

# Wait for CLIENTs to finish
echo $LOGS
./waitClients.sh $LOGS

# Wait a little longer; writing log messages doesn't mean fully exited.
sleep 5

# Log that we've finished the workload on the server side.
./helper $COORD_LOCATOR logMessage NOTICE "**** Workloads finished"

# Print summary throughput.
grep OVERALL $LOGS | grep Throughput | awk '{sum+=$3} END{print sum}'
