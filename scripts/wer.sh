#!/bin/bash -e

source ../scripts/run-expt.sh "${0}"

module purge
module load sctk

results () {
    local test_set="${1}"
    "${PROJECT_SCRIPT_DIR}"/score.sh ${test_set} combined.txt > results.txt
}

# results devel
results eval