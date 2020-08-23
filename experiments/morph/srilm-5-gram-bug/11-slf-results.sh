#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load sctk

results () {
    local test_set="${1}"
    "${PROJECT_SCRIPT_DIR}"/score.sh ${test_set} ${RESULTS_DIR}-defaultbeam/${test_set}/lats-lms={?,??}-combined.trn > results-${test_set}-defaultbeam.txt
}

results devel
# results eval