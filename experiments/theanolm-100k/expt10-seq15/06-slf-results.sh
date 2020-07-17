#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load sctk

results () {
    local test_set="${1}"
    "${PROJECT_SCRIPT_DIR}"/score.sh ${test_set} /scratch/work/moisioa3/conv_lm/results/theanolm-100k/expt10-seed3-lats-tpn=62-beam=650-order=22-seed=2/${test_set}/lambda=*-lms=*.trn > results-${test_set}.txt
}

results devel
results eval