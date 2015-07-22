#!/usr/bin/env python
# Copyright (c) 2015 Stanford University
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR(S) DISCLAIM ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL AUTHORS BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

"""
This program reads log files from a collection of directories and
extracts overall performance information.

It is invoked with one argument, giving the name of a top-level
log directory, which must have been created by runYcsb.
"""

import glob
import math
import re
import sys
import string

def scanRuns(logDir, transport, memorySize, clientCount):
    """
    This method scans all of the runs for a particular configuration and
    prints summary statistics for each YCSB benchmark across all the runs.
    """

    print("Throughput for transport %s, memory size %s, %d clients:" %
            (transport, memorySize, clientCount))
    print("Workload Runs   Average      Min      Max")
    for workload in ["a", "b", "c", "d", "f"]:
        totals = []
        for run in range(1, 1000):
            # Get a list of the log file names for all of the clients
            # in this run.
            logs = glob.glob('%s/%s_%d_%dclients_run%d/workload%s/*client*.log'
                    % (logDir, transport, memorySize, clientCount,
                    run, workload))
            if len(logs) == 0:
                break;

            # Scan the client log files to sum the throughputs observed
            # by each client.
            total = 0.0
            for log in logs:
                foundData = 0
                for line in open(log):
                    match = re.match(
                        '.*OVERALL.*Throughput.*, ([0-9.]+).*', line)
                    if not match:
                        continue
                    value = float(match.group(1))/1e3
                    total += value
                    foundData = 1
                    break
                if not foundData:
                    print("Log file %s contained no throughput data" % (log))
            totals.append(total)
        if len(totals) > 0:
            print("%s   %8d   %8.1f %8.1f %8.1f" % (workload, len(totals),
                    sum(totals)/len(totals), min(totals), max(totals)))

if len(sys.argv) < 2:
    print("Usage: %s logDirectory" % (sys.argv[0]))
    exit(1)

# First, figure out the range of data that is available (transports,
# different memory sizes, number of clients).

transports = []
memorySizes = []
clientCounts = []

logDirs = glob.glob('%s/*' % (sys.argv[1]))
for dir in logDirs:
    match = re.match('[^_]*/([^_]+)_([0-9]+)_([0-9]+)clients_run([0-9]+)', dir)
    if not match:
        continue
    transport = match.group(1)
    if transports.count(transport) == 0:
        transports.append(transport)
    memorySize = int(match.group(2))
    clientCount = int(match.group(3))
    run = int(match.group(4))
    if memorySizes.count(memorySize) == 0:
        memorySizes.append(memorySize)
    if clientCounts.count(clientCount) == 0:
        clientCounts.append(clientCount)

transports.sort();
memorySizes.sort();
clientCounts.sort();

firstChunk = 1
for transport in transports:
    for memorySize in memorySizes:
        for clientCount in clientCounts:
            if not firstChunk:
                print("")
            else:
                firstChunk = 0
            scanRuns(sys.argv[1], transport, memorySize, clientCount)
