#!/usr/bin/python

import os
import sys

from clusterInfo import *

# This script generates a file for smux to run YCSB clients interactively.

# We will fill a total of 10 million records using all available clients.
# For CloudLab with DPDK, clients must point at either the control-network
# names or the control-network IP addresses.

def generateBatchFill():
    startIndex = 0
    print '>&2 echo "Batch filling..."'
    print "mkdir -p logs"

    # We may wind up with a little less than 10 million, but that should be okay.
    recordsPerClient = TOTAL_RECORDS / len(CLIENTS)
    for client in CLIENTS:
        logFile = os.path.join(LOG_DIR, "fill.%s.log" % client)
        errFile =  os.path.join(LOG_DIR, "fill.%s.stderr" % client)
        outLine = 'ssh %s "' % client
        outLine += 'cd %s; ' % os.getcwd()
        outLine += 'sudo ./rc-ycsb.sh workloada %d %s %d %d > %s 2> %s' % (TOTAL_RECORDS, COORD_LOCATOR, startIndex, recordsPerClient, logFile, errFile)
        outLine += '"'
        if client != CLIENTS[-1]:
            outLine += ' &'
        print outLine
        startIndex += recordsPerClient
    print "wait"


if __name__ == "__main__":
    generateBatchFill()
