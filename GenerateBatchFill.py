#!/usr/bin/python

import os
import sys

# This script generates a file for smux to run YCSB clients interactively.

# We will fill a total of 10 million records using all available clients.
# Note that this list must change depending on the environment run in. For
# CloudLab with DPDK, it must point at either the control-network names or the
# control-network IP addresses.
clients = ["ms0903", "ms0918", "ms0907", "ms0927", "ms0912", "ms0936", "ms0909", "ms0930", "ms0917", "ms0938", "ms0902", "ms0945", "ms0929", "ms0901", "ms0906", "ms0934", "ms0937",  "ms1003",  "ms1035",  "ms1023", "ms1040", "ms1006", "ms1012",  "ms1031",  "ms1038", "ms1020", "ms1041"]
coordinator="basic+udp:host=128.110.153.147,port=12246"
TOTAL_RECORDS = int(1e7)
LOGS_DIR = "logs"

def generateBatchFill():
    startIndex = 0
    print '>&2 echo "Batch filling..."'
    print "mkdir -p logs"

    # We may wind up with a little less than 10 million, but that should be okay.
    recordsPerClient = TOTAL_RECORDS / len(clients)
    for client in clients:
        logFile = os.path.join(LOGS_DIR, "fill.%s.log" % client)
        errFile =  os.path.join(LOGS_DIR, "fill.%s.stderr" % client)
        outLine = 'ssh %s "' % client
        outLine += 'cd %s; ' % os.getcwd()
        outLine += 'sudo ./rc-ycsb.sh workloada %d %s %d %d > %s 2> %s' % (TOTAL_RECORDS, coordinator, startIndex, recordsPerClient, logFile, errFile)
        outLine += '"'
        if client != clients[-1]:
            outLine += ' &'
        print outLine
        startIndex += recordsPerClient
    print "wait"


if __name__ == "__main__":
    generateBatchFill()
