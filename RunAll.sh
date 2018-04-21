#!/bin/bash

./BatchFill.sh && \
./runClients.sh a >> Results.txt && \
./runClients.sh b >> Results.txt && \
./runClients.sh c >> Results.txt && \
./runClients.sh f >> Results.txt && \
./runClients.sh d >> Results.txt
