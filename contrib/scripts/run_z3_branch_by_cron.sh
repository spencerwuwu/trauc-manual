#!/bin/bash

# This script should be set as cron job
# Usage:
#   ./run_z3_branch_as_cron.sh <BENCHMARK> <Target_id>
#   <BENCHMARK> should contain no '/' at its end

TARGET=trauc
BENCHMARK=$1
TARGET_ID=$2
REPO_URL=https://github.com/guluchen/z3.git 
BRANCH=master

SCRIPT_DIR="$( cd ${BASH_SOURCE[0]%/*} ; echo $PWD )"
source "${SCRIPT_DIR}/ci_defaults.sh"
source "${SCRIPT_DIR}/get_commit.sh"
set -x
set -e
set -o pipefail

# Get the latest commit hash
get_commit

# Build an image with <repo_url> <branch> installed
BUILD_OPTS=()
BUILD_OPTS+=("--build-arg" "SCRIPT=install_z3_branch.sh")
BUILD_OPTS+=("--build-arg" "SCRIPT_ARGS=$REPO_URL $BRANCH $TARGET")
BENCH_SMALL="$(echo ${BENCHMARK} | tr '[:upper:]' '[:lower:]')"
TARGET_IMAGE="${BENCH_SMALL}:16.04"

${SCRIPT_DIR}/check_image_exsist.sh ${TARGET}

cd ${SCRIPT_DIR}/../

docker build \
  -m 4g \
  -q \
  -f "${S_SCRIPT_DOCKER_FILE}" \
  -t "${TARGET_IMAGE}" \
  "--build-arg" \
  "DOCKER_IMAGE_BASE=${BASE_IMAGE_NAME}" \
  "${BUILD_OPTS[@]}" \
  .

# Run run_by_cron.sh with this image
${SCRIPT_DIR}/run_by_cron.sh ${TARGET} ${BENCH_SMALL} ${BENCHMARK} ${TARGET_ID} ${COMMIT_HASH}

docker rmi ${TARGET_IMAGE} 
