#!/usr/bin/python

import os
import sys

# This script generates a file for smux to run YCSB clients interactively.

# We will fill a total of 10 million records using all available clients.
# Note that this list must change depending on the environment run in. For
# CloudLab with DPDK, it must point at either the control-network names or the
# control-network IP addresses.
clients = ["ms0838","ms0922","ms0831","ms0926","ms0923","ms0845","ms0919","ms0803","ms0903","ms0837","ms1023","ms0828","ms0928","ms0807","ms0918","ms0907","ms0815","ms0927","ms0912","ms0936","ms0802","ms0806","ms1040","ms1006","ms0829","ms0909","ms0811","ms0930","ms0917","ms1012","ms0938","ms0808","ms1031","ms0902","ms0834","ms0945","ms1038","ms0929","ms0901","ms0818","ms0906","ms0934","ms0817","ms0937","ms0939","ms1020","ms1041"]
coordinator="basic+udp:host=128.110.153.76,port=12246"
TOTAL_RECORDS = int(1e7)
LOGS_DIR = "logs"

def generateInteractiveFill():
    startIndex = 0
    # smux header
    print "PANES_PER_WINDOW = 30"
    print "LAYOUT = tiled"

    # We may wind up with a little less than 10 million, but that should be okay.
    recordsPerClient = TOTAL_RECORDS / len(clients)
    for client in clients:
        logFile = os.path.join(LOGS_DIR, "fill.%s.log" % client)
        print '--------------------------------------------------'
        print 'ssh ' + client
        print 'cd ' + os.getcwd()
        print "sudo ./rc-ycsb.sh workloada %d %s %d %d > %s" % (TOTAL_RECORDS, coordinator, startIndex, recordsPerClient, logFile)
        startIndex += recordsPerClient

def generateWorkload(x):
    # smux header
    print "PANES_PER_WINDOW = 30"
    print "LAYOUT = tiled"

    for client in clients:
        logFile = os.path.join(LOGS_DIR, "workload%s.%s.log" % (x, client))
        print '--------------------------------------------------'
        print 'ssh ' + client
        print 'cd ' + os.getcwd()
        print "sudo ./rc-ycsb.sh workload%s %d %s > %s" % (x, TOTAL_RECORDS, coordinator, logFile)


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
