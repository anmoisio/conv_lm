#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load sctk

results () {
    local test_set="${1}"
    "${PROJECT_SCRIPT_DIR}"/score.sh ${test_set} /scratch/work/moisioa3/conv_lm/experiments/theanolm-100k/expt10-seed3/decode/${test_set}/lambda=*-lms=*/*.trn > results-eval.txt
}

# results devel
results eval