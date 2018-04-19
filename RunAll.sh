#!/bin/bash

./BatchFill.sh 2> /tmp/Fill.stderr && \
./runClients.sh a >> Results.txt && \
./runClients.sh b >> Results.txt && \
./runClients.sh c >> Results.txt && \
./runClients.sh d >> Results.txt && \
./runClients.sh f >> Results.txt && \
./runClients.sh a >> Results.txt && \
./runClients.sh b >> Results.txt && \
./runClients.sh c >> Results.txt && \
./runClients.sh d >> Results.txt && \
./runClients.sh f >> Results.txt
