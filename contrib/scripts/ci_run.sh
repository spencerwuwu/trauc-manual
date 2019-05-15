#!/bin/bash

# Executed within Container
# COPY while installing benchmarks
TARGET=$1
BENCHMARK_TARGET=$2
cd ${BENCHMARK_PATH}/

DATE=$(date "+%Y%m%d")
python3.6 check_benchmark -c=$TARGET "${BENCHMARK_TARGET}/" > /dev/null

chmod 666 -R trace/
sshpass -p $PASSWD scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -r trace deploy@10.32.0.255:/home/deploy/traces/${TARGET}.${DATE}.${BENCHMARK_TARGET}


cat ${BENCHMARK_TARGET}.${DATE}.${TARGET}.log
echo "LOG.ERR:"
cat ${BENCHMARK_TARGET}.${DATE}.${TARGET}.log.err
echo "LOG.END:"
python3.6 compare_benchmark_logs $BENCHMARK_TARGET
