#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

nbest () {
    local test_set="${1}"
    "${PROJECT_DIR}"/kaldi-utensils/cutlery/get_nbest.sh --cmd "${SCORE_CMD}" \
        "${EXPT_WORK_DIR}"/models/tdnn/graph \
        "${EXPT_WORK_DIR}/models/tdnn/decode-${test_set}" \
        "${PROJECT_DIR}/nbest/${test_set}/chain-50best"
}
nbest devel
nbest eval