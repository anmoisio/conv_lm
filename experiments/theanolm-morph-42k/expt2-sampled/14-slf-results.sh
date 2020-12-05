#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load sctk

results () {
    local test_set="${1}"
    "${PROJECT_SCRIPT_DIR}"/score.sh ${test_set} \
        /scratch/work/moisioa3/conv_lm/results/theanolm-morph-42k/expt2-sampled/${test_set}/*10-combined.trn \
        > results-${test_set}-lstm-50best-baselinelms10-actual.txt
}

results devel
# results eval