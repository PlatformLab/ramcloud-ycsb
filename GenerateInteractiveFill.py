#!/usr/bin/python

import os

# This script generates a file for smux to run YCSB clients interactively.


# We will fill a total of 10 million records using all available clients.
clients = ["ms0838","ms0922","ms0831","ms0926","ms0923","ms0845","ms0919","ms0803","ms0903","ms0837","ms1023","ms0828","ms0928","ms0807","ms0918","ms0907","ms0815","ms0927","ms0912","ms0936","ms0802","ms0806","ms1040","ms1006","ms0829","ms0909","ms0811","ms0930","ms0917","ms1012","ms0938","ms0808","ms1031","ms0902","ms0834","ms0945","ms1038","ms0929","ms0901","ms0818","ms0906","ms0934","ms0817","ms0937","ms0939","ms1020","ms1041"]
coordinator="basic+udp:host=128.110.153.76,port=12246"

TOTAL_RECORDS = 1e7
LOGS_DIR = "logs"

startIndex = 0

# smux header
print "PANES_PER_WINDOW = 30"
print "LAYOUT = tiled"

# We may wind up with a little less than 10 million, but that should be okay.
recordsPerClient = TOTAL_RECORDS / len(clients)
for client in clients:
    print '--------------------------------------------------'
    print 'ssh ' + client
    print 'cd ' + os.getcwd()
    print "sudo ./rc-ycsb.sh workloada %d %s %d %d > %s" % (10000000, coordinator, startIndex, recordsPerClient, os.path.join(LOGS_DIR, "fill." + client + ".log"))
    startIndex += recordsPerClient
