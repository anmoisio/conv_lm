#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load sctk

results () {
    local test_set="${1}"
    "${PROJECT_SCRIPT_DIR}"/score.sh ${test_set} combined-lats-lms=*.trn > results.txt #${PROJECT_DIR}/results/kaldi-am/chain/${test_set}/lats-lms=*.trn 
}

results devel
# results eval