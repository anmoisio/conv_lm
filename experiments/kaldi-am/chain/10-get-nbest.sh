#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

n=1000

nbest () {
    local test_set="${1}"
    "${PROJECT_DIR}"/kaldi-utensils/cutlery/get_nbest.sh \
        --cmd "${SCORE_CMD}" \
        --num_best ${n} \
        "${EXPT_WORK_DIR}"/models/tdnn/graph \
        "${EXPT_WORK_DIR}/models/tdnn/decode-${test_set}" \
        "${PROJECT_DIR}/nbest/${test_set}/chain-${n}best"
}
nbest devel
nbest eval