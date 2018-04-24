#!/bin/bash
# This script runs a single YCSB client on a previously setup RAMCloud cluster.

if [ $# -ne 3 -a $# -ne 5 ]; then
  >&2 echo "Usage: $0 workload records coordLocator throughput [insertstart insertcount]"
  exit 1
fi

WORKLOAD=$1
RECORDS=$2
COORD=$3
RUNNING_TIME=60

DIR=$(readlink -f $(dirname $0))
RCLOGDIR=$DIR/logs
cd $DIR/YCSB

if [ $# -eq 5 ]; then
  INSERT_START=$4
  INSERT_COUNT=$5
  echo "Insert Start: $INSERT_START, Insert Count: $INSERT_COUNT"
fi

echo "Workload: $WORKLOAD, Records: $RECORDS, Output: $OUTPUT"

echo "Using Coordinator at $COORD"

export LD_LIBRARY_PATH=/usr/local/lib
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$DIR/ramcloud/bin
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$DIR/bin/
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$DIR/ramcloud/lib/ramcloud

CP="$DIR/YCSB/dynamodb/conf"
CP="$CP:$DIR/YCSB/hbase/src/main/conf"
CP="$CP:$DIR/YCSB/infinispan/src/main/conf"
CP="$CP:$DIR/YCSB/voldemort/src/main/conf"
CP="$CP:$DIR/YCSB/nosqldb/src/main/conf"
CP="$CP:$DIR/YCSB/gemfire/src/main/conf"
CP="$CP:$DIR/YCSB/core/target/core-0.1.4.jar"
CP="$CP:$DIR/YCSB/jdbc/src/main/conf"
CP="$CP:$DIR/YCSB/ramcloud/src/main/java"
CP="$CP:$DIR/ramcloud/lib/ramcloud/ramcloud.jar"
export CP

DB=com.yahoo.ycsb.db.RamCloudClient
if [ "$INSERT_COUNT" = "" ]; then
 java -cp $CP com.yahoo.ycsb.Client -db $DB \
      -P workloads/${WORKLOAD}  \
      -p ramcloud.coordinatorLocator=${COORD} \
      -p ramcloud.tableServerSpan=12 \
      -p ramcloud.logFile=${RCLOGDIR}/rcclient-$(hostname -A | awk -F. '{print $1}').log \
      -p recordcount=${RECORDS} \
      -p operationcount=100000000 \
      -p maxexecutiontime=${RUNNING_TIME} \
      -p requestdistribution=uniform \
      -threads 8 \
      -t \
      -s
else
 java -cp $CP com.yahoo.ycsb.Client -db $DB \
      -P workloads/${WORKLOAD} -load \
      -p ramcloud.coordinatorLocator=${COORD} \
      -p ramcloud.tableServerSpan=12 \
      -p ramcloud.logFile=${RCLOGDIR}/rcclient-$(hostname -A | awk -F. '{print $1}').log \
      -p recordcount=${RECORDS} \
      -p insertstart=${INSERT_START} \
      -p insertcount=${INSERT_COUNT} \
      -threads 8 \
      -s
fi
