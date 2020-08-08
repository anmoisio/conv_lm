#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load sctk

results () {
    local test_set="${1}"
    "${PROJECT_SCRIPT_DIR}"/score.sh ${test_set} ${RESULTS_DIR}/${test_set}/lats-lms=10-order=5-combined-no-space.trn > results-${test_set}-no-space.txt
}

# results devel
results eval