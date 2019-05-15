#!/bin/bash

# This script should be set as cron job
# Usage:
#   ./run_by_cron.sh <TARGET> <IMAGE> <BENCHMARK> <target_id> <commit>
#   <BENCHMARK> should contain no '/' at its end


SCRIPT_DIR="$( cd ${BASH_SOURCE[0]%/*} ; echo $PWD )"
source "${SCRIPT_DIR}/ci_defaults.sh"
set -x
set -e
set -o pipefail

TARGET=$1
IMAGE=$2
BENCHMARK_TARGET=$3
TARGET_ID=$4
COMMIT=$5
TARGET_IMAGE="${IMAGE}:16.04"

BENCH_SMALL="$(echo ${BENCHMARK_TARGET} | tr '[:upper:]' '[:lower:]')"
TAG_NAME="${TARGET}-${BENCH_SMALL}-tmp"
TMP_IMAGE="${TAG_NAME}-tmp:16.04"

# Build an image, remove it when all done
# Install benchmarks to image

cd ${SCRIPT_DIR}/../

BENCHMARK_DOCKER_FILE="${DOCKER_FILE_DIR}/install_benchmarks.Dockerfile"
${SCRIPT_DIR}/check_image_exsist.sh ${TAG_NAME}
docker build \
  -m 4g \
  -f "${BENCHMARK_DOCKER_FILE}" \
  -q \
  -t "${TMP_IMAGE}" \
  "--build-arg" \
  "DOCKER_IMAGE_BASE=${TARGET_IMAGE}" \
  .

docker run --rm -a STDOUT -a STDERR --name ${TAG_NAME} ${TMP_IMAGE} \
"${BENCHMARK_PATH}/ci_run.sh" ${TARGET} ${BENCHMARK_TARGET} \
> "${OUTPUT_DIR}/${TARGET}.${BENCHMARK_TARGET}.log"

# Write results to postgresql
python3 ${SCRIPT_DIR}/write_log_to_db.py ${TARGET_ID} ${TARGET} ${BENCHMARK_TARGET} ${COMMIT}

docker rmi ${TMP_IMAGE} 
