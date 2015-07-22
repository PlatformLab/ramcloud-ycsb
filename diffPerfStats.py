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
Usage: diffPerfStats.py beforeStats afterStats
Given the names of two files containing PerfStat output as generated
by "helper getStats" at different times, this script will compute the
changes in the stats and output them in a human-readable format.
"""

import glob
import math
import re
import sys
import string

def readFile(file):
    """
    Returns a two-level dictionary containing the performance stats from
    one file. The top-level dictionary has one entry for each server,
    indexed by server id. This entry is itself a dictionary, containing
    one entry for each performance statistic
    """
    result = {}
    curServer = None
    for line in open(file):
        if line[0] == "#":
            continue
        words = line.split();
        if len(words) != 2:
            if len(words) != 0:
                print("Unrecognized line: %s" % (line))
            continue
        name = words[0]
        value = float(words[1])
        if name == "serverId":
            curServer = {}
            result[value] = curServer
            continue
        if curServer == None:
            print("Skipping \"%s\" value: serverId must come first" % (name))
        curServer[name] = value
    return result

def difference(stats1, stats2):
    """
    Given the results from two calls to readFile, returns the difference
    between them (a top-level dictionary with one entry for each server,
    whose value is a dictionary of the differences).
    """
    result = {}
    for serverName in stats1.keys():
        if not serverName in stats2:
            print("Missing data for server %s in second file" % (serverName))
            continue
        server1 = stats1[serverName]
        server2 = stats2[serverName]
        diffs = {}
        for key in server1:
            if not key in server2:
                print("Missing data for %s for server %s in second file" %
                        (key, serverName))
                continue
            diffs[key] = server2[key] - server1[key]
        result[serverName] = diffs
    return result

if len(sys.argv) != 3:
    print("Usage: %s statsBefore statsAfter" % (sys.argv[0]))
    exit(1)

data1 = readFile(sys.argv[1])
data2 = readFile(sys.argv[2])
servers = difference(data1, data2)
print("server  time   reads   writes   reads   writes   disp.  worker  netIn  netOut")
print("        (s)   (Mops)   (Mops)  (kOp/s)  (kOp/s) utiliz.  cores  (MB/s) (MB/s)")
for serverName in sorted(servers.keys()):
    stats = servers[serverName]
    cyclesPerSecond = data1[serverName]["cyclesPerSecond"]
    elapsedSeconds = stats["collectionTime"]/cyclesPerSecond
    print("%s %7.2f %7.2f  %7.2f %7.1f  %7.1f %6.2f  %6.2f %7.1f %7.1f" % (
            serverName,
            stats["collectionTime"]/cyclesPerSecond,
            stats["readCount"]/1e6,
            stats["writeCount"]/1e6,
            (stats["readCount"]/elapsedSeconds)/1e3,
            (stats["writeCount"]/elapsedSeconds)/1e3,
            stats["dispatchActiveCycles"]/stats["collectionTime"],
            stats["workerActiveCycles"]/stats["collectionTime"],
            (stats["networkInputBytes"]/elapsedSeconds)/1e6,
            (stats["networkOutputBytes"]/elapsedSeconds)/1e6
            ))

print("")
print("server  compactor cleaner compactor cleaner cleanerIO")
print("          cores    cores   utiliz.  utiliz.   (MB/s) ")
for serverName in sorted(servers.keys()):
    stats = servers[serverName]
    cyclesPerSecond = data1[serverName]["cyclesPerSecond"]
    elapsedSeconds = stats["collectionTime"]/cyclesPerSecond
    compactorUtiliz = 0.0
    if stats["compactorInputBytes"] > 0:
        compactorUtiliz = (stats["compactorSurvivorBytes"] /
                stats["compactorInputBytes"])
    cleanerUtiliz = 0.0
    if stats["cleanerInputDiskBytes"] > 0:
        cleanerUtiliz = (stats["cleanerSurvivorBytes"] /
                stats["cleanerInputDiskBytes"])
    print("%s    %6.2f   %6.2f   %6.2f   %6.2f   %7.1f" % (
            serverName,
            stats["compactorActiveCycles"]/stats["collectionTime"],
            stats["cleanerActiveCycles"]/stats["collectionTime"],
            compactorUtiliz,
            cleanerUtiliz,
            (stats["cleanerSurvivorBytes"]/elapsedSeconds)/1e6
            ))

print("")
print("server  diskIn  diskIn  diskOut  diskOut   temp1  temp2  temp3  temp4")
print("        (MB/s)  active   (MB/s)   active   (M/s)   (K)   (M/s)   (K)")
for serverName in sorted(servers.keys()):
    stats = servers[serverName]
    cyclesPerSecond = data1[serverName]["cyclesPerSecond"]
    elapsedSeconds = stats["collectionTime"]/cyclesPerSecond
    print("%s   %7.1f %6.2f   %7.1f   %6.2f %7.1f%7.1f%7.1f%7.1f" % (
            serverName,
            (stats["backupReadBytes"]/elapsedSeconds)/1e6,
            stats["backupReadActiveCycles"]/stats["collectionTime"],
            (stats["backupWriteBytes"]/elapsedSeconds)/1e6,
            stats["backupWriteActiveCycles"]/stats["collectionTime"],
            (stats["temp1"]/elapsedSeconds)/1e6,
            stats["temp2"]/1e3,
            (stats["temp3"]/elapsedSeconds)/1e6,
            stats["temp4"]/1e3
            ))
