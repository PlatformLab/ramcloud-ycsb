#!/bin/sh
# This script runs a single YCSB client on a previously setup RAMCloud cluster.

if [ $# -ne 3 -a $# -ne 5 ]; then
  echo "Usage: $0 workload records coordLocator [insertstart insertcount]"
  exit 1
fi

WORKLOAD=$1
RECORDS=$2
COORD=$3

if [ $# -eq 5 ]; then
  INSERT_START=$4
  INSERT_COUNT=$5
  echo "Insert Start: $INSERT_START, Insert Count: $INSERT_COUNT"
fi

THREADS=8

echo "Workload: $WORKLOAD, Records: $RECORDS, Output: $OUTPUT"

echo "Using Coordinator at $COORD"

export LD_LIBRARY_PATH=/usr/local/lib:/home/ouster/remote/ramcloud/bindings/java/bin/edu/stanford/ramcloud:/home/ouster/remote/ramcloud/obj.master/:/home/ouster/remote/ramcloud/bindings/java/lib
# export LD_LIBRARY_PATH=/usr/local/lib:/home/rumble/ramcloud/bindings/java/edu/stanford/ramcloud:/home/rumble/ramcloud/obj.master
cd /home/syang0/YCSB

DB=com.yahoo.ycsb.db.RamCloudClient
if [ "$INSERT_COUNT" == "" ]; then
  java -cp /home/rumble/YCSB/dynamodb/conf:/home/rumble/YCSB/hbase/src/main/conf:/home/rumble/YCSB/infinispan/src/main/conf:/home/rumble/YCSB/voldemort/src/main/conf:/home/rumble/YCSB/nosqldb/src/main/conf:/home/rumble/YCSB/gemfire/src/main/conf:/home/rumble/YCSB/core/target/core-0.1.4.jar:/home/rumble/YCSB/jdbc/src/main/conf:/home/syang0/YCSB/ramcloud/src/main/java:/home/ouster/remote/ramcloud/bindings/java/bin:/home/rumble/hyperdex/installed/share/java/hyperclient-ycsb-1.0.rc4.jar:/home/rumble/hyperdex/installed/share/java/hyperclient-1.0.rc4.jar com.yahoo.ycsb.Client -db $DB -P workloads/${WORKLOAD} -t -p ramcloud.coordinatorLocator=${COORD} -p ramcloud.tableServerSpan=24 -p recordcount=${RECORDS} -p operationcount=${RECORDS} -threads $THREADS -p requestdistribution=uniform
else
  java -cp /home/rumble/YCSB/dynamodb/conf:/home/rumble/YCSB/hbase/src/main/conf:/home/rumble/YCSB/infinispan/src/main/conf:/home/rumble/YCSB/voldemort/src/main/conf:/home/rumble/YCSB/nosqldb/src/main/conf:/home/rumble/YCSB/gemfire/src/main/conf:/home/rumble/YCSB/core/target/core-0.1.4.jar:/home/rumble/YCSB/jdbc/src/main/conf:/home/syang0/YCSB/ramcloud/src/main/java:/home/ouster/remote/ramcloud/bindings/java/bin:/home/rumble/hyperdex/installed/share/java/hyperclient-ycsb-1.0.rc4.jar:/home/rumble/hyperdex/installed/share/java/hyperclient-1.0.rc4.jar com.yahoo.ycsb.Client -db $DB -P workloads/${WORKLOAD} -load -p ramcloud.coordinatorLocator=${COORD} -p ramcloud.tableServerSpan=24 -p recordcount=${RECORDS} -p operationcount=${RECORDS} -p insertstart=${INSERT_START} -p insertcount=${INSERT_COUNT} -threads 8
fi
