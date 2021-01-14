#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load sctk

decode_params="tpn=62-beam=650-order=22"

results () {
    local test_set="${1}"
    ../../../scripts/score.sh ${test_set} \
        /m/triton/scratch/work/moisioa3/conv_lm/results/${EXPT_NAME}/${EXPT_PARAMS}-lats-${decode_params}/${test_set}/lambda=*-lms=*.trn \
        > results-${test_set}.txt
}

# results devel
results eval