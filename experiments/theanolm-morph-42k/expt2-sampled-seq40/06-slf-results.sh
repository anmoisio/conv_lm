#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load sctk

decode_params="tpn=62-beam=650-order=22"

results () {
    local test_set="${1}"
    "${PROJECT_SCRIPT_DIR}"/score.sh ${test_set} \
        ${PROJECT_DIR}/results/${EXPT_NAME}/${EXPT_PARAMS}-lats-${decode_params}/${test_set}/lambda=*-lms=*-combined.trn \
        > results-${test_set}-combined-new.txt
}

# results devel
results eval