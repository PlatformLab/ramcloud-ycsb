/* Copyright (c) 2015 Stanford University
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR(S) DISCLAIM ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL AUTHORS BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#include <stdio.h>
#include <string.h>
#include <getopt.h>
#include <assert.h>

#include "ramcloud/PerfStats.h"
#include "ramcloud/RamCloud.h"

using namespace RAMCloud;

// This program performs various utility functions for the YCSB benchmark,
// such as creating messages in all of the servers' logs and collecting
// PerfStats data.

void printHelp(char* program) {
    printf("Usage:\n");
    printf("    %s coordinatorLocator getStats\n", program);
    printf("    %s coordinatorLocator logMessage level message\n", program);
    printf("    %s coordinatorLocator logTimeTrace\n", program);
}

int main(int argc, char *argv[])
    try
{
    // Set line buffering for stdout so that printf's and log messages
    // interleave properly.
    setvbuf(stdout, NULL, _IOLBF, 1024);
    
    if (argc < 3) {
        printHelp(argv[0]);
        exit(1);
    }

    const char *locator = argv[1];
    const char *command = argv[2];

    RamCloud cluster(locator, "__unnamed__");

    if (strcmp("getStats", command) == 0) {
        Buffer buffer;
        cluster.serverControlAll(WireFormat::ControlOp::GET_PERF_STATS,
                NULL, 0, &buffer);

        uint32_t pos = 0;
        WireFormat::ServerControlAll::Response *resp =
                buffer.getStart<WireFormat::ServerControlAll::Response>();
        pos += sizeof32(WireFormat::ServerControlAll::Response);

        char strBuf[1000];
        std::vector<std::string> outputs;
        const char *separator = "";
        for (int i = 0; i < resp->respCount; i++) {
            auto *resp =
                buffer.getOffset<WireFormat::ServerControl::Response>(pos);
            pos += sizeof32(WireFormat::ServerControl::Response);

            ServerId id(resp->serverId);
            if (resp->outputLength == sizeof(PerfStats)) {
                PerfStats *stats = buffer.getOffset<PerfStats>(pos);
                printf("%sserverId %u.%u\n", separator, id.indexNumber(),
                        id.generationNumber());
                printf("collectionTime %lu\n", stats->collectionTime);
                printf("cyclesPerSecond %g\n", stats->cyclesPerSecond);
                printf("readCount %lu\n", stats->readCount);
                printf("writeCount %lu\n", stats->writeCount);
                printf("dispatchActiveCycles %lu\n", stats->dispatchActiveCycles);
                printf("workerActiveCycles %lu\n", stats->workerActiveCycles);
                printf("compactorInputBytes %lu\n", stats->compactorInputBytes);
                printf("compactorSurvivorBytes %lu\n", stats->compactorSurvivorBytes);
                printf("compactorActiveCycles %lu\n", stats->compactorActiveCycles);
                printf("cleanerInputMemoryBytes %lu\n", stats->cleanerInputMemoryBytes);
                printf("cleanerInputDiskBytes %lu\n", stats->cleanerInputDiskBytes);
                printf("cleanerSurvivorBytes %lu\n", stats->cleanerSurvivorBytes);
                printf("cleanerActiveCycles %lu\n", stats->cleanerActiveCycles);
                printf("backupReadBytes %lu\n", stats->backupReadBytes);
                printf("backupReadActiveCycles %lu\n", stats->backupReadActiveCycles);
                printf("backupWriteBytes %lu\n", stats->backupWriteBytes);
                printf("backupWriteActiveCycles %lu\n", stats->backupWriteActiveCycles);
                printf("networkInputBytes %lu\n", stats->networkInputBytes);
                printf("networkOutputBytes %lu\n", stats->networkOutputBytes);
                printf("temp1 %lu\n", stats->temp1);
                printf("temp2 %lu\n", stats->temp2);
                printf("temp3 %lu\n", stats->temp3);
                printf("temp4 %lu\n", stats->temp4);
                printf("temp5 %lu\n", stats->temp5);
                separator = "\n";
            }

            pos += resp->outputLength;
        }
    } else if (strcmp("logMessage", command) == 0) {
        if (argc != 5) {
            printHelp(argv[0]);
            exit(1);
        }
        const char *levelArg = argv[3];
        const char *message = argv[4];
        LogLevel level;
        if (strcmp(levelArg, "DEBUG") == 0) {
            level = DEBUG;
        } else if (strcmp(levelArg, "NOTICE") == 0) {
            level = NOTICE;
        } else if (strcmp(levelArg, "WARNING") == 0) {
            level = WARNING;
        } else if (strcmp(levelArg, "ERROR") == 0) {
            level = ERROR;
        } else {
            printf("Unknown log level \"%s\"; must be DEBUG, NOTICE, "
                    "WARNING, or ERROR\n", levelArg);
            exit(1);
        }
        cluster.logMessageAll(level, "%s", message);
    } else if (strcmp("logTimeTrace", command) == 0) {
        cluster.serverControlAll(WireFormat::LOG_TIME_TRACE);
    } else {
        printHelp(argv[0]);
    }

    return 0;
} catch (RAMCloud::ClientException& e) {
    fprintf(stderr, "RAMCloud exception: %s\n", e.str().c_str());
    return 1;
} catch (RAMCloud::Exception& e) {
    fprintf(stderr, "RAMCloud exception: %s\n", e.str().c_str());
    return 1;
}
