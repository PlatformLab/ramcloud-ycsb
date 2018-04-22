#!/usr/bin/python

import os
import sys

from clusterInfo import *

# This script generates a file for smux to run YCSB clients interactively.

# We will fill a total of 10 million records using all available clients.
# Note that this list must change depending on the environment run in. For
# CloudLab with DPDK, it must point at either the control-network names or the
# control-network IP addresses.

def generateInteractiveFill():
    startIndex = 0
    # smux header
    print "PANES_PER_WINDOW = 30"
    print "LAYOUT = tiled"

    # We may wind up with a little less than 10 million, but that should be okay.
    recordsPerClient = TOTAL_RECORDS / len(CLIENTS)
    for client in CLIENTS:
        logFile = os.path.join(LOG_DIR, "fill.%s.log" % client)
        print '--------------------------------------------------'
        print 'ssh ' + client
        print 'cd ' + os.getcwd()
        print "sudo ./rc-ycsb.sh workloada %d %s %d %d > %s" % (TOTAL_RECORDS, COORD_LOCATOR, startIndex, recordsPerClient, logFile)
        startIndex += recordsPerClient

def generateWorkload(x):
    # smux header
    print "PANES_PER_WINDOW = 30"
    print "LAYOUT = tiled"

    for client in CLIENTS:
        logFile = os.path.join(LOG_DIR, "workload%s.%s.log" % (x, client))
        print '--------------------------------------------------'
        print 'ssh ' + client
        print 'cd ' + os.getcwd()
        print "sudo ./rc-ycsb.sh workload%s %d %s > %s" % (x, TOTAL_RECORDS, COORD_LOCATOR, logFile)


def main():
    if len(sys.argv) < 2:
        print "Usage: %s <workload|fill>" % sys.argv[0]
        exit(1)
    workload = sys.argv[1]

    if workload == 'fill':
        generateInteractiveFill()
    else:
        assert workload in ('a', 'b', 'c', 'd', 'f')
        generateWorkload(workload)

if __name__ == "__main__":
    main()



